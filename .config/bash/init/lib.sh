if [[ -f "${HOME}/.local/share/owllib/helpers.sh" ]]; then
    source "${HOME}/.local/share/owllib/helpers.sh"
else
    _info() {
        echo "[INFO]"
        echo "$@"
    }

    _warn() {
        echo "[WARN]"
        echo "$@"
    }

    _error() {
        echo "[ERR ]"
        echo "$@"
    }

    _debug() {
        echo "[DBG ]"
        echo "$@"
    }
fi
