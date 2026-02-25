PATH=$HOME/.local/bin:$PATH
PS1='$ '
eval "$(direnv hook bash)"
# direnv hook relies on PROMPT_COMMAND, which never fires in
# non-interactive shells. Export the environment directly instead.
# nix-direnv (enabled in configuration.nix) caches the nix evaluation
# so this call is fast on cache hit.
# We unset DIRENV_DIR to force a fresh export -- without this, direnv
# sees its own tracking variables in the inherited environment and
# thinks the env is already loaded, even when the PATH was not inherited.
if [[ ! $- == *i* ]]; then
  if [[ -z "${__DIRENV_EXPORTING:-}" ]]; then
    export __DIRENV_EXPORTING=1
    unset DIRENV_DIR DIRENV_DIFF DIRENV_WATCHES
    eval "$(direnv export bash 2>/dev/null)"
    unset __DIRENV_EXPORTING
  fi
fi
