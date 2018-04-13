#
# .profile
#

source ~/.dotfiles/utils.sh


export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# define prefered terminal
has_cmd termite && export TERMINAL="termite"

# start ssh agent
eval "$(ssh-agent)"

# on missing language bug
if [ -z "$LANG" ] && on_osx; then
    export LANG='fr_FR.UTF-8'
fi
