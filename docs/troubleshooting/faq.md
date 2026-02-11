# FAQ - Questions fréquentes

Retrouvez ici les réponses aux questions les plus fréquentes.

## Installation & Configuration

### Q: J'ai une erreur "port already in use" au démarrage

**R:** Un autre processus utilise le port. Solutions :

```bash
# Identifier le processus sur le port 80
sudo lsof -i :80
# ou
sudo netstat -tlnp | grep :80

# Tuer le processus
sudo kill -9 <PID>

# Ou changer le port dans docker-compose.yaml
ports:
  - 8080:80  # Au lieu de 80:80
```

### Q: Docker Compose échoue avec "permission denied"

**R:** Votre utilisateur n'est pas dans le groupe docker :

```bash
# Ajouter votre user au groupe docker
sudo usermod -aG docker $USER

# Se déconnecter et reconnecter
# Ou redémarrer la session
newgrp docker

# Vérifier
docker ps
```

### Q: La base de données ne démarre pas

**R:** Vérifiez les logs :

```bash
docker compose logs mono-bdd

# Souvent c'est un problème de volumes
# Supprimer les volumes et recréer
docker compose down -v
docker compose up -d
```

### Q: `npm install` échoue

**R:** Vérifiez votre version de Node.js :

```bash
node --version  # Doit être >= 20.17.0

# Mettre à jour Node via nvm
nvm install 20
nvm use 20

# Nettoyer le cache npm
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

## Docker

### Q: Comment reconstruire les images Docker ?

**R:**

```bash
# Reconstruire toutes les images
docker compose build

# Reconstruire sans cache
docker compose build --no-cache

# Reconstruire et démarrer
docker compose up -d --build
```

### Q: Comment voir les logs d'un container ?

**R:**

```bash
# Tous les containers
docker compose logs

# Un container spécifique
docker compose logs mono-back

# Suivre les logs en temps réel
docker compose logs -f mono-back

# Dernières 100 lignes
docker compose logs --tail=100 mono-back
```

### Q: Comment accéder au shell d'un container ?

**R:**

```bash
# Backend
docker exec -it mono-back sh

# Base de données
docker exec -it mono-bdd bash

# Se connecter à MySQL
docker exec -it mono-bdd mysql -u roger -pregor bddname
```

## Azure & Déploiement

### Q: Erreur "No subscriptions found" lors du login Azure

**R:** Votre Service Principal n'a pas accès à la souscription :

```bash
# Assigner le rôle Contributor
az role assignment create \
  --assignee <CLIENT_ID> \
  --role Contributor \
  --scope /subscriptions/<SUBSCRIPTION_ID>

# Attendre 5-10 minutes pour propagation
```

### Q: Erreur OIDC "No matching federated identity"

**R:** Le subject claim ne correspond pas :

1. Vérifiez que l'environment `STAGING` existe dans GitHub
2. Vérifiez le subject dans Azure :
   ```
   repo:EfreiBdx/cocktail_base_3t:environment:STAGING
   ```
3. Recréez le federated credential si nécessaire
4. Attendez 5-10 minutes

### Q: Erreur "IPv4BasicSkuPublicIpCountLimitReached"

**R:** Quota d'IP Basic atteint. Solution :

Modifiez le Bicep pour utiliser Standard SKU :

```bicep
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  sku: {
    name: 'Standard'  // Au lieu de 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Static'  // Standard nécessite Static
  }
}
```

### Q: La VM Azure ne démarre pas

**R:** Vérifiez :

```bash
# Voir le statut de la VM
az vm get-instance-view \
  --name Canary-Server \
  --resource-group ClicBoumPaf-Canary \
  --query instanceView.statuses

# Voir les logs de boot
az vm boot-diagnostics get-boot-log \
  --name Canary-Server \
  --resource-group ClicBoumPaf-Canary
```

## GitHub Actions

### Q: Mon workflow ne se déclenche pas

**R:** Vérifiez :

1. Le trigger dans le fichier YAML :
   ```yaml
   on:
     push:
       branches:
         - develop  # Vérifiez que c'est la bonne branche
   ```

2. Les permissions du workflow :
   ```yaml
   permissions:
     contents: read
     id-token: write
   ```

3. Que l'environment existe (si utilisé)

### Q: Workflow échoue avec "Resource not found"

**R:** Souvent un problème de permissions ou de secrets :

1. Vérifiez que tous les secrets sont configurés
2. Vérifiez les permissions de l'App Registration
3. Vérifiez que le resource group existe

### Q: Comment relancer un workflow échoué ?

**R:**

1. Aller dans **Actions**
2. Cliquer sur le workflow échoué
3. Cliquer sur **Re-run failed jobs**
4. Ou **Re-run all jobs**

### Q: Comment voir les logs détaillés d'un workflow ?

**R:**

1. Aller dans **Actions**
2. Cliquer sur le workflow
3. Cliquer sur un job
4. Déplier les steps pour voir les logs détaillés

## Tests

### Q: Les tests Cypress échouent en local

**R:**

```bash
# Vérifier que le backend tourne
curl http://localhost:12000/health

# Vérifier que le frontend tourne
curl http://localhost:5173

# Relancer Cypress en mode debug
npm run cypress:open
```

### Q: Coverage trop basse

**R:** Ajoutez des tests :

```bash
# Voir le rapport de coverage
npm run test:cov

# Ouvrir le rapport HTML
open coverage/lcov-report/index.html
```

### Q: Comment tester une route spécifique ?

**R:**

```bash
# Backend - un fichier de test
npm run test:file users

# Frontend - un test Cypress
npx cypress run --spec "cypress/e2e/login.cy.js"
```

## Sécurité

### Q: Snyk trouve des vulnérabilités, que faire ?

**R:**

```bash
# Voir les détails
npm audit

# Corriger automatiquement
npm audit fix

# Forcer les corrections (attention)
npm audit fix --force

# Ignorer une vulnérabilité (si false positive)
# Créer un fichier .snyk
```

### Q: SonarQube signale du code dupliqué

**R:** Refactorisez le code dupliqué :

```javascript
// Avant
const getUserById = (id) => User.findByPk(id);
const getPostById = (id) => Post.findByPk(id);

// Après
const getByIdFactory = (Model) => (id) => Model.findByPk(id);
const getUserById = getByIdFactory(User);
const getPostById = getByIdFactory(Post);
```

## Frontend

### Q: Erreur CORS lors des appels API

**R:** Configurez le proxy Vite :

```javascript
// vite.config.js
export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:12000',
        changeOrigin: true,
      }
    }
  }
})
```

### Q: React Router ne fonctionne pas en production

**R:** Configurez nginx pour le SPA :

```nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

## 💾 Base de données

### Q: Comment réinitialiser la base de données ?

**R:**

```bash
# Via Docker
docker compose down -v  # Supprime les volumes
docker compose up -d

# Puis réinitialiser
cd backend
npm run initbdd
npm run populate
```

### Q: Comment accéder à la base de données ?

**R:**

```bash
# Via docker exec
docker exec -it mono-bdd mysql -u roger -pregor bddname

# Ou via un client comme DBeaver
Host: localhost
Port: 3306
User: roger
Password: regor
Database: bddname
```

### Q: Sequelize ne trouve pas la table

**R:** Synchronisez les modèles :

```javascript
// En développement uniquement !
await sequelize.sync({ force: true });  // Supprime les données
await sequelize.sync({ alter: true });  // Modifie les tables
```

## Documentation

### Q: Comment contribuer à la documentation ?

**R:**

1. Cloner le repo de docs
2. Installer MkDocs : `pip install mkdocs-material`
3. Éditer les fichiers markdown dans `docs/`
4. Prévisualiser : `mkdocs serve`
5. Soumettre une PR

### Q: Comment déployer la documentation ?

**R:**

```bash
# Build
mkdocs build

# Déployer sur GitHub Pages
mkdocs gh-deploy
```

## Divers

### Q: Comment changer le port du backend ?

**R:**

1. `.env` : `PORT=3000`
2. `docker-compose.yaml` : `ports: - 3000:3000`
3. Frontend `.env` : `VITE_API_URL=http://localhost:3000`

### Q: Puis-je utiliser ce projet en production ?

**R:** **Non**, ce projet est pédagogique :

- Pas d'authentification robuste
- Pas de gestion d'erreurs complète
- Pas de monitoring
- Pas de backup
- Secrets en clair dans certains fichiers

Pour la production, il faudrait :

- Gérer les secrets avec Azure Key Vault
- Implémenter un vrai système d'auth (OAuth2, SAML)
- Ajouter du monitoring (Application Insights, Prometheus)
- Configurer les backups
- Implémenter rate limiting
- Configurer HTTPS
- Et bien plus...

---

## Question non résolue ?

Si votre question n'est pas dans cette FAQ :

1. Cherchez dans les [Issues GitHub](https://github.com/EfreiBdx/cocktail_base_3t/issues)
2. Posez votre question dans [Discussions](https://github.com/EfreiBdx/cocktail_base_3t/discussions)
3. Ouvrez une nouvelle issue avec le tag `question`

---

