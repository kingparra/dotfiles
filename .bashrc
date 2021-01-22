#!/usr/bin/env bash

# prompt
PS1='\[\e[30;47m\]∗ \[\e[m\] '

# word splitting
IFS=$'\0' # Breaks tab completion for many commands; They deserve it.

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
shopt -u dotglob
# Glob expansions turns filenames into arguments. Arguments may
# be treated either as options or files, depending on how the
# command you're supplying arguments to is written.
#
# GLOBIGNORE is used here to prevent glob expansion of some
# unusual file names that may be misintrepreted as options,
# or have shell metacharacters in them that can cause unwanted
# behaviour during further processing (which may do more expansions).
#
# See this link for an example:
#
# https://soptik.tech/articles/beware-of-shell-globs.html
#
# If unsure, use C-x g or C-x * to test your globs before executing a
# command.
#
# Prevent files starting with -;  Prevent file names with * in them.
#           vvv                   vvvv
GLOBIGNORE='-*:*\`*:..:*Projects*:*\**'
#              ^^^^ ^^ ^^^^^^^^^^
#              |||| || Don't touch my projects dir!
#              |||| Prevent acting on the parent dir by mistake.
#              Prevent file names that may cause accidental command
#              substitution.

# redirection
set -o noclobber

# terminal
stty -ixon
shopt -s checkwinsize

# aliases
# Remove distro provided aliases, since they suck.
unalias -a
# Disable alias expansion, but not alias definitions. The BASH_ALIASES
# assoc array will still be populated, and the readline shortcut C-M-e
# will still expand them explicitly.
shopt -u expand_aliases

# paranoia
umask 0077

# function tracing
shopt -s extdebug
dbg() { declare -p LINENO BASH_LINENO BASH_SOURCE FUNCNAME >&2; }

# reading and writing NUL delimited input
print0() { IFS=$'\0' printf -- '%s\0' "$@"; }
read0() { IFS=$'\0' read -r -d $'\0' "$@"; }
