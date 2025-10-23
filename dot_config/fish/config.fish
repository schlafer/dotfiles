if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Initialize zoxide
zoxide init fish | source

# Aliases (same as in bash/zsh)
alias z="__zoxide_z"
alias zi="__zoxide_zi"

# eza
alias ls="eza --icons --group-directories-first -lh"
alias lla="eza -lha --icons"
alias lt="eza --tree --icons"
alias llt="eza -lh --tree" # long view tree
alias lS="eza -lh --sort=size" # sort by size
alias lD="eza -lh --sort=date" # sort by date
alias lg="eza -lh --git" # show git status

# Directories
alias --save ..='cd ..'
alias --save ...='cd ../..'
alias --save ....='cd ../../..'

# Tools
alias --save g='git'
alias --save d='docker'

# Git
alias --save gcm='git commit -m'
alias --save gcam='git commit -a -m'
alias --save gcad='git commit -a --amend'
