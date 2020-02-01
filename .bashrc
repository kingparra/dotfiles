# completion scripts
. /usr/share/bash-completion/completions/fzf-key-bindings
. /usr/share/bash-completion/completions/fzf

# prompt
PS1="ƒ "

# word splitting
#IFS=$'\0' # breaks tab completion for some commands

# function tracing
shopt -s extdebug
dbg() { declare -p LINENO BASH_LINENO BASH_SOURCE FUNCNAME >&2; }

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
# So filenames that begin with - aren't treated as option arguments.
# https://soptik.tech/articles/beware-of-shell-globs.html
# Use C-x * or C-M-e to test your globs before executing a command.
GLOBIGNORE+='-*:*\`*:..:*Projects*'

# redirection
set -o noclobber

# terminal
stty -ixon
shopt -s checkwinsize

# paranoia
umask 0077

# annoyances
export MAN_POSIXLY_CORRECT=1

