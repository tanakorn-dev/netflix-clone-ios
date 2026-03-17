#!/bin/bash
# =============================================================
# setup.sh — init git repo and push to GitHub via SSH
# Usage: bash setup.sh YOUR_GITHUB_USERNAME
# =============================================================

set -e

GITHUB_USERNAME="${1}"
REPO_NAME="netflix-clone-ios"
SSH_REMOTE="git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
SSH_KEY_DEFAULT="$HOME/.ssh/id_ed25519"
SSH_KEY_FALLBACK="$HOME/.ssh/id_rsa"

if [ -z "$GITHUB_USERNAME" ]; then
  echo "❌  Usage: bash setup.sh YOUR_GITHUB_USERNAME"
  exit 1
fi

echo ""
echo "🎬  Netflix Clone iOS — Git Setup (SSH)"
echo "========================================="
echo "Remote: $SSH_REMOTE"
echo ""

# ── Step 1: check SSH key exists ─────────────────────────────
echo "🔑  Checking SSH key..."

if [ -f "$SSH_KEY_DEFAULT" ]; then
  SSH_KEY="$SSH_KEY_DEFAULT"
  echo "    Found: $SSH_KEY_DEFAULT"
elif [ -f "$SSH_KEY_FALLBACK" ]; then
  SSH_KEY="$SSH_KEY_FALLBACK"
  echo "    Found: $SSH_KEY_FALLBACK"
else
  echo ""
  echo "    No SSH key found. Generating one now..."
  read -p "    Enter your GitHub email: " GIT_EMAIL
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_DEFAULT" -N ""
  SSH_KEY="$SSH_KEY_DEFAULT"
  echo ""
  echo "    ✅  Key generated: $SSH_KEY_DEFAULT"
fi

# ── Step 2: show public key + prompt to add to GitHub ────────
PUB_KEY="${SSH_KEY}.pub"
echo ""
echo "📋  Your public key (copy this to GitHub):"
echo "    Settings → SSH and GPG keys → New SSH key"
echo "    https://github.com/settings/ssh/new"
echo ""
echo "─────────────────────────────────────────────"
cat "$PUB_KEY"
echo "─────────────────────────────────────────────"
echo ""
read -p "Press Enter once the key is added to GitHub..."

# ── Step 3: test SSH connection ──────────────────────────────
echo ""
echo "🔗  Testing SSH connection to GitHub..."
if ssh -T git@github.com -o StrictHostKeyChecking=no 2>&1 | grep -q "successfully authenticated"; then
  echo "    ✅  SSH connection successful"
else
  echo "    ⚠️   Could not verify — continuing anyway (this is sometimes normal)"
fi

# ── Step 4: init git ─────────────────────────────────────────
echo ""
echo "📁  Initialising git..."
git init
git checkout -b main

# ── Step 5: stage all files ──────────────────────────────────
echo "📦  Staging files..."
git add .
git status

# ── Step 6: initial commit ───────────────────────────────────
echo ""
echo "✍️   Creating initial commit..."
git commit -m "feat: initial project structure — Phase 1

- Xcode project skeleton (SwiftUI, iOS 17+)
- Folder structure: Core / Features / Components / Models / Resources
- NetflixTheme.swift — design tokens (colors, spacing, typography)
- Data models: Movie, Genre, ContentRow, Profile
- MockData.swift — 8 sample shows + 7 content rows
- Placeholder screens: Splash, SignIn, ProfilePicker, Home, Search, Downloads
- MainTabView with custom tab bar scaffold
- .gitignore for Xcode/Swift"

# ── Step 7: add SSH remote ───────────────────────────────────
echo ""
echo "🔗  Adding GitHub remote (SSH)..."
git remote add origin "$SSH_REMOTE"
echo "    Remote: $(git remote get-url origin)"

# ── Step 8: push ─────────────────────────────────────────────
echo ""
echo "⚠️   Make sure the repo exists on GitHub:"
echo "     https://github.com/new"
echo "     Name: $REPO_NAME"
echo "     Visibility: Public or Private"
echo "     ❌ Do NOT add README / .gitignore (already in project)"
echo ""
read -p "Press Enter when the repo is created on GitHub..."

echo ""
echo "🚀  Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅  Done! View your repo at:"
echo "    https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""
echo "Next step → open the project in Xcode:"
echo "    open NetflixClone.xcodeproj"
