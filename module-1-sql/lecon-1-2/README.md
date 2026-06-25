# Leçon 1-2 — SELECT : Interroger et filtrer des données

## Objectifs pédagogiques

- Sélectionner des colonnes précises avec `SELECT`
- Trier les résultats avec `ORDER BY`
- Limiter le nombre de résultats avec `LIMIT`
- Filtrer les lignes avec `WHERE` et ses opérateurs
- Combiner plusieurs clauses dans une même requête

---

## Clauses couvertes

| Clause       | Rôle                                                          |
|--------------|---------------------------------------------------------------|
| `SELECT`     | Choisit les colonnes à afficher                               |
| `FROM`       | Désigne la table source                                       |
| `WHERE`      | Filtre les lignes selon une condition                         |
| `ORDER BY`   | Trie les résultats (`ASC` croissant, `DESC` décroissant)      |
| `LIMIT`      | Limite le nombre de lignes retournées                         |
| `DISTINCT`   | Supprime les doublons dans les résultats                      |
| `BETWEEN`    | Filtre une valeur dans un intervalle (bornes incluses)        |
| `LIKE`       | Recherche un motif dans une chaîne de caractères              |
| `UPPER()`    | Convertit une chaîne en majuscules                            |
| `EXTRACT()`  | Extrait une partie d'une date (année, mois, jour…)            |

---

## Ordre d'exécution SQL

L'ordre dans lequel SQL évalue les clauses est différent de l'ordre dans lequel on les écrit :

```
1. FROM       → quelle table ?
2. WHERE      → quelles lignes ?
3. SELECT     → quelles colonnes ?
4. ORDER BY   → dans quel ordre ?
5. LIMIT      → combien de lignes ?
```

Comprendre cet ordre explique pourquoi on ne peut pas filtrer avec `WHERE` sur un alias défini dans `SELECT`.

---

## Requêtes expliquées

### Niveau 1 — Sélections simples

```sql
-- Titre et prix de tous les livres
SELECT titre, prix
FROM livres;
```

```sql
-- Clients triés par nom alphabétiquement
SELECT prenom, nom
FROM clients
ORDER BY nom ASC;
```

```sql
-- Les 5 livres les plus chers
SELECT titre, prix
FROM livres
ORDER BY prix DESC
LIMIT 5;
```

---

### Niveau 2 — Filtres avec WHERE

```sql
-- Livres à plus de 20€
SELECT titre, prix
FROM livres
WHERE prix > 20;
```

```sql
-- Clients habitant à Dakar (insensible à la casse)
SELECT prenom, nom, ville
FROM clients
WHERE UPPER(ville) = 'DAKAR';
```

```sql
-- Livres publiés avant 1900
SELECT titre, date_publication
FROM livres
WHERE EXTRACT(YEAR FROM date_publication) < 1900;
```

```sql
-- Livres dont le titre contient 'et'
SELECT titre
FROM livres
WHERE UPPER(titre) LIKE '%ET%';
```

---

### Niveau 3 — Combinaisons de clauses

```sql
-- Livres avec stock entre 20 et 40, triés par stock décroissant
SELECT titre, stock
FROM livres
WHERE stock BETWEEN 20 AND 40
ORDER BY stock DESC;
```

```sql
-- Villes distinctes des clients
SELECT DISTINCT ville
FROM clients;
```

```sql
-- Les 3 livres les moins chers avec un stock > 30
SELECT titre, prix, stock
FROM livres
WHERE stock > 30
ORDER BY prix ASC
LIMIT 3;
```

---

## Remarques importantes

### 1 — LIKE '%ET%' capte plus large que prévu

Le motif `'%ET%'` capture **tout titre contenant "ET" n'importe où**, y compris à l'intérieur d'autres mots :

| Titre retourné        | Pourquoi capté            |
|-----------------------|---------------------------|
| Roméo **et** Juliette | mot "et" isolé ✓          |
| Juli**ette**          | "ET" à l'intérieur du mot |
| Son**ate**            | "ATE" contient "AT"... non, mais "Son**ate**" contient "ate" |
| Mal**ent**endu        | "ENT" contient "ET"       |

Ce n'est pas une erreur ici, c'est le comportement attendu de `LIKE`. Dans un cas réel, pour cibler le mot "et" **isolé**, on affinerait avec des espaces :

```sql
WHERE LOWER(titre) LIKE '% et %'
```

Cela exige un espace avant et après, ce qui limite les faux positifs. La contrepartie : les titres qui commencent ou se terminent par "et" seraient ratés.

---

### 2 — EXTRACT vs comparaison directe de date

Les deux requêtes suivantes donnent le même résultat :

```sql
-- Avec EXTRACT (notre solution)
WHERE EXTRACT(YEAR FROM date_publication) < 1900

-- Avec comparaison directe (recommandé sur grands datasets)
WHERE date_publication < '1900-01-01'
```

**Pourquoi préférer la comparaison directe ?**

Appliquer une fonction sur une colonne (`EXTRACT`, `UPPER`, `LOWER`…) empêche PostgreSQL d'utiliser les **index** sur cette colonne. Sans index, la base doit scanner toutes les lignes une par une.

Sur `librairiedb` avec 50 lignes, la différence est nulle. Sur une table de 10 millions de lignes, cela peut faire passer une requête de quelques millisecondes à plusieurs secondes.

> Règle : éviter les fonctions sur les colonnes dans `WHERE` quand une alternative directe existe.

---

## Opérateurs de comparaison disponibles dans WHERE

| Opérateur       | Signification              | Exemple                          |
|-----------------|----------------------------|----------------------------------|
| `=`             | Égal                       | `WHERE ville = 'Paris'`          |
| `<>` ou `!=`   | Différent                  | `WHERE ville <> 'Paris'`         |
| `>`             | Supérieur                  | `WHERE prix > 20`                |
| `<`             | Inférieur                  | `WHERE prix < 10`                |
| `>=`            | Supérieur ou égal          | `WHERE stock >= 30`              |
| `<=`            | Inférieur ou égal          | `WHERE stock <= 50`              |
| `BETWEEN x AND y` | Dans l'intervalle [x, y] | `WHERE stock BETWEEN 20 AND 40`  |
| `LIKE '%motif%'`| Contient le motif          | `WHERE titre LIKE '%et%'`        |
| `IN (a, b, c)`  | Parmi une liste de valeurs | `WHERE ville IN ('Paris','Dakar')` |
| `IS NULL`       | Valeur absente             | `WHERE auteur_id IS NULL`        |
| `IS NOT NULL`   | Valeur présente            | `WHERE auteur_id IS NOT NULL`    |
