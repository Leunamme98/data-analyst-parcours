# Leçon 1-1 — Introduction à SQL : Création d'une base de données de librairie

## Objectifs pédagogiques

- Créer une base de données relationnelle depuis zéro
- Définir des tables avec des contraintes (PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK)
- Insérer des données dans plusieurs tables liées
- Vérifier les données insérées avec `SELECT`

---

## Description de la base de données — `librairiedb`

`librairiedb` est une base de données simulant la gestion d'une librairie. Elle contient trois tables interconnectées qui permettent de gérer les **auteurs**, les **livres** et les **clients** de la librairie.

### Schéma relationnel

```
auteurs (id, prenom, nom, nationalite, date_naissance)
    │
    │  1 auteur → N livres
    ▼
livres  (id, titre, prix, date_publication, stock, auteur_id)

clients (id, prenom, nom, email, date_inscription, ville)
```

### Table `auteurs`

Stocke les informations sur les auteurs des livres disponibles en librairie.

| Colonne          | Type   | Contraintes | Description                        |
| ---------------- | ------ | ----------- | ---------------------------------- |
| `id`             | SERIAL | PRIMARY KEY | Identifiant unique auto-incrémenté |
| `prenom`         | TEXT   | NOT NULL    | Prénom de l'auteur                 |
| `nom`            | TEXT   | NOT NULL    | Nom de famille de l'auteur         |
| `nationalite`    | TEXT   | NOT NULL    | Nationalité de l'auteur            |
| `date_naissance` | DATE   | NOT NULL    | Date de naissance de l'auteur      |

### Table `livres`

Stocke le catalogue des livres avec leur prix, leur stock et leur auteur associé.

| Colonne            | Type          | Contraintes                  | Description                        |
| ------------------ | ------------- | ---------------------------- | ---------------------------------- |
| `id`               | SERIAL        | PRIMARY KEY                  | Identifiant unique auto-incrémenté |
| `titre`            | TEXT          | NOT NULL                     | Titre du livre                     |
| `prix`             | NUMERIC(15,2) | NOT NULL                     | Prix de vente (2 décimales)        |
| `date_publication` | TIMESTAMP     | NOT NULL                     | Date de première publication       |
| `stock`            | INT           | NOT NULL, CHECK (stock >= 0) | Quantité disponible en stock       |
| `auteur_id`        | INT           | FOREIGN KEY → auteurs(id)    | Référence vers l'auteur du livre   |

### Table `clients`

Stocke les informations sur les clients inscrits à la librairie.

| Colonne            | Type      | Contraintes               | Description                        |
| ------------------ | --------- | ------------------------- | ---------------------------------- |
| `id`               | SERIAL    | PRIMARY KEY               | Identifiant unique auto-incrémenté |
| `prenom`           | TEXT      | NOT NULL                  | Prénom du client                   |
| `nom`              | TEXT      | NOT NULL                  | Nom de famille du client           |
| `email`            | TEXT      | UNIQUE, NOT NULL          | Adresse email (unique par client)  |
| `date_inscription` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Date d'inscription automatique     |
| `ville`            | TEXT      | NOT NULL                  | Ville de résidence du client       |

### Données de départ

| Table     | Nombre d'enregistrements | Détails                                      |
| --------- | ------------------------ | -------------------------------------------- |
| `auteurs` | 5                        | Hugo, Shakespeare, Austen, Camus, Tolstoï    |
| `livres`  | 50                       | 10 livres par auteur                         |
| `clients` | 10                       | Clients de Lomé, Abidjan, Paris, Dakar, etc. |

---

## Commandes SQL expliquées

### 1. Créer la base de données

```sql
CREATE DATABASE librairiedb;
```

Cette commande crée une nouvelle base de données vide nommée `librairiedb`.

---

### 2. Créer les tables

#### Syntaxe générale

```sql
CREATE TABLE IF NOT EXISTS nom_table (
    colonne1 TYPE CONTRAINTE,
    colonne2 TYPE CONTRAINTE,
    ...
);
```

- `IF NOT EXISTS` : évite une erreur si la table existe déjà.
- `SERIAL` : entier auto-incrémenté (1, 2, 3…), idéal pour les clés primaires.
- `PRIMARY KEY` : identifiant unique de chaque ligne, jamais NULL.
- `NOT NULL` : la colonne doit toujours avoir une valeur.
- `UNIQUE` : deux lignes ne peuvent pas avoir la même valeur dans cette colonne.
- `CHECK` : valide une condition avant l'insertion (ex : `stock >= 0`).
- `FOREIGN KEY ... REFERENCES` : lie une colonne à la clé primaire d'une autre table.
- `DEFAULT` : valeur utilisée si aucune valeur n'est fournie lors de l'insertion.

#### Création de la table `auteurs`

```sql
CREATE TABLE IF NOT EXISTS auteurs (
    id            SERIAL PRIMARY KEY,
    prenom        TEXT NOT NULL,
    nom           TEXT NOT NULL,
    nationalite   TEXT NOT NULL,
    date_naissance DATE NOT NULL
);
```

#### Création de la table `livres`

```sql
CREATE TABLE IF NOT EXISTS livres (
    id               SERIAL PRIMARY KEY,
    titre            TEXT NOT NULL,
    prix             NUMERIC(15, 2) NOT NULL,
    date_publication TIMESTAMP NOT NULL,
    stock            INT NOT NULL CHECK (stock >= 0),
    auteur_id        INT,
    FOREIGN KEY (auteur_id) REFERENCES auteurs(id)
);
```

> La contrainte `CHECK (stock >= 0)` empêche d'insérer une quantité négative en stock.
> La `FOREIGN KEY` garantit qu'on ne peut pas associer un livre à un auteur inexistant.

#### Création de la table `clients`

```sql
CREATE TABLE IF NOT EXISTS clients (
    id               SERIAL PRIMARY KEY,
    prenom           TEXT NOT NULL,
    nom              TEXT NOT NULL,
    email            TEXT UNIQUE NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ville            TEXT NOT NULL
);
```

> `DEFAULT CURRENT_TIMESTAMP` enregistre automatiquement la date et l'heure d'inscription.

---

### 3. Insérer des données

#### Syntaxe générale

```sql
INSERT INTO nom_table (colonne1, colonne2, ...) VALUES
(valeur1, valeur2, ...),
(valeur1, valeur2, ...);
```

On peut insérer plusieurs lignes en une seule commande en séparant les tuples par des virgules.

#### Insérer des auteurs

```sql
INSERT INTO auteurs (nom, prenom, nationalite, date_naissance) VALUES
('Hugo',        'Victor',  'Française', '1802-02-26'),
('Shakespeare', 'William', 'Anglaise',  '1564-04-23'),
('Austen',      'Jane',    'Anglaise',  '1775-12-16'),
('Camus',       'Albert',  'Française', '1913-11-07'),
('Leon Lev',    'Russe',   'Russe',     '1828-09-09');
```

> On ne précise pas `id` car il est géré automatiquement par `SERIAL`.

#### Insérer des livres (exemple)

```sql
INSERT INTO livres (titre, prix, date_publication, stock, auteur_id) VALUES
('Les Misérables',      25.90, '1862-01-01', 50, 1),
('Notre-Dame de Paris', 18.50, '1831-01-01', 40, 1),
('Hamlet',              16.90, '1603-01-01', 60, 2),
('L''Étranger',         14.90, '1942-01-01', 100, 4);
```

> `auteur_id = 1` désigne Victor Hugo, `auteur_id = 4` désigne Albert Camus.
> L'apostrophe dans une chaîne SQL s'échappe en la doublant : `'L''Étranger'`.

#### Insérer des clients

```sql
INSERT INTO clients (prenom, nom, email, ville) VALUES
('Emmanuel', 'Apedo',   'emmanuel.apedo@gmail.com', 'Lome'),
('Kossi',    'Mensah',  'kossi.mensah@gmail.com',   'Lome'),
('Jean',     'Dupont',  'jean.dupont@gmail.com',     'Paris');
```

> `date_inscription` est omise : elle sera remplie automatiquement avec l'heure actuelle.

---

### 4. Vérifier les données

```sql
-- Afficher tous les auteurs
SELECT * FROM auteurs;

-- Afficher tous les livres
SELECT * FROM livres;

-- Afficher tous les clients
SELECT * FROM clients;
```

L'étoile `*` sélectionne toutes les colonnes. On verra dans les prochaines leçons comment filtrer et trier ces résultats.

---

## Concepts clés à retenir

| Concept         | Explication rapide                                                                     |
| --------------- | -------------------------------------------------------------------------------------- |
| `PRIMARY KEY`   | Identifiant unique d'une ligne — ne peut pas être NULL ni dupliqué                     |
| `FOREIGN KEY`   | Lien entre deux tables — garantit l'intégrité référentielle                            |
| `SERIAL`        | Entier auto-incrémenté — pratique pour les IDs                                         |
| `NOT NULL`      | La valeur est obligatoire                                                              |
| `UNIQUE`        | Pas deux lignes identiques sur cette colonne (ex : email)                              |
| `CHECK`         | Valide une condition métier avant insertion (ex : stock positif)                       |
| `DEFAULT`       | Valeur par défaut quand la colonne est omise dans`INSERT`                              |
| `NUMERIC(15,2)` | Nombre décimal avec 15 chiffres au total et 2 après la virgule — utilisé pour les prix |
