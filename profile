#
# .profile
#

source ~/.dotfiles/utils.sh


export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# define prefered editor
has_cmd vim && export VISUAL="vim -nf"

# define prefered terminal
has_cmd termite && export TERMINAL="termite"

# start ssh agent
[ -z "$SSH_AUTH_SOCK" -a -z "$SSH_AGENT_PID" ] && eval "$(ssh-agent)"

# on missing language bug
if [ -z "$LANG" ] && on_osx; then
    export LANG='fr_FR.UTF-8'
fi
