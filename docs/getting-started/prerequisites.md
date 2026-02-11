# Prérequis

Avant de commencer à travailler sur le projet Cocktail ClicBoumPaf, assurez-vous d'avoir les connaissances et outils suivants.

## Connaissances requises

### Obligatoires

| Compétence | Niveau | Description |
|------------|--------|-------------|
| **Git & GitHub** | Intermédiaire | Branches, commits, pull requests, merge |
| **JavaScript** | Intermédiaire | ES6+, async/await, promises |
| **Node.js** | Basique | npm, package.json, modules |
| **HTTP/REST** | Basique | Méthodes HTTP, statuts, APIs REST |
| **Docker** | Basique | Images, containers, docker-compose |
| **Linux CLI** | Basique | Navigation, commandes de base, bash |

### Recommandées

| Compétence | Description |
|------------|-------------|
| **React** | Components, hooks, state management |
| **Express.js** | Routing, middleware, API REST |
| **SQL** | Requêtes de base, relations |
| **GitHub Actions** | Workflows YAML, CI/CD basics |
| **Azure** | VM, networking, ARM/Bicep |
| **DevOps** | Principes CI/CD, infrastructure as code |

## Environnement de développement local

### Système d'exploitation

Le projet fonctionne sur :

- **Linux** (Ubuntu 20.04+, Debian 11+)
- **macOS** (Big Sur 11+)
- **Windows 10/11** avec WSL2

!!! warning "Windows sans WSL2"
    Le développement natif sur Windows (sans WSL2) n'est pas recommandé et peut causer des problèmes avec Docker et les scripts shell.

### Outils obligatoires

#### 1. Git (v2.30+)

```bash
# Vérifier l'installation
git --version

# Installation sur Ubuntu/Debian
sudo apt-get update
sudo apt-get install git

# Installation sur macOS
brew install git
```

#### 2. Node.js LTS (v20.17.0+)

```bash
# Vérifier l'installation
node --version
npm --version

# Installation avec nvm (recommandé)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20

# Ou via le site officiel
# https://nodejs.org/
```

#### 3. Docker (v20.10+) & Docker Compose (v2.0+)

```bash
# Vérifier l'installation
docker --version
docker compose version

# Installation sur Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Installation sur macOS
# Télécharger Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### 4. IDE / Éditeur de code

**Recommandé :** Visual Studio Code avec extensions :

- ESLint
- Prettier
- Docker
- GitLens
- YAML
- Bicep (pour Azure)

**Alternatives :** WebStorm, Sublime Text, Vim/Neovim

### Outils optionnels (mais recommandés)

#### 1. Azure CLI (v2.50+)

Nécessaire pour gérer l'infrastructure Azure :

```bash
# Installation sur Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Installation sur macOS
brew install azure-cli

# Vérification
az --version

# Login
az login
```

#### 2. GitHub CLI (gh)

Facilite les interactions avec GitHub :

```bash
# Installation sur Ubuntu
sudo apt install gh

# Installation sur macOS
brew install gh

# Authentification
gh auth login
```

#### 3. Postman / Insomnia

Pour tester l'API manuellement :

- [Postman](https://www.postman.com/downloads/)
- [Insomnia](https://insomnia.rest/download)

#### 4. DBeaver / MySQL Workbench

Pour explorer la base de données :

- [DBeaver Community](https://dbeaver.io/download/)
- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)

## Accès et comptes

### GitHub

- Compte GitHub actif
- Clé SSH configurée ([Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh))
- Accès au repository (si privé)

### Azure (pour le déploiement)

- Compte Azure (étudiant ou gratuit)
- Souscription active
- App Registration pour OIDC (voir [guide OIDC](../infrastructure/oidc.md))

### Services tiers (optionnels)

Pour utiliser tous les workflows CI/CD :

- **SonarQube** : Compte sur SonarCloud ou instance locale
- **Snyk** : Compte gratuit pour les scans de sécurité

## Vérification de l'environnement

Script de vérification rapide :

```bash
#!/bin/bash

echo "Vérification de l'environnement..."

# Git
if command -v git &> /dev/null; then
    echo "Git $(git --version)"
else
    echo "Git non installé"
fi

# Node.js
if command -v node &> /dev/null; then
    echo "Node.js $(node --version)"
else
    echo "Node.js non installé"
fi

# npm
if command -v npm &> /dev/null; then
    echo "npm $(npm --version)"
else
    echo "npm non installé"
fi

# Docker
if command -v docker &> /dev/null; then
    echo "Docker $(docker --version)"
else
    echo "Docker non installé"
fi

# Docker Compose
if command -v docker compose &> /dev/null; then
    echo "Docker Compose $(docker compose version)"
else
    echo "Docker Compose non installé"
fi

# Azure CLI (optionnel)
if command -v az &> /dev/null; then
    echo "Azure CLI $(az version --query '"azure-cli"' -o tsv)"
else
    echo "Azure CLI non installé (optionnel)"
fi

echo ""
echo "Vérification terminée !"
```

Enregistrez ce script dans `check-env.sh`, rendez-le exécutable et lancez-le :

```bash
chmod +x check-env.sh
./check-env.sh
```

## 🎓 Ressources d'apprentissage

Si vous avez des lacunes sur certains prérequis, voici des ressources pour vous former :

### Git & GitHub
- [Pro Git Book](https://git-scm.com/book/fr/v2) (gratuit)
- [GitHub Learning Lab](https://lab.github.com/)
- [Learn Git Branching](https://learngitbranching.js.org/)

### JavaScript / Node.js
- [MDN Web Docs - JavaScript](https://developer.mozilla.org/fr/docs/Web/JavaScript)
- [Node.js Documentation](https://nodejs.org/docs/latest/api/)
- [JavaScript.info](https://javascript.info/)

### React
- [Documentation officielle React](https://react.dev/)
- [React Tutorial](https://react.dev/learn)

### Docker
- [Docker Getting Started](https://docs.docker.com/get-started/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### Azure
- [Azure Fundamentals Learning Path](https://learn.microsoft.com/en-us/training/paths/azure-fundamentals/)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

### DevOps / CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [The DevOps Handbook](https://itrevolution.com/product/the-devops-handbook/)

## Checklist avant de commencer

Avant de passer à l'installation, vérifiez que vous avez :

- [ ] Git installé et configuré
- [ ] Node.js LTS installé
- [ ] Docker et Docker Compose installés
- [ ] Un IDE configuré
- [ ] Accès au repository GitHub
- [ ] Compte Azure (si déploiement prévu)
- [ ] Compréhension basique de JavaScript et REST APIs

---

##  Prochaine étape

Tous les prérequis sont remplis ? Parfait ! 

 [Installation du projet](installation.md)

---
