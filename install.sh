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
  base-devel
  neovim
  tree-sitter-cli
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
err()  { echo -e "${RED}${BOLD}  ✗${RESET} $1"; }

# Tracking arrays
PKG_INSTALLED=()
PKG_SKIPPED=()
PKG_FAILED=()

STOW_OK=()
STOW_FAILED=()

# ── 1. Install packages ───────────────────────────────────────────────────────
log "Installing packages..."
echo ""

for pkg in "${PACKAGES[@]}"; do
  echo -ne "  ${CYAN}→${RESET} Installing ${BOLD}${pkg}${RESET}..."

  # Check if already installed
  if pacman -Qi "$pkg" &>/dev/null; then
    echo -e "\r  ${YELLOW}${BOLD}≈${RESET} ${BOLD}${pkg}${RESET} — already installed, skipped"
    PKG_SKIPPED+=("$pkg")
    continue
  fi

  # Try to install, capture stderr
  if output=$(sudo pacman -S --needed --noconfirm "$pkg" 2>&1); then
    echo -e "\r  ${GREEN}${BOLD}✓${RESET} ${BOLD}${pkg}${RESET} — installed"
    PKG_INSTALLED+=("$pkg")
  else
    echo -e "\r  ${RED}${BOLD}✗${RESET} ${BOLD}${pkg}${RESET} — FAILED"
    echo -e "    ${RED}$(echo "$output" | tail -1)${RESET}"
    PKG_FAILED+=("$pkg")
  fi
done

# ── Package summary ───────────────────────────────────────────────────────────
echo ""
echo -e "  ${GREEN}Installed:${RESET}  ${#PKG_INSTALLED[@]} package(s)"
[ ${#PKG_SKIPPED[@]}  -gt 0 ] && echo -e "  ${YELLOW}Skipped:${RESET}    ${PKG_SKIPPED[*]}"
[ ${#PKG_FAILED[@]}   -gt 0 ] && echo -e "  ${RED}Failed:${RESET}     ${PKG_FAILED[*]}"

if [ ${#PKG_FAILED[@]} -gt 0 ]; then
  echo ""
  warn "Some packages failed to install. Continuing anyway..."
fi

# ── 2. Clone dotfiles repo ────────────────────────────────────────────────────
echo ""
if [ -d "$DOTFILES_DIR" ]; then
  warn "~/dotfiles already exists, pulling latest..."
  git -C "$DOTFILES_DIR" pull
else
  log "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  ok "Cloned to $DOTFILES_DIR"
fi

# ── 3. Backup conflicts & stow ────────────────────────────────────────────────
echo ""
log "Stowing packages..."

cd "$DOTFILES_DIR"
for pkg in */; do
  pkg="${pkg%/}"

  # Dry-run to detect conflicts
  conflicts=$(stow --no-folding --simulate "$pkg" 2>&1 | grep "existing target" || true)

  if [ -n "$conflicts" ]; then
    warn "Conflicts in '$pkg', backing up..."
    mkdir -p "$BACKUP_DIR"
    echo "$conflicts" | while read -r line; do
      file=$(echo "$line" | sed 's/.*existing target is neither a link nor a stow member: //')
      if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
        warn "  Backed up ~/$file"
      fi
    done
  fi

  if stow --no-folding "$pkg" 2>/dev/null; then
    ok "stow $pkg"
    STOW_OK+=("$pkg")
  else
    err "stow $pkg — failed, skipping"
    STOW_FAILED+=("$pkg")
  fi
done

# ── 4. Final summary ──────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}${BOLD}  Dotfiles installed!${RESET}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Package results
echo -e "  ${BOLD}Packages${RESET}"
echo -e "  ${GREEN}✓ Installed:${RESET}  ${#PKG_INSTALLED[@]}"
echo -e "  ${YELLOW}≈ Skipped:${RESET}   ${#PKG_SKIPPED[@]}"
echo -e "  ${RED}✗ Failed:${RESET}    ${#PKG_FAILED[@]}"
[ ${#PKG_FAILED[@]} -gt 0 ] && echo -e "    ${RED}→ ${PKG_FAILED[*]}${RESET}"

# Stow results
echo ""
echo -e "  ${BOLD}Stow${RESET}"
echo -e "  ${GREEN}✓ OK:${RESET}        ${#STOW_OK[@]}"
echo -e "  ${RED}✗ Failed:${RESET}    ${#STOW_FAILED[@]}"
[ ${#STOW_FAILED[@]} -gt 0 ] && echo -e "    ${RED}→ ${STOW_FAILED[*]}${RESET}"

# Backup notice
echo ""
if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
  echo -e "  Backups saved to: ${YELLOW}$BACKUP_DIR${RESET}"
fi

echo -e "  Restart shell or run: ${CYAN}source ~/.zshrc${RESET}"
echo ""
