unset ssh:config:path
ssh:config:path() {
    declare -n __path="$1"; shift
    declare session=''

    __path="${HOME}/.ssh"

    tmux:session:get session

    declare -i ret=$?

    if [[ ${ret} -eq 1 ]]; then
        _debug "Tmux session is not determined, fallback to default"
        return 1
    elif [[ ${ret} -eq 2 ]]; then
        _debug "Use default path"
        return
    fi

    declare exact_path="${__path}/${session}"
    if [[ ! -d "${exact_path}" ]]; then
        _warn "SSH config directory for ${session} is not found, fallback to default"
        return 1
    fi

    __path="${exact_path}"
}

unset ssh:config:resolve
ssh:config:resolve() {
    declare -n __config="$1"; shift
    declare path=''

    ssh:config:path path
    declare -i ret=$?

    __config="${path}/config"

    _debug "Config resolved to ${__config} (ret: ${ret})"

    if [[ ${ret} -gt 0 ]]; then
        return 2
    elif [[ ! -f "${path}/config" ]]; then
        return 1
    fi

}

unset ssh:args:update
ssh:args:update() {
    declare -n __args="$1"; shift
    declare -i configured=0

    for arg in "${__args[@]}"; do
        case "${arg}" in
            -F*)
                _debug "SSH config specified manualy"
                configured=1
        esac
    done

    if [[ ${configured} -eq 0 ]]; then
        declare config=''
        ssh:config:resolve config

        if [[ $? -eq 0 ]]; then
            __args=( '-F' "${config}" "${__args[@]}" )
        fi
    fi
}

unset ssh:hostname:normalize
ssh:hostname:normalize() {
    declare -n __hostname="$1"; shift

    if [[ "${__hostname}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ || "${__hostname}" =~ ^[:0-9a-f]+$ ]]; then
        return
    else
        declare -a parts=()
        IFS='.' read -a parts <<< "${__hostname}"

        if [[ ${#parts[@]} -gt 2 ]]; then
            __hostname="${parts[0]}.${parts[1]}"
        fi
    fi
}

unset scp:connect
scp:connect() {
    declare -a args=( "$@" )
    declare config=''

    if [[ ${#args[@]} -eq 0 ]]; then
        _error "No arguments specified"
        return 255
    fi

    ssh:args:update args
    _debug "SCP args is ${args[@]}"

    declare wname=''
    tmux:window:title:get wname
    if [[ $? -eq 0 ]]; then
        tmux:window:title:set "scp"
    fi

    _debug "Old window name ${wname}"

    _debug "Invoke original scp"
    command scp "${args[@]}"

    tmux:window:title:set "${wname}"
}

unset ssh:connect
ssh:connect() {
    declare -a args=( "$@" )
    declare config=''

    if [[ ${#args[@]} -eq 0 ]]; then
        _error "Host for connection is not specified"
        return 255
    fi

    ssh:args:update args

    declare tmp="SSH args is ${args[@]}"
    _debug "${tmp}"

    declare real_hostname=$(command ssh -G "${args[@]}" | awk '/^hostname/ {print $2}')
    ssh:hostname:normalize real_hostname

    _debug "Normalized hostname ${real_hostname}"

    declare wname=''
    tmux:window:title:get wname
    if [[ $? -eq 0 ]]; then
        tmux:window:title:set "${real_hostname}"
    fi

    _debug "Old window name ${wname}"

    _debug "Invoke original ssh"
    TERM='xterm-256color' command ssh "${args[@]}"

    tmux:window:title:set "${wname}"
}

unset ssh:pubkey
ssh:pubkey() {
    declare name="$1"; shift

    if [[ -z "${name}" ]]; then
        name="id_rsa"
    fi

    declare path=''
    ssh:config:path path

    if [[ -f "${path}/${name}" ]]; then
        ssh-keygen -y -f "${path}/${name}"
    else
        _error "Private key ${path}/${name} is not found"
        return 1
    fi
}
