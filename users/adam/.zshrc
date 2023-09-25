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
# alias len="pbpaste | python -c 'import sys; print(len(sys.stdin.read().strip()))'"
#

tn () {
  tmux new -s $(basename $(pwd))
}

att () {
  tmux attach -t "$1" # 2> /dev/null;
}

brain () {

  if ! att brain; then
    pushd && cd "/Users/adam/Dropbox/brain"

    tmux \
      new -d -s brain "vim ./now.md" \; \
      splitw -h 'vim .'

    popd 
    att brain
  fi
}

# TODO: templatize this
# but also it should work
blog () {

  if ! att blog; then
    pushd && cd "/Users/adam/Dropbox/projects/blog"

    echo " ok then "

    tmux \
      new -d -s blog "nvim ." \; \
      splitw -h "bat flake.nix" \; # put watch command in the project and call from here

    popd 


    echo " hopoe that worked "
    att blog
  fi
}

