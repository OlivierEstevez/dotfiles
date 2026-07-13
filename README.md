# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

Tracked:

- Homebrew (`Brewfile`)
- oh-my-zsh (custom theme + plugins)
- Ghostty
- Zed
- git config
- Lazyvim (not yet)
- Raycast (not yet)

## Bootstrap (automatic)

On a fresh macOS machine, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/OlivierEstevez/dotfiles/main/bootstrap.sh)"
```

After bootstrap finishes, restart shell:

```bash
exec zsh
```

## Bootstrap (manual)

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi
brew install chezmoi

# 3. Initialize from this repo
chezmoi init OlivierEstevez/dotfiles

# 4. Deploy the Brewfile and install packages
chezmoi apply ~/Brewfile
brew bundle

# 5. Authenticate with GitHub (required for private theme repos)
gh auth login

# 6. Apply dotfiles
chezmoi apply

# 7. Restart your shell
exec zsh
```

---

> [!WARNING]
> The Ghostty theme is cloned from a private repository. If you're not me, `chezmoi apply` will fail at the clone step. You'll need to remove or replace that dependency to use this setup.
