bind \cw backward-kill-bigword # <Control-w> kills a word back, even if it has punctuation in it
# ...we already have <Alt-Backspace> to kill an unpunctuated word back
bind \eB backward-bigword # <Alt-Shift-b> moves back a word, even if it has punctuation in it
# ...we already have <Alt-b> to move an unpunctuated word back

# Enable key bindings for fzf (Control-r, Control-t, Alt-c).
source /usr/share/fzf/shell/key-bindings.fish && fzf_key_bindings
