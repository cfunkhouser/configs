# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# These settings:
#  - Assume history is enabled!
#  - Exclude duplicate commands and commands prefixed with a space from history
#  - Set the in-memory history list to 1000
#  - Set the history file to 25000
#  - Set the history file timestamp format, and make it bold
#  - Append to history file, never overwrite it.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=25000
HISTTIMEFORMAT=$(echo -e '\e[34;1m%d %b %Y \e[36m%H:%M:%S %Z\e[0m ')
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set up a multi-line prompt. The first line is the interesting one, as it
# provides information about the exit conditions of the last executed command.
# If the last commend exited cleanly, the line begins with a green OK.
# If the last command exited uncleanly, the line begins with a
# white-with-red-background FAIL(X) where X is the exit code.
# Following this is the timestamp at which the command completed.
#
# The second line is the classic user@host:dir$
PS1='$(pretty_return_status) \D{%d %b %Y %H:%M:%S %Z}\n\u@\h:\W\\$ '

alias ll='ls -lF'
alias l='ls -CF'

# This is required for the PS1 setting above
function pretty_return_status () {
  RVAL=$?
  [[ ${RVAL} -ne 0 ]] && echo -e "\e[41mFAIL(${RVAL})\e[0m" \
    || echo -e "\e[32mOK\e[0m"
}

# Simple wrapper to search history
function histgrep () {
    if [[ ! "$1" ]] ; then
        echo "Usage: histgrep <search_term>" 1>&2
        return 1
    fi
    history |grep $1
}

function settodo () {
    if [[ ${#} -eq 0 ]] ; then
        rm ~/todo
    else
        echo ${@:1} > ~/todo
    fi
}

# Last step: Remind me what's up.
if [[ -f ~/todo ]] ; then
    cat ~/todo
fi
