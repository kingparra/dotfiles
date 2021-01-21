if test -z "$PROFILEREAD"; then
    source /etc/profile
fi

export PATH=\
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

export EDITOR=/usr/bin/vimx
export LESS=FXR
