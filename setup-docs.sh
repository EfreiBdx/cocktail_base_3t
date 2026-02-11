#!/bin/bash

# Script d'installation et de démarrage de la documentation MkDocs
# Usage: ./setup-docs.sh

set -e

echo "Installation de la documentation Cocktail ClicBoumPaf"
echo "========================================================"
echo ""

# Vérifier Python
echo "Vérification de Python..."
if ! command -v python3 &> /dev/null; then
    echo "Python 3 n'est pas installé"
    echo "   Installez Python 3.8+ : https://www.python.org/downloads/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | awk '{print $2}')
echo "Python $PYTHON_VERSION détecté"
echo ""

# Vérifier pip
echo "Vérification de pip..."
if ! command -v pip3 &> /dev/null; then
    echo "pip n'est pas installé"
    echo "Installez pip : python3 -m ensurepip --upgrade"
    exit 1
fi

echo "pip détecté"
echo ""

# Créer un environnement virtuel (optionnel mais recommandé)
echo "Création d'un environnement virtuel..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo " Environnement virtuel créé"
else
    echo " Environnement virtuel déjà existant"
fi

# Activer l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source venv/bin/activate
echo ""

# Mettre à jour pip
echo "Mise à jour de pip..."
pip install --upgrade pip --quiet
echo ""

# Installer les dépendances
echo "Installation des dépendances..."
pip install -r requirements.txt --quiet
echo "Dépendances installées"
echo ""

# Vérifier que mkdocs est installé
if command -v mkdocs &> /dev/null; then
    MKDOCS_VERSION=$(mkdocs --version | awk '{print $3}')
    echo " MkDocs $MKDOCS_VERSION installé"
else
    echo " Erreur lors de l'installation de MkDocs"
    exit 1
fi

echo ""
echo "  Installation terminée !"
echo ""
echo "   Pour démarrer la documentation :"
echo "   1. Activer l'environnement : source venv/bin/activate"
echo "   2. Lancer le serveur : mkdocs serve"
echo "   3. Ouvrir http://127.0.0.1:8000"
echo ""
echo "   Pour build la documentation :"
echo "   mkdocs build"
echo ""
echo "   Pour déployer sur GitHub Pages :"
echo "   mkdocs gh-deploy"
echo ""

# Proposer de lancer le serveur
read -p "Voulez-vous lancer le serveur maintenant ? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Lancement du serveur MkDocs..."
    echo "   Accédez à http://127.0.0.1:8000"
    echo "   Appuyez sur Ctrl+C pour arrêter"
    echo ""
    mkdocs serve
fi
