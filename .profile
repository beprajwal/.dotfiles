export PATH="$PATH:$HOME/.local/bin"
export GO="/usr/local/go"
export PATH="$PATH:$GO/bin"
export GO_HOME="$HOME/go"
export PATH="$PATH:$GO_HOME/bin"
export PATH="$PATH:$HOME/scripts"
export TERMINAL="ghostty"
export EDITOR="nvim"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
