#
# .profile
#

source ~/.dotfiles/utils.sh


PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
export PATH

has_cmd lesspipe.sh && export LESSOPEN="|$HOME/.local/bin/lesspipe.sh %s"

# define prefered editor
has_cmd nvim && export VISUAL="nvim" && export EDITOR="nvim"

# define prefered terminal
has_cmd kitty && export TERMINAL="kitty"

# start ssh agent
[ -z "$SSH_AUTH_SOCK" ] && [ -z "$SSH_AGENT_PID" ] && eval "$(ssh-agent)"

# on missing language bug
if [ -z "$LANG" ] && on_osx; then
    export LANG='fr_FR.UTF-8'
fi
