declare -a PS_CALLBACKS=(
)

declare -a INCLUDES=(
    'colors'
    'config'
    'completion'
    'alias'
)

declare -a MODULES=(
    'tmux'
    'ssh'
    'python'
    'bash'
    'bash_git_prompt'
    'gpg'
)

export BASE_COLOR="32"

export BASE_PROMPT="\[\033[${BASE_COLOR}m\]\u@\h\[\033[0m\]:\[\033[1;${BASE_COLOR}m\]\W \[\033[0;${BASE_COLOR}m\]>\[\033[0m\] "
export DOTNET_ROOT=$HOME/.dotnet

export GIT_PROMPT_ONLY_IN_REPO=1
export GIT_PROMPT_LEADING_SPACE=0
export GIT_PROMPT_START="[\[\e[${BASE_COLOR}m\]\$(date +%H:%M)\[\e[0m\]] "
export GIT_PROMPT_END="\n\[\e[${BASE_COLOR}m\]\u@\h\[\e[0m\]:\[\e[1;${BASE_COLOR}m\]\W \[\e[0;${BASE_COLOR}m\]>\[\e[0m\] "
export PATH="${HOME}/.bin:${HOME}/.local/bin:${DOTNET_ROOT}:${DOTNET_ROOT}/tools:${PATH}"
export HISTIGNORE="&:bg:fg:ll:h"
export HISTCONTROL=ignoreboth:erasedups
export LC_ALL="en_US.UTF-8"

export GPG_TTY=$(tty)
export GPG_SSH_AGENT=1

export EDITOR='nvim'

export OWLLIB_COLOR=1

export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1
#export MOZ_WEBRENDER=1

export RADV_PERFTEST=aco

# OpenGL & vulkan
export MESA_GLTHREAD=true
export RADV_TEX_ANISO=16
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
export LIBVA_DRIVER_NAME=radeonsi
export LIBVA_DRIVERS_PATH=/usr/lib64/dri
