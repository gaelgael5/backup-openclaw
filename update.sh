#!/bin/bash
#
# update.sh — Met a jour les agents OpenClaw depuis le repo backup-openclaw
#
# Usage (sur le serveur OpenClaw) :
#   bash -c "$(wget -qLO - https://raw.githubusercontent.com/gaelgael5/backup-openclaw/refs/heads/main/update.sh)"
#

set -euo pipefail

REPO_URL="https://github.com/gaelgael5/backup-openclaw.git"
OPENCLAW_BASE="/root/.openclaw"
TMP_DIR=$(mktemp -d)
AGENTS="orchestrator dev-flutter dev-python sysadmin legal marketer product strategist tester-flutter-qa ux-researcher"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# ------------------------------------------------------------
# Confirmation utilisateur
# ------------------------------------------------------------
echo ""
echo "========================================================"
echo "  MISE A JOUR DES AGENTS OPENCLAW"
echo "========================================================"
echo ""
echo "Ce script va :"
echo "  1. Telecharger la derniere version depuis GitHub"
echo "  2. Supprimer les anciens fichiers .md de chaque agent"
echo "  3. Copier les nouveaux fichiers .md a la place"
echo "  4. Mettre a jour le workspace-shared"
echo ""
echo "ATTENTION : Les fichiers .md actuels des agents seront ECRASES."
echo "Les fichiers non-.md (memory/, scripts, etc.) ne sont PAS touches."
echo ""
read -p "As-tu fait un backup du serveur avant ? (oui/non) : " confirm
echo ""

if [ "$confirm" != "oui" ]; then
    echo "Annule. Fais un backup d'abord :"
    echo "  cp -r $OPENCLAW_BASE ${OPENCLAW_BASE}.backup-\$(date +%Y%m%d-%H%M%S)"
    echo ""
    exit 1
fi

# ------------------------------------------------------------
# Telecharger le repo
# ------------------------------------------------------------
echo "Telechargement depuis GitHub..."
git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR/repo"
REPO_DIR="$TMP_DIR/repo/TeamProject"

if [ ! -d "$REPO_DIR" ]; then
    echo "ERREUR : Repertoire TeamProject introuvable dans le repo."
    exit 1
fi

echo "OK"
echo ""

# ------------------------------------------------------------
# Mise a jour de chaque agent
# ------------------------------------------------------------
updated=0
skipped=0

for agent in $AGENTS; do
    src_dir="$REPO_DIR/$agent"
    dest_dir="$OPENCLAW_BASE/workspace-$agent"

    if [ ! -d "$src_dir" ]; then
        echo "  SKIP  $agent (pas dans le repo)"
        skipped=$((skipped + 1))
        continue
    fi

    if [ ! -d "$dest_dir" ]; then
        echo "  SKIP  $agent (workspace $dest_dir inexistant)"
        skipped=$((skipped + 1))
        continue
    fi

    # Supprimer les anciens fichiers .md a la racine du workspace
    # (on ne touche PAS aux sous-dossiers comme memory/)
    find "$dest_dir" -maxdepth 1 -name "*.md" -type f -delete

    # Copier les nouveaux fichiers .md
    cp "$src_dir"/*.md "$dest_dir/" 2>/dev/null || true

    file_count=$(find "$dest_dir" -maxdepth 1 -name "*.md" -type f | wc -l)
    echo "  OK    $agent ($file_count fichiers)"
    updated=$((updated + 1))
done

# ------------------------------------------------------------
# Mise a jour du workspace-shared
# ------------------------------------------------------------
shared_src="$REPO_DIR/shared"
shared_dest="$OPENCLAW_BASE/workspace-shared"

if [ -d "$shared_src" ] && [ -d "$shared_dest" ]; then
    find "$shared_dest" -maxdepth 1 -name "*.md" -type f -delete
    cp "$shared_src"/*.md "$shared_dest/" 2>/dev/null || true
    file_count=$(find "$shared_dest" -maxdepth 1 -name "*.md" -type f | wc -l)
    echo "  OK    shared ($file_count fichiers)"
    updated=$((updated + 1))
elif [ -d "$shared_src" ]; then
    echo "  SKIP  shared (workspace $shared_dest inexistant)"
    skipped=$((skipped + 1))
fi

# ------------------------------------------------------------
# Resume
# ------------------------------------------------------------
echo ""
echo "========================================================"
echo "  TERMINE"
echo "========================================================"
echo "  Mis a jour : $updated"
echo "  Ignores    : $skipped"
echo ""
echo "Les agents vont charger les nouveaux fichiers au prochain"
echo "demarrage de session ou heartbeat."
echo ""
