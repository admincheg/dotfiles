declare BASE_PATH="${HOME}/.config/bash"

declare -a INIT_INCLUDES=(
    'lib'
)

if [[ -f "${BASE_PATH}/init/env.sh" ]]; then
    source "${BASE_PATH}/init/env.sh"
fi

case $- in
    *i*) ;;
      *) return;;
esac

for inc in "${INIT_INCLUDES[@]}"; do
    declare include="${BASE_PATH}/init/${inc}.sh"

    if [[ -f "${include}" ]]; then
        source "${include}"
    fi
done

for inc in "${INCLUDES[@]}"; do
    declare include="${BASE_PATH}/includes/${inc}.sh"

    if [[ -f "${include}" ]]; then
        _debug "Load include ${inc}"
        source "${include}"
    fi
done

for module in "${MODULES[@]}"; do
    module_path="${BASE_PATH}/modules/${module}.sh"

    if [[ -f "${module_path}" ]]; then
        _debug "Load module ${module}"
        source "${module_path}"

        declare init_func="${module}:init"
        declare init=$(type -t "${init_func}")
        if [[ "${init}" == 'function' ]]; then
            ${init_func}
        fi
    fi
done
