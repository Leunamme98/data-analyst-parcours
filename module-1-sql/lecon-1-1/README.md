# Leçon 1-1 — Création d'une base de données relationnelle

## Objectifs pédagogiques

- Comprendre ce qu'est une base de données relationnelle
- Créer une base de données et des tables avec des contraintes
- Insérer des données dans plusieurs tables liées
- Vérifier les données avec `SELECT *`

---

## Concept — Qu'est-ce qu'une base de données relationnelle ?

Une **base de données relationnelle** organise les données en **tables** (comme des feuilles Excel), reliées entre elles par des **clés**.

Chaque table représente un sujet distinct :
- une table `auteurs` → informations sur les auteurs
- une table `livres` → informations sur les livres
- une table `clients` → informations sur les clients

Au lieu de tout mettre dans une seule grande feuille (avec des répétitions), on **sépare les données** et on les **relie** par des identifiants. C'est la règle fondamentale : **ne pas dupliquer l'information**.

**Exemple concret :** plutôt que d'écrire "Victor Hugo" dans chaque ligne du livre, on met un simple numéro (`auteur_id = 1`) qui pointe vers la ligne de Victor Hugo dans la table `auteurs`.

---

## Les deux grandes catégories de commandes SQL

| Catégorie | Nom complet                  | Commandes          | Rôle                                  |
|-----------|------------------------------|--------------------|---------------------------------------|
| **DDL**   | Data Definition Language     | `CREATE`, `ALTER`, `DROP` | Définir la structure des tables  |
| **DML**   | Data Manipulation Language   | `INSERT`, `UPDATE`, `DELETE`, `SELECT` | Manipuler les données |

Dans cette leçon, on utilise du **DDL** (`CREATE`) et du **DML** (`INSERT`, `SELECT`).

---

## Description de la base de données — `librairiedb`

`librairiedb` simule la gestion d'une librairie. Elle contient trois tables interconnectées.

### Schéma relationnel

```
auteurs (id, prenom, nom, nationalite, date_naissance)
    │
    │  1 auteur peut avoir N livres
    ▼
livres  (id, titre, prix, date_publication, stock, auteur_id ──► auteurs.id)

clients (id, prenom, nom, email, date_inscription, ville)
```

La flèche `──►` représente une clé étrangère (FOREIGN KEY) : `livres.auteur_id` pointe vers `auteurs.id`.

---

### Table `auteurs`

| Colonne          | Type   | Contraintes | Description                        |
|------------------|--------|-------------|------------------------------------|
| `id`             | SERIAL | PRIMARY KEY | Identifiant unique auto-incrémenté |
| `prenom`         | TEXT   | NOT NULL    | Prénom de l'auteur                 |
| `nom`            | TEXT   | NOT NULL    | Nom de famille de l'auteur         |
| `nationalite`    | TEXT   | NOT NULL    | Nationalité de l'auteur            |
| `date_naissance` | DATE   | NOT NULL    | Date de naissance de l'auteur      |

### Table `livres`

| Colonne            | Type          | Contraintes                  | Description                      |
|--------------------|---------------|------------------------------|----------------------------------|
| `id`               | SERIAL        | PRIMARY KEY                  | Identifiant unique auto-incrémenté |
| `titre`            | TEXT          | NOT NULL                     | Titre du livre                   |
| `prix`             | NUMERIC(15,2) | NOT NULL                     | Prix de vente (2 décimales)      |
| `date_publication` | TIMESTAMP     | NOT NULL                     | Date de première publication     |
| `stock`            | INT           | NOT NULL, CHECK (stock >= 0) | Quantité disponible en stock     |
| `auteur_id`        | INT           | FOREIGN KEY → auteurs(id)    | Référence vers l'auteur          |

### Table `clients`

| Colonne            | Type      | Contraintes               | Description                       |
|--------------------|-----------|---------------------------|-----------------------------------|
| `id`               | SERIAL    | PRIMARY KEY               | Identifiant unique auto-incrémenté |
| `prenom`           | TEXT      | NOT NULL                  | Prénom du client                  |
| `nom`              | TEXT      | NOT NULL                  | Nom de famille du client          |
| `email`            | TEXT      | UNIQUE, NOT NULL          | Adresse email (unique par client) |
| `date_inscription` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Date d'inscription automatique    |
| `ville`            | TEXT      | NOT NULL                  | Ville de résidence du client      |

### Données de départ

| Table     | Lignes | Contenu                                      |
|-----------|--------|----------------------------------------------|
| `auteurs` | 5      | Hugo, Shakespeare, Austen, Camus, Tolstoï    |
| `livres`  | 50     | 10 livres par auteur                         |
| `clients` | 10     | Clients de Lomé, Abidjan, Paris, Dakar, etc. |

---

## Commandes SQL expliquées

### 1. Créer la base de données

```sql
CREATE DATABASE librairiedb;
```

Crée une base de données vide. À exécuter une seule fois.

---

### 2. Créer les tables

#### Syntaxe générale

```sql
CREATE TABLE IF NOT EXISTS nom_table (
    colonne1  TYPE  CONTRAINTE,
    colonne2  TYPE  CONTRAINTE,
    ...
);
```

#### Les types de données courants

| Type            | Description                                      | Exemple                |
|-----------------|--------------------------------------------------|------------------------|
| `SERIAL`        | Entier auto-incrémenté (1, 2, 3…)                | Clé primaire           |
| `INT`           | Nombre entier                                    | `stock INT`            |
| `NUMERIC(p, s)` | Nombre décimal avec p chiffres et s décimales    | `prix NUMERIC(15, 2)`  |
| `TEXT`          | Texte de longueur variable                       | `nom TEXT`             |
| `VARCHAR(n)`    | Texte limité à n caractères                      | `code VARCHAR(10)`     |
| `DATE`          | Date (AAAA-MM-JJ)                                | `'1802-02-26'`         |
| `TIMESTAMP`     | Date + heure                                     | `'1862-01-01 00:00:00'`|
| `BOOLEAN`       | Vrai ou faux                                     | `TRUE` / `FALSE`       |

#### Les contraintes et pourquoi elles existent

| Contrainte        | Rôle                                            | Sans elle, que se passerait-il ?              |
|-------------------|-------------------------------------------------|-----------------------------------------------|
| `PRIMARY KEY`     | Identifiant unique, jamais NULL                 | Deux lignes pourraient avoir le même ID       |
| `NOT NULL`        | La colonne doit avoir une valeur                | On pourrait insérer un livre sans titre       |
| `UNIQUE`          | Pas deux valeurs identiques dans la colonne     | Deux clients pourraient avoir le même email   |
| `CHECK (cond)`    | Valide une condition avant insertion            | On pourrait mettre un stock de -5             |
| `FOREIGN KEY`     | Lie à la clé primaire d'une autre table         | On pourrait référencer un auteur inexistant   |
| `DEFAULT val`     | Valeur automatique si non fournie               | Il faudrait renseigner la date manuellement   |
| `IF NOT EXISTS`   | N'échoue pas si la table existe déjà            | La commande retournerait une erreur           |

#### Création de la table `auteurs`

```sql
CREATE TABLE IF NOT EXISTS auteurs (
    id             SERIAL PRIMARY KEY,
    prenom         TEXT NOT NULL,
    nom            TEXT NOT NULL,
    nationalite    TEXT NOT NULL,
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

> La `FOREIGN KEY` doit être créée **après** la table `auteurs`, car elle y fait référence. L'ordre de création des tables est important.

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

---

### 3. Insérer des données

#### Syntaxe

```sql
INSERT INTO nom_table (colonne1, colonne2, ...) VALUES
(valeur1, valeur2, ...),
(valeur1, valeur2, ...);
```

On peut insérer plusieurs lignes en une seule commande en séparant les tuples par des virgules.

#### Ordre d'insertion — Respecter les dépendances

Insérer dans **`auteurs` avant `livres`**, car `livres.auteur_id` référence `auteurs.id`. Tenter l'inverse produirait une erreur de clé étrangère.

```sql
-- 1. D'abord les auteurs
INSERT INTO auteurs (nom, prenom, nationalite, date_naissance) VALUES
('Hugo',        'Victor',  'Française', '1802-02-26'),
('Shakespeare', 'William', 'Anglaise',  '1564-04-23'),
('Austen',      'Jane',    'Anglaise',  '1775-12-16'),
('Camus',       'Albert',  'Française', '1913-11-07'),
('Leon Lev',    'Russe',   'Russe',     '1828-09-09');

-- 2. Ensuite les livres (qui référencent les auteurs)
INSERT INTO livres (titre, prix, date_publication, stock, auteur_id) VALUES
('Les Misérables',      25.90, '1862-01-01', 50, 1),  -- auteur_id 1 = Victor Hugo
('Notre-Dame de Paris', 18.50, '1831-01-01', 40, 1),
('Hamlet',              16.90, '1603-01-01', 60, 2),  -- auteur_id 2 = Shakespeare
('L''Étranger',         14.90, '1942-01-01', 100, 4); -- auteur_id 4 = Camus

-- 3. Les clients (indépendants, peuvent être insérés à tout moment)
INSERT INTO clients (prenom, nom, email, ville) VALUES
('Emmanuel', 'Apedo',  'emmanuel.apedo@gmail.com', 'Lome'),
('Jean',     'Dupont', 'jean.dupont@gmail.com',    'Paris');
```

> `id` est omis dans toutes les insertions : il est géré automatiquement par `SERIAL`.  
> `date_inscription` est omise pour les clients : elle prend la valeur `CURRENT_TIMESTAMP` automatiquement.  
> L'apostrophe dans une chaîne SQL s'échappe en la doublant : `'L''Étranger'`.

---

### 4. Vérifier les données

```sql
SELECT * FROM auteurs;
SELECT * FROM livres;
SELECT * FROM clients;
```

L'étoile `*` sélectionne toutes les colonnes. On verra dans les prochaines leçons comment sélectionner des colonnes précises et filtrer les résultats.

---

## Récapitulatif des concepts

| Concept         | Définition rapide                                                              |
|-----------------|--------------------------------------------------------------------------------|
| Base de données | Ensemble organisé de tables liées entre elles                                  |
| Table           | Structure en lignes et colonnes représentant un sujet (ex : livres)            |
| Ligne / Tuple   | Un enregistrement dans une table (ex : un livre)                               |
| Colonne / Champ | Un attribut d'un enregistrement (ex : le titre)                                |
| `PRIMARY KEY`   | Identifiant unique d'une ligne — ne peut pas être NULL ni dupliqué             |
| `FOREIGN KEY`   | Lien entre deux tables — garantit l'intégrité référentielle                    |
| `SERIAL`        | Entier auto-incrémenté — pratique pour les IDs                                 |
| `NOT NULL`      | La valeur est obligatoire                                                      |
| `UNIQUE`        | Pas deux valeurs identiques sur cette colonne                                  |
| `CHECK`         | Valide une condition métier avant insertion                                    |
| `DEFAULT`       | Valeur automatique si la colonne est omise dans `INSERT`                       |
| Intégrité réf.  | Garantie qu'une clé étrangère pointe toujours vers une ligne existante         |

---

## Pour aller plus loin

- **Leçon 1-2** — Interroger les données : `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- **Leçon 1-3** — Agréger les données : `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`
- **Leçon 1-4** — Joindre plusieurs tables : `INNER JOIN`, `LEFT JOIN`

---

## Exercices

> Le fichier `create_tables.sql` contient le corrigé. Essaie de résoudre les exercices par toi-même avant de le consulter.

### Exercice 1 — Créer une table (débutant)

Crée une table `commandes` avec les colonnes suivantes :
- `id` : SERIAL, PRIMARY KEY
- `client_id` : INT, clé étrangère vers `clients(id)`
- `livre_id` : INT, clé étrangère vers `livres(id)`
- `quantite` : INT, NOT NULL, doit être strictement supérieur à 0 (CHECK)
- `date_commande` : TIMESTAMP, valeur par défaut = date et heure actuelles

---

### Exercice 2 — Insérer un auteur (débutant)

Insère un nouvel auteur dans la table `auteurs` : **Gustave Flaubert**, de nationalité Française, né le **12 décembre 1821**.

---

### Exercice 3 — Insérer des livres (débutant)

Insère 3 livres pour Gustave Flaubert (utilise l'`id` que lui a attribué PostgreSQL). Invente des données réalistes : titre, prix, date de publication, stock.

*Exemple : "Madame Bovary", 16.90, '1857-01-01', 45*

---

### Exercice 4 — Tester l'intégrité référentielle (intermédiaire)

Tente d'insérer un livre avec `auteur_id = 99` (qui n'existe pas dans la table `auteurs`). Observe le message d'erreur retourné par PostgreSQL. Explique pourquoi cette contrainte est utile.

---

### Exercice 5 — Vérifier les données (débutant)

Affiche le contenu complet des tables `auteurs`, `livres` et `clients` pour vérifier toutes tes insertions.
