alias ll="ls --color=auto -Fla"
alias lh="ls -ld .*"
alias ga="git commit -am"
alias path="tr ':' '\n' <<< \"$PATH\""
alias pw="openssl rand -base64 12"
alias gitlog="git log --graph --all --pretty='format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s'"
alias tl="tmux list-sessions"
alias ta="tmux attach -t "
alias rebuild="darwin-rebuild switch --flake ~/Dropbox/projects/config/flake.nix"
alias s="nix develop"
alias pythoni="nix-shell -p python312 --run 'python -i'"

tn () {
  tmux new -s $(basename $(pwd)) "vim . && zsh" \; splitw -h "zsh"
}

att () {
  tmux attach -t "$1" 2> /dev/null;
}

brain () {
  if ! att brain; then
    pushd && cd "/Users/adam/Dropbox/brain"
    tn && popd
  fi
}

config () {
  if ! att config; then
    pushd && cd "/Users/adam/Dropbox/projects/config"
    tn && popd
  fi
}

nf () {
  if ! att neovim-flake; then
    pushd && cd "/Users/adam/Dropbox/projects/neovim-flake"
    tn && popd
  fi
}
