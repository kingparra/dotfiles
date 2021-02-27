if test -z "$PROFILEREAD"; then
    source /etc/profile
fi

export PATH=\
/home/chris/.poetry/bin:\
/home/chris/.pyenv/bin:\
/home/chris/.cabal/bin:\
/home/chris/.ghcup/bin:\
/home/chris/.cargo/bin:\
/home/chris/.local/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/bin:\
/sbin:\
/opt

# Search for "hypermodern python" if this confuses you
eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"

export EDITOR=/usr/bin/vimx
export LESS=FXR
