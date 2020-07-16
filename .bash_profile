if test -z "$PROFILEREAD"; then
    source /etc/profile
fi

export PATH=\
/home/chris/.cargo/bin:\
/home/chris/.local/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/bin:\
/sbin:\
/opt

export EDITOR=/usr/bin/vim
export LESS=FXR
