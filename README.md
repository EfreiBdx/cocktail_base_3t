# Documentation Cocktail ClicBoumPaf

Documentation complète du projet Cocktail ClicBoumPaf générée avec MkDocs Material.

## Démarrage rapide

### Prérequis

- Python 3.8+
- pip

### Installation

```bash
# Cloner le repo
git clone https://github.com/EfreiBdx/cocktail_base_3t.git
cd cocktail_base_3t

# Installer MkDocs et le thème Material
pip install -r requirements.txt
```

### Lancer en local

```bash
# Serveur de développement avec auto-reload
mkdocs serve

# Accéder à la documentation
# http://127.0.0.1:8000
```

### Build de la documentation

```bash
# Générer les fichiers statiques dans site/
mkdocs build

# Vérifier les liens cassés
mkdocs build --strict
```

## Structure

```
.
├── docs/                    # Fichiers markdown de la documentation
│   ├── index.md             # Page d'accueil
│   ├── getting-started/     # Guide de démarrage
│   ├── architecture/        # Architecture du projet
│   ├── cicd/                # CI/CD et DevSecOps
│   ├── infrastructure/      # Infrastructure Azure
│   ├── development/         # Guide développeurs
│   ├── deployment/          # Guides de déploiement
│   ├── security/            # Sécurité
│   ├── troubleshooting/     # Dépannage
│   └── contributing.md      # Guide de contribution
├── mkdocs.yml               # Configuration MkDocs
├── requirements.txt         # Dépendances Python
└── README.md                # Ce fichier
```

## Contribuer à la documentation

### Ajouter une nouvelle page

1. Créer un fichier markdown dans `docs/`
2. Ajouter l'entrée dans `mkdocs.yml` sous `nav:`

```yaml
nav:
  - Ma section:
      - Ma page: mon-dossier/ma-page.md
```

3. Tester localement avec `mkdocs serve`

### Conventions d'écriture

- Titres en français
- Code blocks avec syntaxe highlighting
- Utiliser les admonitions pour les notes/warnings
- Inclure des exemples pratiques
- Ajouter des diagrammes Mermaid quand pertinent

### Exemples de syntaxe

#### Code blocks

```markdown
​```python
def hello_world():
    print("Hello, World!")
​```
```

#### Admonitions

```markdown
!!! note "Titre de la note"
    Contenu de la note

!!! warning "Attention"
    Message d'avertissement

!!! tip "Astuce"
    Conseil pratique
```

#### Diagrammes Mermaid

```markdown
​```mermaid
graph LR
    A[Start] --> B[Process]
    B --> C[End]
​```
```

## Déploiement

### GitHub Pages

La documentation est automatiquement déployée sur GitHub Pages via GitHub Actions.

```bash
# Déploiement manuel
mkdocs gh-deploy

# La doc sera accessible sur :
# https://efreibdx.github.io/cocktail_base_3t/
```

### Workflow automatique

Le fichier `.github/workflows/docs.yml` déploie automatiquement sur chaque push vers `main`.

## Thème et personnalisation

Le projet utilise **Material for MkDocs** avec :

- Mode clair/sombre
- Navigation par onglets
- Recherche intégrée
- Highlighting de code
- Support Mermaid
- Icônes Material Design

### Personnaliser le thème

Éditer `mkdocs.yml` :

```yaml
theme:
  name: material
  palette:
    primary: indigo  # Couleur principale
    accent: indigo   # Couleur accent
```

## Ressources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Mermaid Documentation](https://mermaid.js.org/)

## Support

Pour toute question sur la documentation :

- Ouvrir une [issue](https://github.com/EfreiBdx/cocktail_base_3t/issues)
- Consulter les [discussions](https://github.com/EfreiBdx/cocktail_base_3t/discussions)

---

**Généré par MkDocs Material**
