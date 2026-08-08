unset bash:prompt
bash:prompt() {
    declare callbacks=''

    bash:prompt:callback callbacks
    export PS1="${callbacks}${BASE_PROMPT}"
}

unset bash:prompt:callback
bash:prompt:callback() {
    declare -n __callbacks="$1"; shift

    for callback in "${PS_CALLBACKS[@]}"; do
        __callbacks="${__callbacks}\$(${callback})"
    done
}

unset bash:init
bash:init() {
    bash:prompt
}

unset bash:test
bash:test() {
    echo "[test] "
}

unset bash:cd
bash:cd() {
    declare -a args=( "$@" )

    builtin cd "$@"

    declare check=$(type -t python:venv:toggle)
    if [[ "${check}" == 'function' ]]; then
        python:venv:toggle
    fi
}
