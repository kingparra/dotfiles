# global defs, path
if  [[ -f /etc/bashrc ]] &&
	[[ "$BASHRCSOURCED" != Y ]]
then
	source /etc/bashrc
fi

fzf=/usr/share/fzf/shell/key-bindings.bash
if [[ -f "$fzf" ]]; then source "$fzf"; fi

# prompt
PS1='ƒ '

# word splitting
IFS=$'\0'

# history
set +H
shopt -s histappend
shopt -s cmdhist
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
unalias -a
shopt -u expand_aliases
alias vim=vimx

# terminal
stty -ixon
shopt -s checkwinsize

# paranoia
umask 0077

