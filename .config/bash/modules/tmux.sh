unset tmux:inside
tmux:inside() {
    if [[ -z "${TMUX}" ]]; then
        return 1
    fi
}

unset tmux:session:get
tmux:session:get() {
    declare -n __session="$1"; shift

    if ! tmux:inside; then
        _debug "We're not in tmux session. Skip."
        return 2
    fi

    __session=$(tmux list-sessions | awk -F ':' '/attached/ {print $1}')
    if [[ -z "${__session}" ]]; then
        _error "Can't determine session"
        return 1
    fi
}

unset tmux:window:title:set
tmux:window:title:set() {
    declare title="$1"; shift

    if tmux:inside; then
        tmux rename-window "${title}"
    else
        _warn "Not in TMUX"
    fi
}

unset tmux:window:title:get
tmux:window:title:get() {
    declare -n __title="$1"; shift

    if tmux:inside; then
        __title=$(tmux list-windows | awk '/active/ {gsub(/*/,"",$2); print $2}')
    else
        return 1
    fi
}
