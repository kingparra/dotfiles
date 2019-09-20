# global defs, path
. /usr/share/fzf/shell/key-bindings.bash
. /usr/share/bash-completion/bash_completion
complete -C "$HOME"/.local/bin/vault vault

# prompt
PS1=$'\nƒ '

# word splitting
IFS=$'\0'

# function tracing
shopt -s extdebug
dbg() { declare -p LINENO BASH_LINENO BASH_SOURCE FUNCNAME; }

# history
shopt -s cmdhist
shopt -s histappend
shopt -s histverify
HISTFILESIZE=-1
HISTSIZE=-1
HISTTIMEFORMAT='%F %T  '
PROMPT_COMMAND='history -a'

# globbing
shopt -s globasciiranges
shopt -s extglob
shopt -s globstar

# redirection
set -o noclobber

# aliases
alias vim=vimx

# terminal
stty -ixon
shopt -s checkwinsize

# paranoia
umask 0077

