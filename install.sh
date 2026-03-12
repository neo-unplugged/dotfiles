#!/usr/bin/env bash
# =============================================================================
# install.sh — Fresh machine dotfiles installer
# Usage: bash install.sh
# =============================================================================

set -e

DOTFILES_REPO="https://github.com/neo-unplugged/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Packages to install via pacman
PACKAGES=(
  stow
  git
  zsh
  neovim
  curl
  wget
)

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log()  { echo -e "${CYAN}${BOLD}>>>${RESET} $1"; }
ok()   { echo -e "${GREEN}${BOLD}  ✓${RESET} $1"; }
warn() { echo -e "${YELLOW}${BOLD}  !${RESET} $1"; }
err()  { echo -e "${RED}${BOLD}  ✗${RESET} $1"; exit 1; }

# ── 1. Install packages ───────────────────────────────────────────────────────
log "Installing packages..."
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
ok "Packages installed"

# ── 2. Clone dotfiles repo ────────────────────────────────────────────────────
if [ -d "$DOTFILES_DIR" ]; then
  warn "~/dotfiles already exists, pulling latest..."
  git -C "$DOTFILES_DIR" pull
else
  log "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  ok "Cloned to $DOTFILES_DIR"
fi

# ── 3. Backup conflicts & stow ────────────────────────────────────────────────
log "Stowing packages..."
mkdir -p "$BACKUP_DIR"

cd "$DOTFILES_DIR"

for pkg in */; do
  pkg="${pkg%/}"

  # Dry-run to detect conflicts
  conflicts=$(stow --no-folding --simulate "$pkg" 2>&1 | grep "existing target" || true)

  if [ -n "$conflicts" ]; then
    warn "Conflicts in '$pkg', backing up..."
    echo "$conflicts" | while read -r line; do
      file=$(echo "$line" | awk '{print $NF}')
      if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
        warn "  Backed up ~/$file"
      fi
    done
  fi

  stow --no-folding "$pkg" && ok "stow $pkg"
done

# ── 4. Done ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}${BOLD}  Dotfiles installed!${RESET}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
  echo -e "  Backups saved to: ${YELLOW}$BACKUP_DIR${RESET}"
fi

echo -e "  Restart shell or run: ${CYAN}source ~/.zshrc${RESET}"
echo ""
