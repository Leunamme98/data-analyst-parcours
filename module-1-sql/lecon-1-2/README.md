# Leçon 1-2 — SELECT : Interroger et filtrer des données

## Objectifs pédagogiques

- Sélectionner des colonnes précises avec `SELECT`
- Trier les résultats avec `ORDER BY`
- Limiter le nombre de résultats avec `LIMIT`
- Filtrer les lignes avec `WHERE` et ses opérateurs
- Éliminer les doublons avec `DISTINCT`
- Combiner plusieurs clauses dans une même requête

---

## L'ordre d'exécution SQL — à connaître absolument

L'ordre dans lequel on **écrit** les clauses est différent de l'ordre dans lequel SQL les **exécute**. Comprendre cet ordre est fondamental pour éviter les erreurs.

```
Ordre d'écriture :    SELECT → FROM → WHERE → ORDER BY → LIMIT
Ordre d'exécution :   FROM → WHERE → SELECT → ORDER BY → LIMIT
```

**Conséquence pratique :** on ne peut pas utiliser dans `WHERE` un alias défini dans `SELECT`, car `WHERE` est évalué avant `SELECT`.

```sql
-- ERREUR : prix_ttc n'existe pas encore au moment où WHERE est évalué
SELECT prix * 1.2 AS prix_ttc
FROM livres
WHERE prix_ttc > 20;  -- ← invalide

-- CORRECT
SELECT prix * 1.2 AS prix_ttc
FROM livres
WHERE prix * 1.2 > 20;  -- ← répéter l'expression
```

---

## Clauses couvertes

| Clause     | Rôle                                                         |
|------------|--------------------------------------------------------------|
| `SELECT`   | Choisit les colonnes à afficher                              |
| `FROM`     | Désigne la table source                                      |
| `WHERE`    | Filtre les lignes selon une condition                        |
| `ORDER BY` | Trie les résultats (`ASC` croissant, `DESC` décroissant)     |
| `LIMIT`    | Limite le nombre de lignes retournées                        |
| `DISTINCT` | Supprime les doublons dans les résultats                     |
| `BETWEEN`  | Filtre une valeur dans un intervalle (bornes incluses)       |
| `LIKE`     | Recherche un motif dans une chaîne de caractères             |
| `IN`       | Vérifie si une valeur appartient à une liste                 |
| `UPPER()`  | Convertit une chaîne en majuscules                           |
| `EXTRACT()`| Extrait une partie d'une date (année, mois, jour…)           |

---

## Requêtes expliquées

### Niveau 1 — Sélections simples

```sql
-- Titre et prix de tous les livres
-- Toujours préférer nommer les colonnes plutôt que SELECT * en production
SELECT titre, prix
FROM livres;
```

```sql
-- Clients triés par nom alphabétiquement
-- ASC = A → Z (défaut), DESC = Z → A
SELECT prenom, nom
FROM clients
ORDER BY nom ASC;
```

```sql
-- Les 5 livres les plus chers
-- ORDER BY avant LIMIT : on trie d'abord, puis on coupe
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
-- Clients habitant à Dakar (insensible à la casse grâce à UPPER)
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

> **Remarque performance :** `EXTRACT()` sur une colonne empêche l'utilisation d'un index.  
> Sur un grand dataset, préférer : `WHERE date_publication < '1900-01-01'`

```sql
-- Livres dont le titre contient le mot 'et'
SELECT titre
FROM livres
WHERE UPPER(titre) LIKE '%ET%';
```

> **Remarque LIKE :** `'%ET%'` capture tout titre contenant "ET" n'importe où, y compris à l'intérieur d'autres mots ("Malentendu", "Nuit"...). Pour cibler le mot isolé : `LIKE '% et %'` (avec des espaces autour).

---

### Niveau 3 — Combinaisons de clauses

```sql
-- Livres avec stock entre 20 et 40, triés par stock décroissant
-- BETWEEN x AND y équivaut à col >= x AND col <= y (bornes incluses)
SELECT titre, stock
FROM livres
WHERE stock BETWEEN 20 AND 40
ORDER BY stock DESC;
```

```sql
-- Villes distinctes des clients (sans doublons)
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

## Tous les opérateurs disponibles dans WHERE

### Opérateurs de comparaison

| Opérateur  | Signification       | Exemple                     |
|------------|---------------------|-----------------------------|
| `=`        | Égal                | `WHERE ville = 'Paris'`     |
| `<>` / `!=`| Différent           | `WHERE ville <> 'Paris'`    |
| `>`        | Supérieur           | `WHERE prix > 20`           |
| `<`        | Inférieur           | `WHERE prix < 10`           |
| `>=`       | Supérieur ou égal   | `WHERE stock >= 30`         |
| `<=`       | Inférieur ou égal   | `WHERE stock <= 50`         |

### Opérateurs de plage et de liste

| Opérateur            | Description                          | Exemple                                    |
|----------------------|--------------------------------------|--------------------------------------------|
| `BETWEEN x AND y`   | Dans l'intervalle [x, y]             | `WHERE stock BETWEEN 20 AND 40`            |
| `IN (a, b, c)`      | Parmi une liste de valeurs           | `WHERE ville IN ('Paris', 'Dakar', 'Lome')`|
| `NOT IN (a, b, c)`  | Absent d'une liste                   | `WHERE ville NOT IN ('Paris')`             |

### Opérateurs de texte

| Opérateur        | Description                             | Exemple                            |
|------------------|-----------------------------------------|------------------------------------|
| `LIKE 'motif'`   | Correspond au motif (sensible casse)    | `WHERE titre LIKE 'Les%'`          |
| `ILIKE 'motif'`  | Correspond au motif (insensible casse)  | `WHERE titre ILIKE '%et%'`         |
| `NOT LIKE`       | Ne correspond pas au motif              | `WHERE titre NOT LIKE '%et%'`      |

**Caractères spéciaux de LIKE :**
- `%` → remplace n'importe quelle suite de caractères (y compris vide)
- `_` → remplace exactement un caractère

```sql
WHERE titre LIKE 'Les%'    -- commence par "Les"
WHERE titre LIKE '%Paris'  -- se termine par "Paris"
WHERE titre LIKE '%et%'    -- contient "et" n'importe où
WHERE nom   LIKE 'H___'    -- commence par H suivi d'exactement 3 caractères
```

### Opérateurs de valeur nulle

| Opérateur      | Description               | Exemple                          |
|----------------|---------------------------|----------------------------------|
| `IS NULL`      | La valeur est absente     | `WHERE auteur_id IS NULL`        |
| `IS NOT NULL`  | La valeur est présente    | `WHERE auteur_id IS NOT NULL`    |

> Attention : `WHERE auteur_id = NULL` ne fonctionne **pas**. Il faut toujours utiliser `IS NULL`.

### Opérateurs logiques

| Opérateur | Description                              | Exemple                                      |
|-----------|------------------------------------------|----------------------------------------------|
| `AND`     | Les deux conditions doivent être vraies  | `WHERE prix > 15 AND stock > 30`             |
| `OR`      | Au moins une condition doit être vraie   | `WHERE ville = 'Paris' OR ville = 'Dakar'`   |
| `NOT`     | Inverse la condition                     | `WHERE NOT ville = 'Paris'`                  |

**Priorité des opérateurs :** `NOT` > `AND` > `OR`. Utiliser des parenthèses pour lever toute ambiguïté.

```sql
-- Sans parenthèses : ambigu
WHERE ville = 'Paris' OR ville = 'Dakar' AND prix > 20

-- Avec parenthèses : clair
WHERE (ville = 'Paris' OR ville = 'Dakar') AND prix > 20
```

---

## Fonctions utiles dans SELECT

| Fonction         | Description                              | Exemple                          |
|------------------|------------------------------------------|----------------------------------|
| `UPPER(col)`     | Convertit en majuscules                  | `UPPER('paris')` → `'PARIS'`    |
| `LOWER(col)`     | Convertit en minuscules                  | `LOWER('PARIS')` → `'paris'`    |
| `LENGTH(col)`    | Nombre de caractères                     | `LENGTH('Hamlet')` → `6`        |
| `TRIM(col)`      | Supprime les espaces en début/fin        | `TRIM('  hello  ')` → `'hello'` |
| `EXTRACT(p FROM col)` | Extrait une partie de date        | `EXTRACT(YEAR FROM date_publication)` |
| `col1 \|\| col2` | Concaténation de chaînes                | `prenom \|\| ' ' \|\| nom`       |

---

## Pour aller plus loin

- **Leçon 1-3** — Agréger les données : `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`
- **Leçon 1-4** — Joindre plusieurs tables : `INNER JOIN`, `LEFT JOIN`

---

## Exercices

> Le fichier `select_queries.sql` contient le corrigé. Essaie de résoudre les exercices par toi-même avant de le consulter.

### Exercice 1 — Filtre simple (débutant)

Affiche le titre et le stock de tous les livres dont le stock est **strictement inférieur à 20**, triés par stock croissant.

---

### Exercice 2 — LIKE et OR (débutant)

Affiche le prénom et le nom des clients dont le prénom **commence par la lettre 'A' ou la lettre 'E'**.

*Indice : utilise `LIKE` avec `OR`, ou `ILIKE` pour ignorer la casse.*

---

### Exercice 3 — Filtre sur date (intermédiaire)

Affiche les titres et dates de publication de tous les livres publiés **entre le 1er janvier 1850 et le 31 décembre 1950**, triés par date de publication croissante.

*Indice : utilise `BETWEEN` avec des dates au format `'AAAA-MM-JJ'`.*

---

### Exercice 4 — DISTINCT et exclusion (intermédiaire)

Affiche les **villes distinctes** des clients, en **excluant la ville de Lomé**, triées alphabétiquement.

---

### Exercice 5 — Combinaison (intermédiaire)

Affiche le titre et le prix des **3 livres les moins chers** dont le titre contient le mot **"la"** (insensible à la casse).
