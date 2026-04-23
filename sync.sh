#!/bin/bash
# sync.sh - Synchronise les JSON exportés depuis l'app vers GitHub
#
# Usage : ./sync.sh
#
# Prérequis :
# 1. Avoir cliqué sur "Exporter" dans l'app (les 4 JSON sont dans ~/Downloads/)
# 2. Être dans le dossier du repo chant (ou lancer depuis n'importe où, le script
#    se place tout seul dans le dossier où il se trouve)

set -e  # Arrête le script à la moindre erreur

# --- Se placer dans le dossier où se trouve le script (= racine du repo)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# --- Vérifier qu'on est bien dans un dépôt git
if [ ! -d .git ]; then
  echo "❌ Erreur : ce script doit être placé à la racine du repo chant (à côté de index.html)."
  exit 1
fi

# --- Vérifier que le dossier data/ existe
if [ ! -d data ]; then
  echo "❌ Erreur : dossier data/ introuvable. Es-tu bien dans le repo chant ?"
  exit 1
fi

# --- Liste des 4 JSON attendus
FILES=("progression.json" "journal.json" "tessiture.json" "vocabulaire_enseignante.json")

# --- Vérifier s'il y a au moins un JSON à déplacer depuis ~/Downloads
DOWNLOADS="$HOME/Downloads"
FOUND=0
for f in "${FILES[@]}"; do
  if [ -f "$DOWNLOADS/$f" ]; then
    FOUND=$((FOUND+1))
  fi
done

if [ "$FOUND" -eq 0 ]; then
  echo "⚠️  Aucun JSON trouvé dans $DOWNLOADS."
  echo "   As-tu bien cliqué sur 'Exporter' dans l'app avant de lancer ce script ?"
  echo "   (Si les JSON sont ailleurs, déplace-les manuellement vers data/)"
  exit 1
fi

echo "📥 $FOUND JSON trouvé(s) dans $DOWNLOADS."

# --- Déplacer chaque fichier trouvé vers data/ (avec confirmation par fichier)
for f in "${FILES[@]}"; do
  if [ -f "$DOWNLOADS/$f" ]; then
    mv "$DOWNLOADS/$f" "data/$f"
    echo "   → $f déplacé vers data/"
  fi
done

# --- Vérifier s'il y a vraiment des changements à commit
if git diff --quiet data/ && git diff --cached --quiet data/; then
  echo "ℹ️  Les JSON déplacés sont identiques à la version du repo. Rien à commit."
  exit 0
fi

# --- Afficher les changements détectés pour que l'utilisateur voie ce qui va être commité
echo ""
echo "📝 Changements détectés dans data/ :"
git diff --stat data/

# --- Commit + push
DATE=$(date '+%Y-%m-%d %H:%M')
COMMIT_MSG="data: sync automatique $DATE"

git add data/
git commit -m "$COMMIT_MSG"
echo ""
echo "🚀 Push en cours..."
git push

echo ""
echo "✅ Synchronisation terminée. Les JSON sont maintenant sur GitHub."
echo "   Claude pourra les fetcher à la prochaine conversation."
