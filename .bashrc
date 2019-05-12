### Troubleshooting {{{
	source '/home/chris/.profile'
### }}}
### Prompt {{{
	PS1='ƒ '
### }}}
### History {{{
	# csh style history expansion annoys me
	set +H
	# Default behaviour is to have a per-session command history (HISTSIZE),
	# which is saved to HISTFILE after the end of the session, and then to
	# check HISTFILE against HISTFILESIZE and truncate the file if it has more
	# lines on next startup.
	# More here:
	# https://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize
	# Only append to HISTFILE, don't overwrite.
	shopt -s histappend
	# Record multi line commands as one liners for easier searching in HISTFILE.
	shopt -s cmdhist
	# Instead of immediately executing history expansions, display the result
	# in the readline buffer first.
	shopt -s histverify
	# Set the max number of lines stored in the history file to -1, unlmited,
	# which inhibits truncation.
	HISTFILESIZE=-1
	# Set both the number of commands remembered in the session, and the number
	# loaded at startup in the interactive shell session to -1, unlimited.
	HISTSIZE=-1
	# More useful timestamps in HISTFILE. '%F' = '%Y-%m-%d', '%T' = '%H:%M:%S'
	HISTTIMEFORMAT='%F %T  '
	# Record each line to HISTFILE when it's issued, instead of at the end of the
	# shell session.
	PROMPT_COMMAND='history -a'
	# Dont record some commands.
	export HISTIGNORE="exit:fc:history:clear"
	# Dont record commands preceded with spaces.
	export HISTCONTROL='ignorespaces'
### }}}
### Globbing {{{
	# Return an error exit status if no matches for a glob pattern are found during filename expansion.
	shopt -s failglob
	# Make the collating sequence for range globbing patterns behave like the traditional C locale.
	shopt -s globasciiranges
	# Use regex-esq globbing features. Careful with this.
	shopt -s extglob
### }}}
### Redirection {{{
	# Prevent accidental overwriting of files when using redirections.
	set -o noclobber
### }}}
### Aliases {{{
	# remove existing aliases
	unalias -a
	# trun off aliases
	shopt -u expand_aliases
	# except for this one
	alias vim=vimx
	# shellcheck disable=SC2034
	declare -n delim='IFS'
### }}}
### Terminal {{{
	# Disable the C-q and C-s flow control keyboard shortcuts of the tty driver.
	# https://unix.stackexchange.com/questions/137842/what-is-the-point-of-ctrl-s
	# info coreutils stty Input
	stty -ixon
	# Update LINES and COLUMNS after each command.
	shopt -s checkwinsize
### }}}
### Paranoia Settings {{{
	# redundant, set in /etc/login.defs
	umask 0077
### }}}
### Locally Installed Utilities {{{
	fzf_keybindings='/usr/share/fzf/shell/key-bindings.bash'
	if [[ -f "$fzf_keybindings" ]]; then
		# shellcheck source=/usr/share/fzf/shell/key-bindings.bash
		source "$fzf_keybindings"
	fi
### }}}

