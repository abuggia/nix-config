
tmux_attach_if_session () {
  if tmux has -t "=$1"  2> /dev/null; then
    tmux attach -t "=$1"
    exit 0
  fi
}

brain () {
  tmux_attach_if_session 'brain'
  dir="/Users/adam/Dropbox/brain"

  tmux \
    new -d -s brain -c "${dir}" "vim ./now.md" \; \
    splitw -h -c "${dir}" 'vim .' \; \
    attach
}
