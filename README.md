# ✦ dotfiles

> _my digital habitat. symlinked, version controlled, and ready to deploy._

**Arch Linux** · **KDE Plasma** · **Zsh + Zinit** · **Neovim** · managed with **GNU Stow**

---

## ✦ structure

```
dotfiles/
│
├── zsh/
│   └── .zshrc               # shell config, Zinit plugins
│
├── bash/
│   ├── .bashrc
│   ├── .bash_profile
│   └── .bash_logout
│
├── git/
│   └── .gitconfig           # global git config
│
├── gtk/
│   └── .gtkrc-2.0           # GTK2 theming
│
├── profile/
│   └── .profile
│
├── config/
│   └── .config/
│       └── nvim/            # neovim config
│
├── install.sh               # fresh machine installer
└── README.md
```

---

## ✦ how stow works

Stow creates symlinks from `~/dotfiles/<package>/` into `~`.
The real file lives in the repo — `~` only sees a pointer.

```
~/.zshrc  ──►  ~/dotfiles/zsh/.zshrc
```

edit in `~/dotfiles/`, changes reflect instantly. that's it.

---

## ✦ manual usage

**stow a single package**
```bash
cd ~/dotfiles
stow zsh
```

**stow everything at once**
```bash
cd ~/dotfiles
stow */
```

**unstow (remove symlinks)**
```bash
stow -D zsh
```

**restow (useful after adding new files)**
```bash
stow -R zsh
```

**add a new config**
```bash
mkdir -p ~/dotfiles/config/.config/kitty
mv ~/.config/kitty ~/dotfiles/config/.config/
cd ~/dotfiles && stow -R config
git add . && git commit -m "add: kitty" && git push
```

---

## ✦ fresh install

```bash
bash <(curl -s https://raw.githubusercontent.com/neo-unplugged/dotfiles/main/install.sh)
```

clones the repo → installs packages → backs up conflicts → stows everything.

---

## ✦ machine

| | |
|---|---|
| **OS** | Arch Linux |
| **WM** | KDE Plasma 6 (Wayland) |
| **Shell** | Zsh + Zinit |
| **Editor** | Neovim |
| **Terminal** | — |

---

<p align="center"><i>the holy 3 ps — physics · philosophy · programming</i></p>
