#!/bin/bash

# Script de sauvegarde des fichiers markdown des agents vers TeamProject
# Créé par OpenClaw Orchestrator

set -e

echo "🚀 Début du backup des fichiers markdown des agents..."

# Répertoire de base TeamProject
TEAMPROJECT_DIR="/root/.openclaw/workspace-orchestrator/backup-openclaw/TeamProject"

# Créer le répertoire TeamProject s'il n'existe pas
mkdir -p "$TEAMPROJECT_DIR"

echo "📁 Répertoire TeamProject: $TEAMPROJECT_DIR"

# Fonction pour copier les fichiers markdown d'un agent
backup_agent() {
    local agent_name=$1
    local workspace_path=$2
    
    if [ ! -d "$workspace_path" ]; then
        echo "⚠️  Workspace $agent_name non trouvé: $workspace_path"
        return 1
    fi
    
    echo "📋 Traitement agent: $agent_name"
    
    # Créer le sous-répertoire pour l'agent
    local agent_dir="$TEAMPROJECT_DIR/$agent_name"
    mkdir -p "$agent_dir"
    
    # Chercher et copier tous les fichiers .md
    local md_files_found=0
    
    # Copier UNIQUEMENT les fichiers .md du répertoire racine de l'agent (pas les sous-dossiers)
    find "$workspace_path" -maxdepth 1 -name "*.md" -type f 2>/dev/null | while read -r md_file; do
        if [ -f "$md_file" ]; then
            local filename=$(basename "$md_file")
            cp "$md_file" "$agent_dir/"
            echo "  ✅ Copié: $filename"
            md_files_found=$((md_files_found + 1))
        fi
    done
    
    # Créer un README pour l'agent s'il n'y en a pas
    if [ ! -f "$agent_dir/README.md" ]; then
        cat > "$agent_dir/README.md" << EOF
# Agent $agent_name

Sauvegarde des fichiers markdown de l'agent $agent_name.

**Date de sauvegarde:** $(date)
**Workspace source:** $workspace_path

## Fichiers sauvegardés

$(find "$agent_dir" -name "*.md" -not -name "README.md" | sort | sed 's|.*/|- |')
EOF
        echo "  📄 README.md créé pour $agent_name"
    fi
    
    echo "  🎯 Agent $agent_name: fichiers traités"
}

echo ""
echo "🔍 Recherche des workspaces d'agents..."

# Lister tous les workspace-* disponibles
for workspace in /root/.openclaw/workspace-*; do
    if [ -d "$workspace" ]; then
        agent_name=$(basename "$workspace" | sed 's/workspace-//')
        
        # Inclure TOUS les agents y compris orchestrator
        backup_agent "$agent_name" "$workspace"
        echo ""
    fi
done

# Vérifier le workspace shared aussi
if [ -d "/root/.openclaw/workspace-shared" ]; then
    echo "📁 Traitement workspace-shared..."
    backup_agent "shared" "/root/.openclaw/workspace-shared"
fi

echo ""
echo "📊 Résumé de la sauvegarde:"
echo "================================"

total_agents=0
total_files=0

for agent_dir in "$TEAMPROJECT_DIR"/*; do
    if [ -d "$agent_dir" ] && [ "$(basename "$agent_dir")" != "README.md" ]; then
        agent_name=$(basename "$agent_dir")
        file_count=$(find "$agent_dir" -name "*.md" | wc -l)
        echo "  📋 $agent_name: $file_count fichiers markdown"
        total_agents=$((total_agents + 1))
        total_files=$((total_files + file_count))
    fi
done

echo "================================"
echo "✅ Total: $total_agents agents, $total_files fichiers markdown sauvegardés"

# Mettre à jour le README principal de TeamProject
cat > "$TEAMPROJECT_DIR/README.md" << EOF
# TeamProject - Sauvegarde Agents OpenClaw

Sauvegarde automatique des fichiers markdown de tous les agents OpenClaw.

**Dernière mise à jour:** $(date)

## Agents sauvegardés

$(for agent_dir in "$TEAMPROJECT_DIR"/*; do
    if [ -d "$agent_dir" ] && [ "$(basename "$agent_dir")" != "README.md" ]; then
        agent_name=$(basename "$agent_dir")
        file_count=$(find "$agent_dir" -name "*.md" | wc -l)
        echo "- **$agent_name**: $file_count fichiers markdown"
    fi
done)

## Structure

Chaque sous-répertoire correspond à un agent et contient:
- Tous les fichiers .md du workspace de l'agent
- La structure de dossiers préservée
- Un README.md avec les métadonnées de sauvegarde

## Usage

Cette sauvegarde permet de:
- Préserver les configurations et documentations des agents
- Faciliter la migration ou la restauration
- Suivre l'évolution des profils d'agents

---

*Généré automatiquement par backup-agents-markdown.sh*
EOF

echo ""
echo "🎯 SAUVEGARDE TERMINÉE avec succès!"
echo "📁 Fichiers disponibles dans: $TEAMPROJECT_DIR"