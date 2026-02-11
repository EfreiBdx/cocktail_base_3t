# Configuration

Guide de configuration du projet pour le développement local et le déploiement Azure.

## Configuration locale

### Backend

#### Fichier `.env`

Créez un fichier `.env` à la racine du dossier `backend/` :

```env
# Base de données
BDD_HOST=localhost
BDD_PORT=3306
BDD_USER=roger
BDD_PASSWORD=regor
BDD_NAME=bddname

# Serveur
PORT=12000
NODE_ENV=development

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-me-in-production
JWT_EXPIRES_IN=24h

# CORS (en développement)
CORS_ORIGIN=http://localhost:5173
```

!!! warning "Production"
    En production, utilisez des secrets forts et sécurisés. Ne commitez JAMAIS le fichier `.env` !

#### Paramètres de connexion BDD

Pour Docker Compose, les credentials sont dans `docker-compose.yaml` :

```yaml
environment:
  MARIADB_ROOT_PASSWORD: TOOR
  MARIADB_DATABASE: bddname
  MARIADB_USER: roger
  MARIADB_PASSWORD: regor
```

### Frontend

#### Fichier `.env`

Créez un fichier `.env` à la racine du dossier `frontend/` :

```env
# URL de l'API backend
VITE_API_URL=http://localhost:12000
```

#### Modes de build

Le frontend supporte deux modes :

```bash
# Mode développement standard
npm run build

# Mode Canary (avec variables spécifiques)
npm run build:canary
```

## Configuration Azure

### Prérequis Azure

1. **Compte Azure** actif
2. **Souscription** avec droits Contributor
3. **App Registration** pour l'authentification OIDC

### Créer une App Registration

#### Via Azure Portal

1. Aller dans **Azure Active Directory** (Entra ID)
2. **App registrations** → **New registration**
3. Nom : `github-actions-cocktail`
4. Supported account types : **Single tenant**
5. Créer

#### Configurer l'authentification OIDC

1. Dans l'App Registration → **Certificates & secrets**
2. **Federated credentials** → **Add credential**
3. Configuration :

```
Federated credential scenario: GitHub Actions deploying Azure resources
Organization: EfreiBdx
Repository: cocktail_base_3t
Entity type: Environment
Environment name: STAGING
```

4. Name: `github-staging-credential`
5. Ajouter

#### Assigner les permissions

```bash
# Récupérer l'Application ID
APP_ID=$(az ad app list --display-name "github-actions-cocktail" --query "[0].appId" -o tsv)

# Assigner le rôle Contributor
az role assignment create \
  --assignee $APP_ID \
  --role Contributor \
  --scope /subscriptions/<SUBSCRIPTION_ID>
```

### GitHub Secrets

Configurez les secrets suivants dans **Settings → Secrets and variables → Actions** :

#### Secrets Azure

| Secret | Valeur | Comment l'obtenir |
|--------|--------|-------------------|
| `AZURE_CLIENT_ID` | Application (client) ID | App Registration → Overview |
| `AZURE_TENANT_ID` | Directory (tenant) ID | App Registration → Overview |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID | Azure Portal → Subscriptions |

```bash
# Obtenir les IDs via CLI
az account show --query '{subscriptionId:id, tenantId:tenantId}' -o json
```

#### Secrets VM

| Secret | Valeur | Description |
|--------|--------|-------------|
| `AZURE_VM_LOGIN` | `azureuser` | Login admin de la VM |
| `AZURE_VM_PASSWORD` | `MotDeP@sse123!` | Password (complexe !) |

!!! warning "Sécurité"
    Utilisez un mot de passe fort :
    - Minimum 12 caractères
    - Majuscules + minuscules
    - Chiffres
    - Caractères spéciaux

#### Secrets GitHub

| Secret | Valeur | Description |
|--------|--------|-------------|
| `MONOREPO_PAT` | GitHub Personal Access Token | Pour pull/push GHCR |

**Créer un PAT :**

1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token (classic)**
3. Permissions : `write:packages`, `read:packages`
4. Copier le token

#### Secrets optionnels (SonarQube, Snyk)

| Secret | Service | Comment l'obtenir |
|--------|---------|-------------------|
| `SONAR_TOKEN` | SonarCloud | sonarcloud.io → Account → Security |
| `SNYK_TOKEN` | Snyk | app.snyk.io → Account Settings → API Token |

### GitHub Environment

Créez un environment `STAGING` :

1. GitHub Repo → **Settings** → **Environments**
2. **New environment** : `STAGING`
3. (Optionnel) Ajouter des protection rules :
   - Required reviewers
   - Wait timer
   - Deployment branches (develop, release/*)

## Configuration Docker

### Variables d'environnement Docker

Le `docker-compose.yaml` utilise des variables :

```yaml
services:
  mono-back:
    image: ${MONO_PROJECT_BACK}
  mono-front:
    image: ${MONO_PROJECT_FRONT}
```

#### Fichier `.env` Docker (sur la VM)

Créé automatiquement par le workflow :

```env
MONO_PROJECT_BACK=ghcr.io/efreibdx/cocktail_base_3t-back:canary
MONO_PROJECT_FRONT=ghcr.io/efreibdx/cocktail_base_3t-front:canary
```

### Ports exposés

| Service | Port interne | Port externe |
|---------|--------------|--------------|
| Frontend | 80 | 80 |
| Backend | 12000 | 12000 |
| MariaDB | 3306 | (non exposé) |

## Configuration réseau Azure

### Network Security Group

Ouvert automatiquement par le workflow :

```yaml
- Port 22 (SSH) : Accès administration
- Port 80 (HTTP) : Frontend
- Port 12000 : Backend API
```

### DNS

Configuration DNS sur `demo.clic-boum-paf.com` :

```bash
az network dns record-set a add-record \
  -g ClicBoumPaf-DNS \
  -z demo.clic-boum-paf.com \
  -n monocanary \
  -a <IP_VM>
```

**Accès Canary :** `http://monocanary.demo.clic-boum-paf.com`

## Configuration SonarQube

### Fichiers de configuration

**Backend :** `backend/sonar-project.properties`

```properties
sonar.projectKey=cocktail-backend
sonar.organization=efreibdx
sonar.sources=.
sonar.exclusions=node_modules/**,test/**,coverage/**
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

**Frontend :** `frontend/sonar-project.properties`

```properties
sonar.projectKey=cocktail-frontend
sonar.organization=efreibdx
sonar.sources=src
sonar.exclusions=node_modules/**,cypress/**,dist/**
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

### Quality Gates

Configurez sur SonarCloud :

- Coverage : > 80%
- Duplications : < 3%
- Maintainability Rating : A
- Reliability Rating : A
- Security Rating : A

## Configuration Snyk

### Fichier `.snyk` (optionnel)

```yaml
# Snyk configuration
version: v1.22.0

# Ignore specific vulnerabilities
ignore:
  'SNYK-JS-AXIOS-1234567':
    - '*':
        reason: 'False positive - not exploitable in our context'
        expires: '2024-12-31'
```

## Vérification de la configuration

### Script de vérification

```bash
#!/bin/bash

echo "Vérification de la configuration..."

# Vérifier .env backend
if [ -f backend/.env ]; then
    echo "backend/.env existe"
else
    echo "backend/.env manquant"
fi

# Vérifier .env frontend
if [ -f frontend/.env ]; then
    echo "frontend/.env existe"
else
    echo "frontend/.env manquant"
fi

# Vérifier les secrets GitHub (via API)
if command -v gh &> /dev/null; then
    echo "Secrets GitHub :"
    gh secret list
else
    echo "GitHub CLI non installé (impossible de vérifier les secrets)"
fi

# Vérifier Azure CLI
if command -v az &> /dev/null; then
    echo "Azure CLI configuré"
    az account show --query '{subscription:name, user:user.name}' -o table
else
    echo "Azure CLI non configuré"
fi

echo ""
echo "Vérification terminée !"
```

### Checklist complète

- [ ] `.env` backend créé
- [ ] `.env` frontend créé
- [ ] App Registration Azure créée
- [ ] Federated credentials configurés
- [ ] Role assignment Contributor défini
- [ ] Secrets GitHub configurés :
  - [ ] `AZURE_CLIENT_ID`
  - [ ] `AZURE_TENANT_ID`
  - [ ] `AZURE_SUBSCRIPTION_ID`
  - [ ] `AZURE_VM_LOGIN`
  - [ ] `AZURE_VM_PASSWORD`
  - [ ] `MONOREPO_PAT`
- [ ] Environment `STAGING` créé
- [ ] (Optionnel) `SONAR_TOKEN` configuré
- [ ] (Optionnel) `SNYK_TOKEN` configuré

---

## Prochaines étapes

Configuration terminée ? 

[Architecture](../architecture/overview.md) - Comprendre l'architecture  
[CI/CD](../cicd/overview.md) - Lancer les workflows  
[Infrastructure](../infrastructure/oidc.md) - Approfondir Azure

---

!!! tip "Sécurité"
    Ne partagez JAMAIS vos secrets ou tokens. Utilisez toujours GitHub Secrets pour stocker les informations sensibles.
