# {{{ Exports
export PATH="${HOME}/.bin:${HOME}/.local/bin:${PATH}"
export HISTIGNORE="&:bg:fg:ll:h"
export HISTCONTROL=ignoreboth:erasedups
export LC_ALL="en_US.UTF-8"
export GPG_TTY=$(tty)
export PS1="\[\033[32m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\W \[\033[0;32m\]>\[\033[0m\] "
export NPM_PACKAGES="${HOME}/.npm/packages"
export OWLLIB_COLOR=1
export EDITOR="nvim"

if [[ -d "${NPM_PACKAGES}/bin" ]]; then
	export PATH="${NPM_PACKAGES}/bin:${PATH}"
fi

if [[ -d "${NPM_PACKAGES}/lib64/node_modules" ]]; then
	export NODE_PATH="${NPM_PACKAGES}/lib64/node_modules"
fi
# }}}

# {{{ Interactiveness check
case $- in
    *i*) ;;
      *) return;;
esac
# }}}

# {{{ Colors
NO_COLOR="\[\e[0m\]"
RED_COLOR="\[\e[38;5;196m\]"
GREEN_COLOR="\[\e[38;5;49m\]"
CYAN_COLOR="\[\e[38;5;51m\]"
# }}}

# {{{ Settings
ulimit -S -c 0

shopt -s cmdhist
shopt -s extglob
shopt -s histappend histreedit histverify
shopt -s hostcomplete
shopt -s huponexit
shopt -s checkwinsize
# }}}

# {{{ Includes
declare _sensitive_path="${HOME}/.config/env.sensitive"
if [[ -d "${_sensitive_path}" ]]; then
  for f in ${_sensitive_path}/*; do
    source "${f}"
  done
fi
# }}}

# {{{ Completion
if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_copmletion
fi
# }}}

# {{{ Functions
ssh() {
  if [[ -n "${TMUX}" ]]; then
    # Note: Options without parameter were hardcoded,
    # in order to distinguish an option's parameter from the destination.
    #
    #                   s/[[:space:]]*\(\( | spaces before options
    #     \(-[46AaCfGgKkMNnqsTtVvXxYy]\)\| | option without parameter
    #                     \(-[^[:space:]]* | option
    # \([[:space:]]\+[^[:space:]]*\)\?\)\) | parameter
    #                      [[:space:]]*\)* | spaces between options
    #                        [[:space:]]\+ | spaces before destination
    #                \([^-][^[:space:]]*\) | destination
    #                                   .* | command
    #                                 /\6/ | replace with destination
    tmux rename-window "$(echo "$@" \
      | sed 's/[[:space:]]*\(\(\(-[46AaCfGgKkMNnqsTtVvXxYy]\)\|\(-[^[:space:]]*\([[:space:]]\+[^[:space:]]*\)\?\)\)[[:space:]]*\)*[[:space:]]*\(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|\([-a-z0-9_]\+\.[-a-z0-9_]\+\)\).*/\6/')"
    command ssh "$@"
    tmux set-window-option automatic-rename "on" 1> /dev/null
  else
    command ssh "$@"
  fi
}
#ssh() {
#    local hostname=""
#
#    while read key value; do
#        case "$key" in
#            hostname)
#                if [[ "${value}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
#                    hostname=${value}
#                else
#                    hostname=${value//.*}
#                fi
#                ;;
#        esac
#    done < <(/usr/bin/ssh -G "$@")
#
#    if [[ -n "$hostname" ]] && [[ -n "$TMUX" ]]; then
#        tmux rename-window "$hostname"
#        /usr/bin/ssh "$@"
#        tmux rename-window "bash"
#    else
#        /usr/bin/ssh "$@"
#    fi
#}

enable_gpg_with_ssh() {
	if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
	     gpg-connect-agent /bye &> /dev/null
	fi

	unset SSH_AGENT_PID
	if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	    # export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
	    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	fi

    gpg-connect-agent updatestartuptty /bye > /dev/null
}

prompt_callback() {
	if [[ -n "${WORK_ENV}" ]]; then
		echo -e "${WORK_ENV} "
	fi
}

set_prompt() {
	export PS1="$(prompt_callback)\[\033[32m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\W \[\033[0;32m\]>\[\033[0m\] "
}

enable_git_helper() {
	export GIT_PROMPT_ONLY_IN_REPO=1
	export GIT_PROMPT_LEADING_SPACE=0
	export GIT_PROMPT_START="[\[\e[32m\]\$(date +%H:%M)\[\e[0m\]] "
    export GIT_PROMPT_END="\n\[\e[32m\]\u@\h\[\e[0m\]:\[\e[1;32m\]\W \[\e[0;32m\]>\[\e[0m\] "
	source ~/.bash-git-prompt/gitprompt.sh
}
# }}}

# {{{ Try to add work env
PROMPT_COMMAND="set_prompt"
# }}}

# {{{ Alias
alias ls="ls -alh --color=always"

alias _ga="git add"
alias _gc="git commit"
alias _gm="git commit -m"
alias _gpu="git push"
alias _gp="git pull"
alias _gr="git rebase"

type nvim >/dev/null 2>&1 && alias vim="nvim"
type nvim >/dev/null 2>&1 && alias rvim="nvim -u ~/.config/nvim-rails/init.vim"
# }}}

# {{{ Initialize
enable_gpg_with_ssh
enable_git_helper
# }}}

# {{{ Configure LUA
export LUA_PATH="/usr/share/lua/5.1/?.lua;./?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib64/lua/5.1/?.lua;/usr/lib64/lua/5.1/?/init.lua;${HOME}/.luarocks/share/lua/5.1/?.lua;${HOME}/.luarocks/share/lua/5.1/?/init.lua;/usr/share/lua/5.1/share/lua/5.1/?.lua;/usr/share/lua/5.1/share/lua/5.1/?/init.lua"
export LUA_LIBDIR="${HOME}/.luarocks/share/lua/5.1"
export LUA_CPATH="./?.so;/usr/lib64/lua/5.1/?.so;/usr/lib64/lua/5.1/loadall.so;${HOME}/.luarocks/lib/lua/5.1/?.so;/usr/share/lua/5.1/lib/lua/5.1/?.so"
export PATH="${HOME}/.luarocks/bin:/usr/share/lua/5.1/bin:${PATH}"
# }}}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
