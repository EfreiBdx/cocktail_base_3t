# Guide de contribution

Merci de vouloir contribuer au projet Cocktail ClicBoumPaf ! 🎉

Ce guide vous explique comment contribuer efficacement au projet.

## Types de contributions

Vous pouvez contribuer de plusieurs façons :

- 🐛 **Correction de bugs**
- ✨ **Nouvelles fonctionnalités**
- 📝 **Amélioration de la documentation**
- 🧪 **Ajout de tests**
- 🔒 **Améliorations de sécurité**
- ⚡ **Optimisations de performance**
- 🎨 **Amélioration de l'UI/UX**

## Workflow de contribution

### 1. Fork & Clone

```bash
# Fork le repo sur GitHub, puis :
git clone git@github.com:VOTRE-USERNAME/cocktail_base_3t.git
cd cocktail_base_3t

# Ajouter l'upstream
git remote add upstream git@github.com:EfreiBdx/cocktail_base_3t.git
```

### 2. Créer une branche

Suivez la convention GitFlow :

```bash
# Pour une nouvelle fonctionnalité
git checkout -b feature/ma-super-feature develop

# Pour un bugfix
git checkout -b fix/correction-bug develop

# Pour de la documentation
git checkout -b docs/amelioration-doc develop
```

**Convention de nommage :**

- `feature/` : Nouvelles fonctionnalités
- `fix/` : Corrections de bugs
- `docs/` : Documentation
- `refactor/` : Refactoring
- `test/` : Ajout de tests
- `chore/` : Maintenance, config

### 3. Développer

```bash
# Installer les dépendances
npm install

# Lancer en mode dev
npm run dev

# Lancer les tests
npm test
```

### 4. Committer

Suivez la **convention Conventional Commits** :

```bash
# Format
<type>(<scope>): <description>

# Exemples
git commit -m "feat(backend): add user authentication endpoint"
git commit -m "fix(frontend): correct login form validation"
git commit -m "docs(readme): update installation instructions"
git commit -m "test(api): add tests for user routes"
```

**Types de commits :**

- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation
- `style`: Formatage (pas de changement de logique)
- `refactor`: Refactoring
- `test`: Ajout de tests
- `chore`: Maintenance

### 5. Push & Pull Request

```bash
# Push vers votre fork
git push origin feature/ma-super-feature

# Créer une Pull Request sur GitHub
```

## Checklist avant PR

Avant de soumettre votre Pull Request, assurez-vous que :

### Code

- [ ] Le code suit les conventions du projet
- [ ] Les tests passent : `npm test`
- [ ] Pas d'erreurs ESLint : `npm run lint`
- [ ] Le code est commenté si nécessaire
- [ ] Pas de `console.log()` oubliés
- [ ] Pas de code commenté

### Tests

- [ ] Tests unitaires ajoutés pour le nouveau code
- [ ] Tests E2E ajoutés si nécessaire
- [ ] Coverage maintenu > 80%

### Documentation

- [ ] README mis à jour si nécessaire
- [ ] Commentaires JSDoc pour les nouvelles fonctions
- [ ] CHANGELOG.md mis à jour

### Commit

- [ ] Messages de commit clairs et descriptifs
- [ ] Convention Conventional Commits respectée
- [ ] Commits atomiques (1 commit = 1 logique)

## Template de Pull Request

Utilisez ce template pour vos PR :

```markdown
## Description
Brève description de ce que fait cette PR

## Type de changement
- [ ] Bug fix
- [ ] Nouvelle fonctionnalité
- [ ] Breaking change
- [ ] Documentation

## Motivation et contexte
Pourquoi ce changement est nécessaire ? Quel problème résout-il ?

Issue liée : #(numéro)

## Comment a-t-il été testé ?
Décrivez les tests effectués :
- [ ] Tests unitaires
- [ ] Tests E2E
- [ ] Tests manuels

## Screenshots (si applicable)
Ajoutez des captures d'écran si changement UI

## Checklist
- [ ] Mon code suit le style du projet
- [ ] J'ai effectué une auto-review
- [ ] J'ai commenté les parties complexes
- [ ] J'ai mis à jour la documentation
- [ ] Mes changements ne génèrent pas de warnings
- [ ] J'ai ajouté des tests
- [ ] Tous les tests passent
```

## Standards de code

### JavaScript / Node.js

```javascript
// Bon
const getUserById = async (id) => {
  const user = await User.findByPk(id);
  if (!user) {
    throw new Error('User not found');
  }
  return user;
};

// Mauvais
function getUser(id) {
  return User.findByPk(id);
}
```

**Conventions :**

- Utilisez `const` et `let` (jamais `var`)
- Arrow functions pour les callbacks
- async/await plutôt que promises
- Destructuring quand possible
- Template literals plutôt que concaténation

### React / Frontend

```jsx
// Bon
const UserProfile = ({ user }) => {
  const [isLoading, setIsLoading] = useState(false);
  
  useEffect(() => {
    // Effect logic
  }, [user]);
  
  return (
    <div className="user-profile">
      <h1>{user.name}</h1>
    </div>
  );
};

// Mauvais
class UserProfile extends Component {
  render() {
    return <div>{this.props.user.name}</div>;
  }
}
```

**Conventions :**

- Functional components uniquement
- Hooks pour le state et effects
- Props destructuring
- PropTypes ou TypeScript pour le typage

### Fichiers et dossiers

```
backend/
├── api/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   └── middlewares/
└── test/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── utils/
│   └── api/
└── cypress/
```

## Tests

### Tests Backend (Jest)

```javascript
describe('User API', () => {
  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const res = await request(app)
        .post('/api/users')
        .send({
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123'
        });
      
      expect(res.status).toBe(201);
      expect(res.body).toHaveProperty('id');
      expect(res.body.username).toBe('testuser');
    });
  });
});
```

### Tests Frontend (Cypress)

```javascript
describe('Login Page', () => {
  beforeEach(() => {
    cy.visit('/login');
  });

  it('should login successfully', () => {
    cy.get('[data-testid="username"]').type('testuser');
    cy.get('[data-testid="password"]').type('password123');
    cy.get('[data-testid="submit"]').click();
    
    cy.url().should('include', '/dashboard');
  });
});
```

## Review process

### Processus de review

1. **Automated checks** : GitHub Actions vérifie automatiquement :
   - Tests backend
   - Tests frontend
   - Linting
   - SonarQube
   - Snyk

2. **Code review** : Un mainteneur review manuellement :
   - Qualité du code
   - Pertinence des changements
   - Tests adéquats
   - Documentation

3. **Merge** : Une fois approuvée, la PR est mergée dans `develop`

### Délai de review

- Review initiale : **< 48h** (jours ouvrés)
- Feedback sur corrections : **< 24h**

### Que faire si ma PR est rejetée ?

- Lisez attentivement les commentaires
- Posez des questions si besoin
- Effectuez les modifications demandées
- Poussez les corrections
- Demandez une nouvelle review

## 🐛 Signaler un bug

### Via GitHub Issues

1. Vérifiez qu'il n'existe pas déjà
2. Créez une issue avec le template :

```markdown
**Description du bug**
Courte description du problème

**Pour reproduire**
1. Aller sur '...'
2. Cliquer sur '...'
3. Voir l'erreur

**Comportement attendu**
Ce qui devrait se passer

**Screenshots**
Si applicable

**Environnement**
- OS: [e.g. Ubuntu 22.04]
- Node: [e.g. 20.17.0]
- Navigateur: [e.g. Chrome 120]

**Logs**
```
Logs d'erreur
```
```

## Proposer une fonctionnalité

1. Ouvrez une **Discussion** sur GitHub
2. Décrivez :
   - Le besoin
   - La solution proposée
   - Les alternatives considérées
3. Attendez le feedback de la communauté
4. Si validé, créez une issue puis une PR

## Reconnaissance

Les contributeurs sont listés dans le README avec :

- Nombre de commits
- Type de contributions
- Lien vers leur profil

## Besoin d'aide ?

- **Discord** : (lien si disponible)
- **Email** : contact@example.com
- **GitHub Issues** : Pour les bugs
- **GitHub Discussions** : Pour les questions

## Code of Conduct

En contribuant, vous acceptez de suivre notre [Code of Conduct](CODE_OF_CONDUCT.md).

**Principes :**

- Respectez les autres contributeurs
- Communiquez de manière constructive
- Aidez les débutants
- Soyez inclusif

---

