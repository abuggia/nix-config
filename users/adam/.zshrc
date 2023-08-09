alias ll="ls --color=auto -Fla"
alias lh="ls -ld .*"
alias vi="nvim"
alias ga="git commit -am"
alias path="tr ':' '\n' <<< \"$PATH\""
alias pw="openssl rand -base64 12"
alias gitlog="git log --graph --all --pretty='format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s'"
alias tl="tmux list-sessions"
alias ta="tmux attach -t "
alias rebuild="darwin-rebuild switch --flake ~/Dropbox/projects/macos-config/flake.nix"
alias config="cd ~/Dropbox/projects/macos-config; vim ."

# alias len="pbpaste | python -c 'import sys; print(len(sys.stdin.read().strip()))'"

brain () {

  if tmux has -t brain  2> /dev/null; then
    tmux attach -t brain

  else
    pushd &&
      cd "/Users/adam/Dropbox/brain" &&
      tmux \
        new -d -s brain "vim ./now.md" \; \
        splitw -h 'vim .' \; &&
      popd

    tmux attach -t brain
      
  fi
}
