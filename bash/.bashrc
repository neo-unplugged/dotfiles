#
# ~/.bashrc
#

# Non-interactive guard
[[ $- != *i* ]] && return

# ── Prompt ────────────────────────────────────────────────────────────────────
export VIRTUAL_ENV_DISABLE_PROMPT=1

venv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "($(basename "$VIRTUAL_ENV"))"
    fi
}

#PS1='\[\e[0;32m\]┌──(\u@\h)\[\e[0m\]-[\[\e[0;34m\]\W\[\e[0m\]]\n\[\e[0;32m\]└─$(venv_info)\[\e[0m\]\$ '
PS1='\[\e[0;32m\]┌──(\u@\h)\[\e[0m\]-[\[\e[0;34m\]\W\[\e[0m\]]\n\[\e[0;32m\]└─\[\e[0m\]\[\e[1;33m\]$(venv_info)\[\e[0m\]\$ '

# ── Completion ────────────────────────────────────────────────────────────────
[ -r /usr/share/bash-completion/bash_completion ] && \
    source /usr/share/bash-completion/bash_completion

# ── History search ─────────────────────────────────────────────────────────────
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set show-all-if-ambiguous on'

# ── Aliases ───────────────────────────────────────────────────────────────────
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

# System (Arch)
alias update='sudo pacman -Sy'
alias upgrade='sudo pacman -Syu'
alias clean='sudo pacman -Rns $(pacman -Qdtq)'
alias shutdown='systemctl poweroff'
alias logout='pkill -KILL -u $USER'

# ── Env ───────────────────────────────────────────────────────────────────────
[ -f "$HOME/.cargo/env" ]     && source "$HOME/.cargo/env"
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]          && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="/home/neo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Go
export PATH="$PATH:$HOME/go/bin"

# Android
export ANDROID_HOME="$HOME/.local/share/android"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
