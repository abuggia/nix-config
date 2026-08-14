# docseq — allocate the next number in a numbered document series (ADRs, plans, …).
#
#   docseq next <kind> [options]   reserve and print the next number
#   docseq peek <kind> [options]   print what `next` would return, reserving nothing
#   docseq log  <kind> [options]   print this repo's reservation ledger
#
# The number returned is one past the highest of:
#   * every number ever recorded in the series across ALL git refs (not just the
#     current worktree — sibling worktrees and unmerged branches hold numbers this
#     checkout cannot see), and
#   * every number this workstation has already reserved.
#
# Reservation is serialized by a per-(repo, kind) mutex, so two concurrent sessions
# can never be handed the same number. The ledger is workstation-local state; the
# git scan is what keeps it honest across clones, merges, and machines.

prog=docseq
lock=

die() { printf '%s: %s\n' "$prog" "$*" >&2; exit 1; }

usage() {
  cat >&2 <<'EOF'
usage: docseq <next|peek|log> <kind> [--repo DIR] [--dir PATH] [--pad N]
                                     [--note TEXT] [--timeout SECS]

kinds with a built-in directory:
  adr    docs/adr
  plan   docs/plans

Any other kind needs --dir. --repo defaults to the current directory; it may be
any worktree of the repo (all worktrees of one repo share a sequence).

  n=$(docseq next adr --note 'T7 thread anchors')   # -> 0066
  git mv ... docs/adr/"$n"-thread-anchors.md
EOF
  exit 2
}

[ $# -ge 1 ] || usage
cmd=$1; shift
case $cmd in
  next|peek|log) ;;
  -h|--help) usage ;;
  *) die "unknown command '$cmd' (want next, peek, or log)" ;;
esac

[ $# -ge 1 ] || usage
kind=$1; shift

repo=$PWD
dir=
pad=4
note=
timeout=60

while [ $# -gt 0 ]; do
  case $1 in
    --repo)    [ $# -ge 2 ] || die "--repo needs a value";    repo=$2; shift 2 ;;
    --dir)     [ $# -ge 2 ] || die "--dir needs a value";     dir=$2; shift 2 ;;
    --pad)     [ $# -ge 2 ] || die "--pad needs a value";     pad=$2; shift 2 ;;
    --note)    [ $# -ge 2 ] || die "--note needs a value";    note=$2; shift 2 ;;
    --timeout) [ $# -ge 2 ] || die "--timeout needs a value"; timeout=$2; shift 2 ;;
    *) die "unknown option '$1'" ;;
  esac
done

case $kind in
  adr|adrs)   kind=adr;  [ -n "$dir" ] || dir=docs/adr ;;
  plan|plans) kind=plan; [ -n "$dir" ] || dir=docs/plans ;;
esac
[ -n "$dir" ] || die "kind '$kind' has no built-in directory; pass --dir"
case $kind in
  *[!A-Za-z0-9._-]*) die "kind '$kind' must be alphanumeric, '.', '_' or '-'" ;;
esac
case $pad in ''|*[!0-9]*) die "--pad must be a number" ;; esac
case $timeout in ''|*[!0-9]*) die "--timeout must be a number" ;; esac

# --- locate the repo -------------------------------------------------------
# The git *common* dir is shared by every worktree of one repo (and is the repo
# itself when bare), so it is the right identity for "one sequence".
common=$(git -C "$repo" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
  || die "not a git repository: $repo"

if [ "$(basename "$common")" = ".git" ]; then
  repo_name=$(basename "$(dirname "$common")")
else
  repo_name=$(basename "${common%.git}")
fi

hash_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "$1" | sha256sum | cut -c1-12
  else
    printf '%s' "$1" | shasum -a 256 | cut -c1-12
  fi
}

state="${XDG_STATE_HOME:-$HOME/.local/state}/docseq/$repo_name-$(hash_of "$common")"
mkdir -p "$state"
lock="$state/$kind.lock"
ledger="$state/$kind.ledger"

# --- mutex -----------------------------------------------------------------
# mkdir is atomic on every filesystem that matters, and needs no flock (which
# macOS does not ship). The owner file lets a crashed holder's lock be broken.
acquire() {
  local waited=0 unclaimed=0 pid host started now
  while true; do
    if mkdir "$lock" 2>/dev/null; then
      # Claim it immediately. If this write fails, another process broke the
      # lock in the gap before we claimed it — lost race, go back and retry
      # rather than proceeding while holding a lock we no longer own.
      if printf '%s %s %s\n' "$$" "$(uname -n)" "$(date +%s)" \
           > "$lock/owner" 2>/dev/null; then
        trap 'rm -rf "$lock"' EXIT INT TERM
        return
      fi
      continue
    fi

    pid=; host=; started=
    if [ -r "$lock/owner" ]; then
      read -r pid host started < "$lock/owner" || true
    fi
    now=$(date +%s)
    case $started in ''|*[!0-9]*) started=$now ;; esac

    if [ -n "$pid" ]; then
      unclaimed=0
      # Holder is gone and the lock is old: break it. Both conditions matter —
      # a live pid is doing work, and a young lock may just be a fast holder
      # whose pid was recycled.
      if [ "$host" = "$(uname -n)" ] && ! kill -0 "$pid" 2>/dev/null \
         && [ $((now - started)) -gt 30 ]; then
        rm -rf "$lock"
        continue
      fi
    else
      # No owner recorded. Count only *consecutive* misses: a cumulative count
      # would eventually break a perfectly live lock during a busy queue.
      unclaimed=$((unclaimed + 1))
      if [ "$unclaimed" -gt 150 ]; then   # 30s never claimed: holder died in the gap
        rm -rf "$lock"
        continue
      fi
    fi

    sleep 0.2
    waited=$((waited + 1))
    [ "$waited" -le $((timeout * 5)) ] \
      || die "timed out after ${timeout}s waiting for $lock"
  done
}

# --- the two sources of truth ----------------------------------------------
git_max() {
  local out
  out=$(
    {
      # every path ever recorded under $dir, on every ref — including numbers
      # that were later renamed or deleted, which must never be handed out again
      git -C "$repo" log --all --name-only --pretty=format: -- "$dir" 2>/dev/null || true
      # plus files not committed anywhere yet, in this and every sibling worktree
      git -C "$repo" worktree list --porcelain 2>/dev/null | while read -r key val; do
        [ "$key" = worktree ] || continue
        [ -d "$val/$dir" ] || continue
        ls -1 "$val/$dir" 2>/dev/null || true
      done
    } | sed 's#.*/##' | grep -Eo '^[0-9]+' | sort -n | tail -1
  ) || true
  printf '%s' "${out:-0}"
}

ledger_max() {
  local out
  if [ ! -r "$ledger" ]; then printf 0; return; fi
  out=$(cut -f1 "$ledger" | grep -Eo '^[0-9]+' | sort -n | tail -1) || true
  printf '%s' "${out:-0}"
}

# --- commands --------------------------------------------------------------
if [ "$cmd" = log ]; then
  printf '%s\n' "$ledger" >&2
  if [ -r "$ledger" ]; then cat "$ledger"; fi
  exit 0
fi

acquire

from_git=$(git_max)
from_ledger=$(ledger_max)
max=$((10#$from_git))
if [ "$((10#$from_ledger))" -gt "$max" ]; then max=$((10#$from_ledger)); fi
next=$((max + 1))

if [ "$cmd" = next ]; then
  branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')
  printf '%0*d\t%s\t%s\t%s\t%s\n' \
    "$pad" "$next" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(uname -n)" "$branch" "$note" \
    >> "$ledger"
fi

printf '%0*d\n' "$pad" "$next"
