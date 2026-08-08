unset bash_git_pormpt:init
bash_git_prompt:init() {
    if [[ -f "${HOME}/.local/share/bash-git-prompt/gitprompt.sh" ]]; then
        source "${HOME}/.local/share/bash-git-prompt/gitprompt.sh"
    fi
}
