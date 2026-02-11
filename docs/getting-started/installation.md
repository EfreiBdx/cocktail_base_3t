# Installation locale

Ce guide vous accompagne dans l'installation et le lancement du projet Cocktail ClicBoumPaf en local.

## Cloner le repository

```bash
# Via HTTPS
git clone https://github.com/EfreiBdx/cocktail_base_3t.git

# Ou via SSH (recommandé)
git clone git@github.com:EfreiBdx/cocktail_base_3t.git

# Accéder au projet
cd cocktail_base_3t
```

## Structure du projet

```
cocktail_base_3t/
├── .github/
│   └── workflows/          # Workflows GitHub Actions
├── backend/
│   ├── api/               # Logique API
│   ├── test/              # Tests Jest
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── frontend/
│   ├── src/               # Code source React
│   ├── cypress/           # Tests E2E
│   ├── Dockerfile
│   ├── package.json
│   └── vite.config.js
├── docker-compose.yaml    # Orchestration Docker
└── README.md
```

## Méthode 1 : Docker Compose (Recommandé)

La méthode la plus simple pour lancer l'application complète.

### Étape 1 : Vérifier Docker

```bash
docker --version
docker compose version
```

### Étape 2 : Lancer l'application

```bash
# Lancer tous les services
docker compose up -d

# Vérifier que les containers tournent
docker compose ps
```

Vous devriez voir 3 containers :

```
NAME                IMAGE                       PORTS
mono-bdd            mariadb:latest              3306
mono-back           ghcr.io/.../backend:canary  12000
mono-front          ghcr.io/.../frontend:canary 80
```

### Étape 3 : Accéder à l'application

- **Frontend :** http://localhost
- **Backend API :** http://localhost:12000

### Étape 4 : Arrêter l'application

```bash
# Arrêter les containers
docker compose down

# Arrêter et supprimer les volumes (⚠️ supprime les données)
docker compose down -v
```

## Méthode 2 : Installation manuelle (Développement)

Pour développer activement sur le backend ou le frontend.

### Backend

#### 1. Lancer la base de données

```bash
docker compose -f docker-compose-local-bdd.yaml up -d
```

#### 2. Installer les dépendances

```bash
cd backend
npm install
```

#### 3. Créer le fichier `.env`

```bash
cp .env.example .env
```

Contenu du fichier `.env` :

```env
# Base de données
BDD_HOST=localhost
BDD_PORT=3306
BDD_USER=roger
BDD_PASSWORD=regor
BDD_NAME=bddname

# Application
PORT=12000
NODE_ENV=development

# JWT
JWT_SECRET=your-super-secret-key-change-me
JWT_EXPIRES_IN=24h
```

#### 4. Initialiser la base de données

```bash
# Créer les tables
npm run initbdd

# Peupler avec des données de test
npm run populate
```

#### 5. Lancer le serveur

```bash
# Mode développement (avec auto-reload)
npm run dev

# Mode production
npm start
```

Le backend est accessible sur http://localhost:12000

### Frontend

#### 1. Installer les dépendances

```bash
cd frontend
npm install
```

#### 2. Créer le fichier `.env`

```bash
cp .env.example .env
```

Contenu du fichier `.env` :

```env
VITE_API_URL=http://localhost:12000
```

#### 3. Lancer le serveur de développement

```bash
# Mode développement avec hot-reload
npm run dev
```

Le frontend est accessible sur http://localhost:5173

#### 4. Build pour la production

```bash
# Build classique
npm run build

# Build pour l'environnement Canary
npm run build:canary
```

## Lancer les tests

### Tests Backend (Jest)

```bash
cd backend

# Tous les tests
npm test

# Avec coverage
npm run test:cov

# Un fichier spécifique
npm run test:file users
```

### Tests Frontend (Cypress)

```bash
cd frontend

# Mode interactif
npm run cypress:open

# Mode headless
npm run cypress:run

# Coverage
npm run cypress:cov
```

## Configuration avancée

### Variables d'environnement

#### Backend

| Variable | Description | Défaut |
|----------|-------------|--------|
| `BDD_HOST` | Hôte de la base de données | `localhost` |
| `BDD_PORT` | Port de la base de données | `3306` |
| `BDD_USER` | Utilisateur BDD | `roger` |
| `BDD_PASSWORD` | Mot de passe BDD | `regor` |
| `BDD_NAME` | Nom de la base | `bddname` |
| `PORT` | Port du serveur backend | `12000` |
| `JWT_SECRET` | Clé secrète JWT | - |

#### Frontend

| Variable | Description | Défaut |
|----------|-------------|--------|
| `VITE_API_URL` | URL de l'API backend | `http://localhost:12000` |

### Ports utilisés

| Service | Port | Description |
|---------|------|-------------|
| Frontend | 80 (Docker) / 5173 (dev) | Interface React |
| Backend | 12000 | API Express.js |
| MariaDB | 3306 | Base de données |

## Troubleshooting

### Problème : Port déjà utilisé

```bash
# Identifier le processus utilisant le port 80
sudo lsof -i :80

# Tuer le processus
sudo kill -9 <PID>
```

### Problème : Containers ne démarrent pas

```bash
# Voir les logs
docker compose logs

# Logs d'un service spécifique
docker compose logs mono-back

# Reconstruire les images
docker compose up -d --build
```

### Problème : Base de données vide

```bash
# Se connecter au container de la BDD
docker exec -it mono-bdd bash

# Se connecter à MariaDB
mysql -u roger -pregor bddname

# Vérifier les tables
SHOW TABLES;
```

Si vide, relancer l'initialisation :

```bash
cd backend
npm run initbdd
npm run populate
```

### Problème : CORS lors du développement

Assurez-vous que `VITE_API_URL` pointe vers le bon backend et que le backend accepte les requêtes depuis le frontend.

## Vérification de l'installation

Une fois tout installé, vérifiez :

### Backend

```bash
curl http://localhost:12000/health
# Devrait retourner : {"status":"ok"}
```

### Frontend

Ouvrez http://localhost (Docker) ou http://localhost:5173 (dev)

### Base de données

```bash
docker exec -it mono-bdd mysql -u roger -pregor -e "USE bddname; SHOW TABLES;"
```

## Installation réussie !

Votre environnement local est prêt ! 

### Prochaines étapes

1. [Configuration](configuration.md) - Configurer les secrets et variables
2. [Backend API](../development/backend-api.md) - Comprendre l'API
3. [Frontend React](../development/frontend-react.md) - Comprendre l'interface

---

!!! tip "Conseil pour le développement"
    Utilisez **Docker Compose pour la BDD** et lancez **backend/frontend manuellement** pour bénéficier du hot-reload pendant le développement.
    
    ```bash
    # Terminal 1 : BDD
    docker compose -f docker-compose-local-bdd.yaml up
    
    # Terminal 2 : Backend
    cd backend && npm run dev
    
    # Terminal 3 : Frontend
    cd frontend && npm run dev
    ```
