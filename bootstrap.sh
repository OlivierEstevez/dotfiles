#!/usr/bin/env bash

set -euo pipefail

DOTFILES_REPO="olivierestevez/dotfiles"

echo "🚀 Bootstrapping macOS..."

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "📦 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this shell
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Install chezmoi
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "📦 Installing chezmoi..."
    brew install chezmoi
fi

# Initialize chezmoi
if ! chezmoi source-path >/dev/null 2>&1; then
    echo "📥 Initializing chezmoi..."
    chezmoi init "$DOTFILES_REPO"
fi

BREWFILE="$(chezmoi target-path Brewfile)"

echo "📦 Deploying Brewfile..."
chezmoi apply "$BREWFILE"

echo "📦 Installing Homebrew packages..."
brew bundle --file "$BREWFILE"

# Authenticate with GitHub if available
if command -v gh >/dev/null 2>&1 && ! gh auth status >/dev/null 2>&1; then
    echo
    echo "🔐 Please authenticate with GitHub to install some private repos"
    gh auth login
fi

echo "⚙️ Applying dotfiles..."
chezmoi apply

echo
echo "✅ Bootstrap complete!"
