if test -z "$PROFILEREAD"; then . /etc/profile; else true; fi

export PATH=\
/home/chris/.cargo/bin:\
/home/chris/.local/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/sbin

export EDITOR=/usr/bin/vim

export LESS=FXR
