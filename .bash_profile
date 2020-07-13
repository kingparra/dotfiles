if test -z "$PROFILEREAD"; then
    source /etc/profile
fi

export PATH=\
/home/chris/.poetry/bin:\
/home/chris/.cargo/bin:\
/home/chris/.pyenv/bin:\
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

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
