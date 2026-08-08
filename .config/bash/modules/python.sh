unset python:venv:toggle
python:venv:toggle() {
    # Autoactivate python venv if exists
    if [[ -z "${VIRTUAL_ENV}" && -f "./.venv/bin/activate" ]]; then
        source "./.venv/bin/activate"
    # Autodeactivate python venv outside of project directory
    elif [[ -n "${VIRTUAL_ENV}" ]]; then
        declare proj_root=$(dirname "${VIRTUAL_ENV}")
        if [[ ! "${PWD}" =~ ^${proj_root}.*$ ]]; then
            declare check=$(type -t deactivate)
            _debug 'VENV deactivation'
            if [[ "${check}" == 'function' ]]; then
                deactivate

                # Dirty fix of OLD_GITPROMPT
                if [[ -n "${OLD_GITPROMPT}" ]]; then
                    export OLD_GITPROMPT="${PS1}"
                fi
            fi
        fi
    fi
}
