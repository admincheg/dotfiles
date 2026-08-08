unset gpg:init
gpg:init() {
    if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
        _debug "GPG agent is not started yet. Starting."
        gpg-connect-agent /bye &> /dev/null
    fi

    if [[ ${GPG_SSH_AGENT} -eq 1 ]]; then
        gpg:ssh
    fi

    gpg-connect-agent updatestartuptty /bye &> /dev/null
}

unset gpg:ssh
gpg:ssh() {
	unset SSH_AGENT_PID
	if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	fi
}
