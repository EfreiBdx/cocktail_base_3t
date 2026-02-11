# Architecture - Vue d'ensemble

Cette page présente l'architecture globale du projet Cocktail ClicBoumPaf.

## Architecture 3-tiers

Le projet suit une architecture **3-tiers classique** séparant présentation, logique applicative et données.

```mermaid
graph TB
    subgraph "Tier 1 - Présentation"
        FE[Frontend React<br/>Port 80]
    end
    
    subgraph "Tier 2 - Application"
        BE[Backend Express.js<br/>Port 12000]
    end
    
    subgraph "Tier 3 - Données"
        DB[(MariaDB<br/>Port 3306)]
    end
    
    U[👤 Utilisateur] -->|HTTP| FE
    FE -->|API REST| BE
    BE -->|SQL/ORM| DB
    
    style U fill:#e3f2fd
    style FE fill:#bbdefb
    style BE fill:#90caf9
    style DB fill:#64b5f6
```

## Composants principaux

### Frontend - React Application

**Technologies :**

- React 19.0.0 (UI library)
- React Router 7.1.5 (Routing)
- Vite 6.1.0 (Build tool)
- Axios (HTTP client)

**Responsabilités :**

- Interface utilisateur
- Gestion de l'état (React hooks)
- Routing côté client
- Communication API avec le backend
- Authentification (JWT storage)

**Structure :**

```
frontend/src/
├── components/     # Composants réutilisables
├── pages/          # Pages de l'application
├── hooks/          # Custom React hooks
├── utils/          # Fonctions utilitaires
├── api/            # Clients API
└── App.jsx         # Composant racine
```

### Backend - Express.js API

**Technologies :**

- Express.js 4.19.2 (Framework web)
- Sequelize 6.37.3 (ORM)
- JWT (Authentification)
- Bcrypt (Hash passwords)

**Responsabilités :**

- API REST
- Logique métier
- Authentification & autorisation
- Validation des données
- Communication avec la BDD

**Structure :**

```
backend/api/
├── controllers/    # Logique des endpoints
├── models/         # Modèles Sequelize
├── routes/         # Définition des routes
├── middlewares/    # Middlewares (auth, etc.)
└── config/         # Configuration (BDD, etc.)
```

### Base de données - MariaDB

**Technologies :**

- MariaDB latest
- Sequelize ORM

**Responsabilités :**

- Stockage persistant
- Relations entre entités
- Contraintes d'intégrité

**Schéma (exemple) :**

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cocktails (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## Flux de communication

### Flux d'authentification

```mermaid
sequenceDiagram
    actor User
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database
    
    User->>FE: Login (username, password)
    FE->>BE: POST /api/auth/login
    BE->>DB: SELECT user WHERE username = ?
    DB-->>BE: User data
    BE->>BE: Verify password (bcrypt)
    BE->>BE: Generate JWT
    BE-->>FE: JWT token
    FE->>FE: Store JWT (localStorage)
    FE-->>User: Redirect to dashboard
    
    Note over FE,BE: Requêtes suivantes incluent le JWT
    
    FE->>BE: GET /api/users (Authorization: Bearer JWT)
    BE->>BE: Verify JWT
    BE->>DB: Query data
    DB-->>BE: Results
    BE-->>FE: JSON response
```

### Flux API classique

```mermaid
sequenceDiagram
    participant FE as Frontend
    participant BE as Backend
    participant DB as Database
    
    FE->>BE: GET /api/cocktails
    BE->>BE: Authenticate (JWT)
    BE->>BE: Authorize
    BE->>DB: SELECT * FROM cocktails
    DB-->>BE: Results
    BE->>BE: Format response
    BE-->>FE: JSON { cocktails: [...] }
    FE->>FE: Update UI (React state)
```

## Architecture Docker

### Containers

```mermaid
graph TB
    subgraph "Docker Network"
        C1[mono-front<br/>nginx:alpine]
        C2[mono-back<br/>node:20-alpine]
        C3[mono-bdd<br/>mariadb:latest]
    end
    
    C1 -->|Port 80| EXT[Internet]
    C2 -->|Port 12000| EXT
    C2 -->|SQL| C3
    
    V1[Volume<br/>./mysql] -.->|Persistence| C3
    
    style C1 fill:#e8f5e9
    style C2 fill:#c8e6c9
    style C3 fill:#a5d6a7
    style V1 fill:#fff9c4
```

### Docker Compose

```yaml
services:
  mono-bdd:
    image: mariadb:latest
    volumes:
      - ./mysql:/var/lib/mysql  # Persistence
    environment:
      MARIADB_ROOT_PASSWORD: TOOR
      MARIADB_DATABASE: bddname
      MARIADB_USER: roger
      MARIADB_PASSWORD: regor
    healthcheck:
      test: ['CMD', '/usr/local/bin/healthcheck.sh']
    
  mono-back:
    image: ${MONO_PROJECT_BACK}
    ports:
      - 12000:12000
    environment:
      BDD_HOST: mono-bdd
      BDD_PORT: 3306
    depends_on:
      mono-bdd:
        condition: service_healthy  # Attend que la BDD soit prête
    
  mono-front:
    image: ${MONO_PROJECT_FRONT}
    ports:
      - 80:80
```

## Architecture Azure (Canary)

### Infrastructure déployée

```mermaid
graph TB
    subgraph "Azure Cloud"
        subgraph "Resource Group: ClicBoumPaf-Canary"
            VM[Virtual Machine<br/>Standard_B2s]
            NIC[Network Interface]
            NSG[Network Security Group]
            PIP[Public IP Address]
            VNET[Virtual Network]
        end
        
        DNS[Azure DNS<br/>demo.clic-boum-paf.com]
    end
    
    Internet -->|HTTP/HTTPS| PIP
    PIP --> NIC
    NIC --> VM
    NSG -.->|Rules| NIC
    NIC --> VNET
    DNS -.->|monocanary| PIP
    
    VM -->|Docker Compose| D[mono-front + mono-back + mono-bdd]
    
    style VM fill:#0078d4
    style NSG fill:#00bcf2
    style PIP fill:#50e6ff
    style DNS fill:#ff6347
```

### Network Security Group Rules

| Rule | Port | Protocol | Source | Destination |
|------|------|----------|--------|-------------|
| SSH | 22 | TCP | * | * |
| HTTP | 80 | TCP | * | * |
| Backend | 12000 | TCP | * | * |

### Flux de déploiement

```mermaid
graph LR
    GHA[GitHub Actions] -->|1. Login OIDC| Azure
    GHA -->|2. Create RG| RG[Resource Group]
    GHA -->|3. Deploy Bicep| VM[VM + Network]
    GHA -->|4. SSH| VM
    GHA -->|5. Install Docker| VM
    GHA -->|6. Deploy DNS| DNS[Azure DNS]
    GHA -->|7. SCP docker-compose| VM
    GHA -->|8. Docker pull & up| VM
    GHA -->|9. OWASP ZAP scan| VM
    
    style GHA fill:#2088ff
    style Azure fill:#0078d4
    style VM fill:#00bcf2
```

## Sécurité

### Authentification & Autorisation

```mermaid
graph LR
    U[User] -->|1. Login| FE[Frontend]
    FE -->|2. POST credentials| BE[Backend]
    BE -->|3. Query| DB[(Database)]
    DB -->|4. User data| BE
    BE -->|5. Verify password| BE
    BE -->|6. Generate JWT| JWT[JWT Token]
    JWT -->|7. Return| FE
    FE -->|8. Store| LS[localStorage]
    
    FE -->|9. API call + JWT| BE
    BE -->|10. Verify JWT| MW[Auth Middleware]
    MW -->|11. Decode| Payload[User ID, Role]
    MW -->|12. Authorize| BE
    
    style JWT fill:#ffeb3b
    style MW fill:#ff9800
```

### Layers de sécurité

1. **Network Layer** : NSG Azure, HTTPS (à implémenter)
2. **Application Layer** : JWT, input validation, CORS
3. **Data Layer** : Hashed passwords (bcrypt), prepared statements (Sequelize)

## Performance & Scalabilité

### Limites actuelles (Phase 1)

- Pas de load balancing
- Pas de cache (Redis)
- Pas de CDN
- Scalabilité verticale uniquement

### Optimisations possibles

```mermaid
graph TB
    LB[Load Balancer] --> FE1[Frontend 1]
    LB --> FE2[Frontend 2]
    
    FE1 --> BE1[Backend 1]
    FE2 --> BE1
    FE1 --> BE2[Backend 2]
    FE2 --> BE2
    
    BE1 --> Cache[Redis Cache]
    BE2 --> Cache
    
    Cache -.->|Cache miss| DB[(Primary DB)]
    DB --> DB2[(Read Replica)]
    
    style LB fill:#ff6347
    style Cache fill:#ffa500
    style DB fill:#4169e1
    style DB2 fill:#87ceeb
```

## Évolution future

### Phase 2 : Kubernetes

Migration vers une architecture cloud-native :

```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Ingress"
            ING[Ingress Controller]
        end
        
        subgraph "Frontend"
            FE1[Pod 1]
            FE2[Pod 2]
            FE3[Pod 3]
        end
        
        subgraph "Backend"
            BE1[Pod 1]
            BE2[Pod 2]
        end
        
        subgraph "Database"
            DB[StatefulSet]
        end
    end
    
    ING --> FE1 & FE2 & FE3
    FE1 & FE2 & FE3 --> BE1 & BE2
    BE1 & BE2 --> DB
    
    style ING fill:#ff6347
    style DB fill:#4169e1
```

### Phase 3 : Microservices

Découpage en services métier :

```mermaid
graph TB
    API[API Gateway]
    
    API --> US[User Service]
    API --> CS[Cocktail Service]
    API --> AS[Auth Service]
    
    US --> UDB[(Users DB)]
    CS --> CDB[(Cocktails DB)]
    AS --> ADB[(Auth DB)]
    
    MQ[Message Queue] -.-> US
    MQ -.-> CS
    
    style API fill:#ff6347
    style MQ fill:#ffa500
```

---

## Approfondissement

Pour en savoir plus sur chaque composant :

- [Backend](backend.md) - Architecture détaillée du backend
- [Frontend](frontend.md) - Architecture du frontend React
- [Base de données](database.md) - Schéma et modèles
- [Docker](docker.md) - Configuration Docker complète

---

!!! info "Architecture évolutive"
    Cette architecture simple (Phase 1) est volontairement basique pour faciliter l'apprentissage. Les phases suivantes introduiront progressivement la complexité (K8s, microservices).
