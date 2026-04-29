#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='\[\e[0;32m\]┌──(\u@\h)\[\e[0m\]-[\[\e[0;34m\]\w\[\e[0m\]]\n\[\e[0;32m\]└─\[\e[0m\]\$ '

# Autosuggestions (history search)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set show-all-if-ambiguous on'

# Aliases
alias ls='eza --icons'
alias lst='eza --icons --tree -L 1'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ~='cd ~'

# Git
alias gi='git init'
alias ga='git add'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gc='git commit'
alias gca='git commit --amend'

# Env
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"

# System
alias update='sudo pacman -Sy'
alias upgrade='sudo pacman -Syu'
alias clean='sudo pacman -Rns $(pacman -Qdtq)'
alias shutdown='systemctl poweroff'
alias logout='pkill -KILL -u $USER'

# pnpm
export PNPM_HOME="/home/neo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$PATH:~/go/bin
