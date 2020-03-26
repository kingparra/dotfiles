# completion scripts
. /usr/share/bash-completion/completions/fzf-key-bindings
. /usr/share/bash-completion/completions/fzf

# prompt
PS1='\[\e[30;47m\]∗ \[\e[m\] '

# word splitting
# IFS=$'\0' # breaks tab completion for many commands

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
# So filenames that begin with "-" aren't treated as option arguments.
# https://soptik.tech/articles/beware-of-shell-globs.html
# Use C-x g or C-x * to test your globs before executing a command.
GLOBIGNORE+='-*:*\`*:..:*Projects*'

# redirection
set -o noclobber

# terminal
stty -ixon
shopt -s checkwinsize

# aliases
# Disable alias expansion, but not alias definitions. The BASH_ALIASES assoc
# array will still be populated, and the readline shortcut C-M-e will still
# expand them explicitly.
shopt -u expand_aliases

# paranoia
umask 0077

# annoyances
# Don't ask for section number every time
export MAN_POSIXLY_CORRECT=1

