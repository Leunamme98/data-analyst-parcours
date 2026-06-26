# Leçon 1-3 — Agrégations : résumer et grouper des données

## Objectifs pédagogiques

- Utiliser les fonctions d'agrégation : `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- Regrouper les données avec `GROUP BY`
- Filtrer les groupes avec `HAVING`
- Comprendre la différence entre `WHERE` et `HAVING`
- Créer des colonnes conditionnelles avec `CASE WHEN`
- Combiner des résultats avec `UNION ALL`

---

## Concept — Qu'est-ce qu'une agrégation ?

Une **fonction d'agrégation** prend un ensemble de lignes et retourne **une seule valeur** calculée sur cet ensemble.

```
lignes individuelles         résultat agrégé
──────────────────    →     ───────────────
prix: 25.90                 AVG(prix) = 17.82
prix: 18.50
prix: 14.90
prix: 12.15
```

Sans `GROUP BY`, la fonction s'applique à **toutes les lignes** de la table.  
Avec `GROUP BY`, elle s'applique séparément à **chaque groupe**.

---

## Ordre d'exécution SQL avec agrégation

```
1. FROM        → quelle table ?
2. WHERE       → filtrer les lignes (avant le groupement)
3. GROUP BY    → former les groupes
4. Agrégation  → calculer COUNT, SUM, AVG… sur chaque groupe
5. HAVING      → filtrer les groupes (après le groupement)
6. SELECT      → sélectionner les colonnes et expressions
7. ORDER BY    → trier les résultats
8. LIMIT       → limiter le nombre de lignes
```

Cette séquence explique la règle fondamentale :
> **`WHERE` filtre les lignes** (avant GROUP BY). **`HAVING` filtre les groupes** (après GROUP BY).

---

## Toutes les fonctions d'agrégation

### Fonctions de base

| Fonction       | Description                                        | Exemple                          |
|----------------|----------------------------------------------------|----------------------------------|
| `COUNT(*)`     | Compte toutes les lignes (y compris les NULL)      | `COUNT(*) → 50`                 |
| `COUNT(col)`   | Compte les lignes où la colonne n'est pas NULL     | `COUNT(auteur_id) → 48`         |
| `COUNT(DISTINCT col)` | Compte les valeurs distinctes non-NULL    | `COUNT(DISTINCT ville) → 5`     |
| `SUM(col)`     | Additionne les valeurs de la colonne               | `SUM(stock) → 2100`             |
| `AVG(col)`     | Calcule la moyenne (ignore les NULL)               | `AVG(prix) → 17.82`             |
| `MIN(col)`     | Retourne la valeur minimale                        | `MIN(prix) → 10.50`             |
| `MAX(col)`     | Retourne la valeur maximale                        | `MAX(prix) → 29.90`             |

```sql
SELECT
    COUNT(*)                  AS total_livres,
    COUNT(DISTINCT auteur_id) AS nb_auteurs,
    SUM(stock)                AS stock_total,
    ROUND(AVG(prix), 2)       AS prix_moyen,
    MIN(prix)                 AS prix_min,
    MAX(prix)                 AS prix_max
FROM livres;
```

---

### Fonctions de mise en forme numérique

| Fonction           | Description                                    | Exemple                        |
|--------------------|------------------------------------------------|--------------------------------|
| `ROUND(val, n)`    | Arrondit à n décimales                         | `ROUND(17.826, 2) → 17.83`    |
| `CEIL(val)`        | Arrondit à l'entier supérieur                  | `CEIL(17.2) → 18`             |
| `FLOOR(val)`       | Arrondit à l'entier inférieur                  | `FLOOR(17.9) → 17`            |
| `TRUNC(val, n)`    | Tronque à n décimales (sans arrondi)           | `TRUNC(17.99, 1) → 17.9`      |
| `ABS(val)`         | Valeur absolue                                 | `ABS(-5) → 5`                 |

```sql
SELECT
    ROUND(AVG(prix), 2) AS prix_moyen_arrondi,
    CEIL(AVG(prix))     AS prix_moyen_superieur,
    FLOOR(AVG(prix))    AS prix_moyen_inferieur
FROM livres;
```

---

### Fonctions statistiques

| Fonction            | Description                                          |
|---------------------|------------------------------------------------------|
| `STDDEV(col)`       | Écart-type (sample, n-1)                            |
| `STDDEV_POP(col)`   | Écart-type de la population (n)                     |
| `VARIANCE(col)`     | Variance (sample, n-1)                              |
| `VAR_POP(col)`      | Variance de la population (n)                       |

```sql
SELECT
    ROUND(AVG(prix), 2)       AS prix_moyen,
    ROUND(STDDEV(prix), 2)    AS ecart_type,
    ROUND(MIN(prix), 2)       AS prix_min,
    ROUND(MAX(prix), 2)       AS prix_max
FROM livres;
```

> Ces fonctions sont utiles pour détecter la dispersion des données. Un écart-type élevé signifie que les prix sont très dispersés autour de la moyenne.

---

### Fonctions de chaînes et de tableaux (avancé)

| Fonction                       | Description                                             | Exemple                                  |
|--------------------------------|---------------------------------------------------------|------------------------------------------|
| `STRING_AGG(col, séparateur)`  | Concatène les valeurs d'un groupe en une chaîne        | `STRING_AGG(titre, ', ')`               |
| `ARRAY_AGG(col)`               | Rassemble les valeurs d'un groupe dans un tableau      | `ARRAY_AGG(titre)`                       |
| `BOOL_AND(condition)`          | Vrai si toutes les lignes satisfont la condition       | `BOOL_AND(stock > 0)`                   |
| `BOOL_OR(condition)`           | Vrai si au moins une ligne satisfait la condition      | `BOOL_OR(stock > 100)`                  |

```sql
-- Liste de tous les titres par auteur, séparés par une virgule
SELECT
    auteur_id,
    STRING_AGG(titre, ', ' ORDER BY titre) AS liste_titres
FROM livres
GROUP BY auteur_id;
```

```sql
-- Pour chaque auteur : est-ce que TOUS ses livres ont un stock > 0 ?
SELECT
    auteur_id,
    BOOL_AND(stock > 0) AS tous_en_stock
FROM livres
GROUP BY auteur_id;
```

---

## GROUP BY — Règle fondamentale

Toute colonne présente dans `SELECT` qui **n'est pas** une fonction d'agrégation **doit apparaître dans `GROUP BY`**.

```sql
-- ERREUR : titre n'est pas agrégé et pas dans GROUP BY
SELECT auteur_id, titre, COUNT(*) AS nb
FROM livres
GROUP BY auteur_id;

-- CORRECT
SELECT auteur_id, COUNT(*) AS nb
FROM livres
GROUP BY auteur_id;

-- CORRECT : titre aussi dans GROUP BY
SELECT auteur_id, titre, COUNT(*) AS nb
FROM livres
GROUP BY auteur_id, titre;
```

---

## WHERE vs HAVING — La différence clé

| Critère           | `WHERE`                              | `HAVING`                             |
|-------------------|--------------------------------------|--------------------------------------|
| S'applique sur    | Les lignes individuelles             | Les groupes après agrégation         |
| Exécuté           | Avant `GROUP BY`                     | Après `GROUP BY`                     |
| Peut utiliser     | Colonnes brutes                      | Fonctions d'agrégation               |
| Peut utiliser     | Pas les fonctions d'agrégation       | Et aussi les colonnes brutes         |

```sql
-- WHERE filtre les lignes AVANT le groupement
-- → on exclut d'abord les livres à moins de 10€, PUIS on groupe
SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moyen
FROM livres
WHERE prix >= 10           -- ← filtre sur les lignes individuelles
GROUP BY auteur_id;

-- HAVING filtre les groupes APRÈS le groupement
-- → on groupe d'abord, PUIS on exclut les auteurs avec prix moyen < 16€
SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moyen
FROM livres
GROUP BY auteur_id
HAVING AVG(prix) > 16;    -- ← filtre sur le résultat agrégé

-- Les deux peuvent coexister dans la même requête
SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moyen
FROM livres
WHERE prix >= 10           -- 1. filtre les lignes
GROUP BY auteur_id
HAVING AVG(prix) > 16     -- 2. filtre les groupes
ORDER BY prix_moyen DESC;
```

---

## UNION et UNION ALL — Empiler des résultats

`UNION ALL` empile les résultats de deux requêtes en un seul tableau.  
Les deux requêtes doivent retourner le **même nombre de colonnes** avec des **types compatibles**.

| Opérateur   | Doublons                    |
|-------------|----------------------------|
| `UNION`     | Supprime les doublons       |
| `UNION ALL` | Conserve tous les résultats |

```sql
-- Livre le plus cher et livre le moins cher dans un seul résultat
SELECT 'Maximum' AS type, titre, prix
FROM livres
WHERE prix = (SELECT MAX(prix) FROM livres)

UNION ALL

SELECT 'Minimum' AS type, titre, prix
FROM livres
WHERE prix = (SELECT MIN(prix) FROM livres);
```

> Utiliser `UNION ALL` par défaut (plus performant). N'utiliser `UNION` que si on a besoin de dédoublonner.

---

## CASE WHEN — Colonnes conditionnelles

`CASE WHEN` crée une valeur calculée en fonction de conditions, comme un `IF/ELSE`.

```sql
-- Syntaxe générale
CASE
    WHEN condition1 THEN valeur1
    WHEN condition2 THEN valeur2
    ELSE valeur_par_defaut
END AS nom_colonne
```

```sql
-- Catégoriser les livres par tranche de stock
SELECT
    titre,
    stock,
    CASE
        WHEN stock BETWEEN 0  AND 30 THEN 'faible'
        WHEN stock BETWEEN 31 AND 60 THEN 'moyen'
        ELSE 'élevé'
    END AS tranche_stock
FROM livres;
```

```sql
-- Combiner CASE WHEN avec GROUP BY et COUNT
SELECT
    CASE
        WHEN stock BETWEEN 0  AND 30 THEN 'faible (0-30)'
        WHEN stock BETWEEN 31 AND 60 THEN 'moyen (31-60)'
        ELSE 'élevé (61+)'
    END AS tranche_stock,
    COUNT(id) AS nbre_livres
FROM livres
WHERE prix > 15
GROUP BY
    CASE
        WHEN stock BETWEEN 0  AND 30 THEN 'faible (0-30)'
        WHEN stock BETWEEN 31 AND 60 THEN 'moyen (31-60)'
        ELSE 'élevé (61+)'
    END;
```

---

## Sous-requêtes dans HAVING

Une **sous-requête** est une requête imbriquée dans une autre. Elle est utile quand on a besoin du résultat d'une agrégation pour filtrer une autre agrégation.

```sql
-- Quelle ville a le plus de clients ?
-- Étape 1 (sous-requête interne) : compter les clients par ville
-- Étape 2 (sous-requête externe) : trouver le MAX de ces comptes
-- Étape 3 (requête principale) : garder uniquement la ville avec ce MAX

SELECT ville, COUNT(id) AS nbre_clients
FROM clients
GROUP BY ville
HAVING COUNT(id) = (
    SELECT MAX(nbre)
    FROM (
        SELECT COUNT(id) AS nbre
        FROM clients
        GROUP BY ville
    ) AS sous_requete
);
```

> Ce pattern "groupe avec le maximum" est très courant en SQL. On le verra aussi avec les CTEs (Leçon 1-5) de façon plus lisible.

---

## Récapitulatif — Toutes les fonctions d'agrégation

| Fonction                 | Catégorie    | Description                                   |
|--------------------------|--------------|-----------------------------------------------|
| `COUNT(*)`               | Comptage     | Toutes les lignes                             |
| `COUNT(col)`             | Comptage     | Lignes non-NULL                               |
| `COUNT(DISTINCT col)`    | Comptage     | Valeurs distinctes non-NULL                   |
| `SUM(col)`               | Somme        | Total des valeurs                             |
| `AVG(col)`               | Moyenne      | Moyenne (ignore les NULL)                     |
| `MIN(col)`               | Extremes     | Valeur minimale                               |
| `MAX(col)`               | Extremes     | Valeur maximale                               |
| `ROUND(val, n)`          | Mise en forme| Arrondi à n décimales                         |
| `CEIL(val)`              | Mise en forme| Arrondi à l'entier supérieur                  |
| `FLOOR(val)`             | Mise en forme| Arrondi à l'entier inférieur                  |
| `STDDEV(col)`            | Statistiques | Écart-type (sample)                           |
| `STDDEV_POP(col)`        | Statistiques | Écart-type (population)                       |
| `VARIANCE(col)`          | Statistiques | Variance (sample)                             |
| `VAR_POP(col)`           | Statistiques | Variance (population)                         |
| `STRING_AGG(col, sep)`   | Chaînes      | Concaténation avec séparateur                 |
| `ARRAY_AGG(col)`         | Tableaux     | Regroupement en tableau PostgreSQL            |
| `BOOL_AND(cond)`         | Booléens     | Vrai si toutes les lignes satisfont cond      |
| `BOOL_OR(cond)`          | Booléens     | Vrai si au moins une ligne satisfait cond     |

---

## Erreurs courantes à éviter

| Erreur                                          | Cause                                                     | Solution                                  |
|-------------------------------------------------|-----------------------------------------------------------|-------------------------------------------|
| Colonne dans SELECT absente du GROUP BY         | Violation de la règle GROUP BY                            | Ajouter la colonne dans GROUP BY          |
| Utiliser `WHERE AVG(prix) > 16`                 | WHERE ne peut pas utiliser les agrégations                | Utiliser `HAVING AVG(prix) > 16`          |
| `COUNT(col)` au lieu de `COUNT(*)`              | `COUNT(col)` ignore les NULL — résultat différent        | Choisir selon le besoin                   |
| Confondre `UNION` et `UNION ALL`                | `UNION` dédoublonne (plus lent), `UNION ALL` conserve tout | Utiliser `UNION ALL` par défaut          |

---

## Pour aller plus loin

- **Leçon 1-4** — Jointures : relier `livres` et `auteurs` pour afficher les noms au lieu des IDs
- **Leçon 1-5** — Sous-requêtes et CTEs : réécrire les requêtes imbriquées de façon lisible
- **Leçon 1-6** — Fonctions window : `RANK()`, `ROW_NUMBER()`, `SUM() OVER()` pour des agrégations sans GROUP BY
