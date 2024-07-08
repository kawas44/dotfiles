# My elvish conf

## load modules & define helpers

use epm
epm:install &silent-if-installed github.com/zzamboni/elvish-modules

use utils utl

## set external tools

utl:when-external starship {
  eval (starship init elvish)
}

utl:when-external carapace {
  eval (carapace _carapace|slurp)
}

utl:when-external zoxide {
  eval (cat ~/.config/elvish/zoxide.elv | slurp)
}

## configure hooks

fn print_duration {|m|
  if (< 8 $m[duration]) {
    var duration = (utl:seconds-to-str $m[duration])
    echo (styled (echo "  :::: Elapse time" $duration) dim italic)
  }
}
set edit:after-command = [$@edit:after-command $print_duration~]

## set aliases

use github.com/zzamboni/elvish-modules/alias

alias:new ls ls --color=auto
alias:new ll ls --color=auto -l
alias:new la ls --color=auto -la

alias:new gci git commit
alias:new gco git checkout
alias:new gfp git fetch --prune
alias:new gll git log --pretty=oneline --abbrev-commit --decorate
alias:new gpl git pull
alias:new gst git status --short
alias:new gk gitk --all

alias:new vi nvim

alias:new ssh kitty +kitten ssh

set edit:command-abbr['gs'] = 'gsutil'
alias:new gcat gsutil cat
alias:new gcp  gsutil -m cp
alias:new gdu  gsutil du
alias:new gls  gsutil ls

set edit:command-abbr['k'] = 'kubectl'

## set env variables
set E:LESSOPEN = "| ~/.local/bin/lesspipe.sh %s"

## set path
set paths = [~/.local/apps/go/workspace/bin
             ~/.fzf/bin
             ~/google-cloud-sdk/bin
             $@paths]
