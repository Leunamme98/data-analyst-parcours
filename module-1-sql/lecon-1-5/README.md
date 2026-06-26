# Leçon 1-5 — Sous-requêtes et CTEs

## Objectifs pédagogiques

- Écrire des sous-requêtes dans `WHERE`, `FROM` et `SELECT`
- Comprendre quand utiliser `IN`, `EXISTS`, une valeur scalaire
- Structurer des requêtes complexes avec les CTEs (`WITH`)
- Chaîner plusieurs CTEs pour décomposer un problème

---

## Concept — Pourquoi des sous-requêtes et des CTEs ?

Certaines questions ne peuvent pas être répondues en une seule lecture de la table. Par exemple :

> *"Affiche les livres dont le prix est supérieur à la moyenne."*

On a besoin de calculer la moyenne **d'abord**, puis de comparer chaque prix à cette valeur. C'est le rôle d'une **sous-requête** : une requête imbriquée dans une autre.

La **CTE** (Common Table Expression) fait la même chose, mais en nommant l'étape intermédiaire au début — ce qui rend la requête beaucoup plus lisible.

---

## 1 — Sous-requêtes dans WHERE

Une sous-requête dans `WHERE` calcule une valeur (ou une liste) qui sert de critère de filtre.

### Sous-requête scalaire (retourne une seule valeur)

```sql
-- Livres au-dessus du prix moyen
SELECT titre
FROM livres
WHERE prix > (SELECT AVG(prix) FROM livres);
```

La sous-requête `(SELECT AVG(prix) FROM livres)` est évaluée en premier, retourne un nombre (ex : 16.23), puis chaque ligne est comparée à ce nombre.

### Sous-requête avec IN (retourne une liste)

```sql
-- Auteurs ayant écrit au moins un livre avant 1850
SELECT DISTINCT a.prenom, a.nom
FROM auteurs a
WHERE a.id IN (
    SELECT auteur_id
    FROM livres
    WHERE date_publication < '1850-01-01'
);
```

`IN (...)` vérifie si la valeur de gauche appartient à la liste retournée par la sous-requête.

### Opérateurs disponibles avec les sous-requêtes

| Opérateur      | Utilisation                                              | La sous-requête retourne |
|----------------|----------------------------------------------------------|--------------------------|
| `= (sous-req)` | Égalité avec une valeur unique                          | Exactement 1 valeur      |
| `> (sous-req)` | Supérieur à une valeur unique                           | Exactement 1 valeur      |
| `IN (sous-req)`| La valeur appartient à la liste                         | N valeurs (1 colonne)    |
| `NOT IN`       | La valeur n'appartient pas à la liste                   | N valeurs (1 colonne)    |
| `EXISTS`       | Vrai si la sous-requête retourne au moins une ligne     | N lignes                 |
| `NOT EXISTS`   | Vrai si la sous-requête ne retourne aucune ligne        | N lignes                 |
| `= ANY`        | Égal à au moins une valeur de la liste                  | N valeurs (1 colonne)    |
| `= ALL`        | Égal à toutes les valeurs de la liste                   | N valeurs (1 colonne)    |

```sql
-- Livres sous le stock moyen
SELECT titre
FROM livres
WHERE stock < (SELECT AVG(stock) FROM livres);
```

---

## 2 — Sous-requêtes dans FROM (table dérivée)

Une sous-requête dans `FROM` crée une **table temporaire** (aussi appelée table dérivée). Elle doit obligatoirement avoir un alias.

```sql
-- Auteurs avec plus de 8 livres
SELECT a.prenom, a.nom, t.nbre_livre
FROM (
    SELECT auteur_id, COUNT(id) AS nbre_livre
    FROM livres
    GROUP BY auteur_id
    HAVING COUNT(id) > 8
) AS t                              -- ← alias obligatoire
JOIN auteurs a ON t.auteur_id = a.id;
```

**Comment lire cette requête :**
1. La sous-requête calcule le nombre de livres par auteur (uniquement ceux > 8)
2. Ce résultat intermédiaire est traité comme une table nommée `t`
3. On joint `t` avec `auteurs` pour récupérer les noms

---

## 3 — Sous-requêtes dans SELECT (scalaire)

Une sous-requête dans `SELECT` ajoute une valeur calculée à chaque ligne. Elle doit retourner **exactement une valeur**.

```sql
-- Chaque livre avec le prix moyen global et l'écart
SELECT
    titre,
    prix,
    (SELECT ROUND(AVG(prix), 2) FROM livres) AS prix_moy_global,
    (prix - (SELECT ROUND(AVG(prix), 2) FROM livres))  AS ecart_prix
FROM livres;
```

> **Attention aux performances :** une sous-requête dans `SELECT` est recalculée à chaque ligne. Sur un grand dataset, préférer une CTE qui calcule la valeur une seule fois.

---

## 4 — CTE : Common Table Expression

Une **CTE** (introduite par le mot-clé `WITH`) est une sous-requête nommée, définie avant la requête principale. Elle est plus lisible et peut être réutilisée.

### Syntaxe

```sql
WITH nom_cte AS (
    -- requête intermédiaire
    SELECT ...
)
SELECT *
FROM nom_cte
WHERE ...;
```

### CTE simple

```sql
-- Stock total par auteur, filtré sur > 250
WITH stock_auteur AS (
    SELECT a.prenom, a.nom, SUM(l.stock) AS stock_total
    FROM livres l
    INNER JOIN auteurs a ON a.id = l.auteur_id
    GROUP BY a.prenom, a.nom
)
SELECT *
FROM stock_auteur
WHERE stock_total > 250;
```

### CTEs chaînées (plusieurs WITH)

On peut définir plusieurs CTEs séparées par des virgules. Chaque CTE peut faire référence aux CTEs définies avant elle.

```sql
WITH
    -- Étape 1 : compter les livres par auteur
    comptage AS (
        SELECT a.prenom, a.nom, COUNT(l.id) AS nbre_livre
        FROM livres l
        INNER JOIN auteurs a ON a.id = l.auteur_id
        GROUP BY a.prenom, a.nom
    ),
    -- Étape 2 : trier par nombre décroissant
    classement AS (
        SELECT nom, nbre_livre
        FROM comptage
        ORDER BY nbre_livre DESC
    )
-- Étape 3 : garder seulement le premier
SELECT *
FROM classement
LIMIT 1;
```

### CTE + jointure sur la requête principale

```sql
-- Prix moyen par auteur, puis jointure pour afficher les noms
WITH prix_auteur AS (
    SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moy
    FROM livres
    GROUP BY auteur_id
)
SELECT a.prenom, a.nom, p.prix_moy
FROM auteurs a
INNER JOIN prix_auteur p ON a.id = p.auteur_id
ORDER BY p.prix_moy DESC;
```

---

## Sous-requête vs CTE — Quand choisir quoi ?

| Critère                      | Sous-requête                          | CTE                                      |
|------------------------------|---------------------------------------|------------------------------------------|
| Lisibilité                   | Difficile à lire si imbriquée         | Très lisible — chaque étape est nommée  |
| Réutilisation dans la requête| Impossible — doit être répétée        | Peut être référencée plusieurs fois      |
| Débogage                     | Difficile — tout est imbriqué         | Facile — on peut tester chaque bloc     |
| Performance                  | Similaire (optimiseur SQL)            | Similaire (la plupart du temps)          |
| Cas idéal                    | Filtre simple, une seule utilisation  | Logique en plusieurs étapes, réutilisation |

> **Règle pratique :** dès que la requête comporte plus d'une étape intermédiaire, utiliser une CTE.

---

## Ordre d'exécution avec sous-requêtes

```
Sous-requête dans WHERE :
  1. Exécution de la sous-requête → valeur ou liste
  2. FROM de la requête principale
  3. WHERE avec la valeur/liste obtenue
  4. SELECT → ORDER BY → LIMIT

Sous-requête dans FROM :
  1. Exécution de la sous-requête → table dérivée
  2. FROM principal + JOIN sur la table dérivée
  3. WHERE → SELECT → ORDER BY → LIMIT

CTE :
  1. Exécution de chaque CTE dans l'ordre de définition
  2. Requête principale (FROM → WHERE → SELECT → ORDER BY → LIMIT)
```

---

## Erreurs courantes

| Erreur | Cause | Solution |
|--------|-------|----------|
| Sous-requête scalaire retourne plusieurs lignes | `WHERE prix = (SELECT ...)` alors que la sous-requête retourne N lignes | Utiliser `IN` ou `= ANY` |
| Table dérivée sans alias | `FROM (SELECT ...) JOIN ...` → erreur de syntaxe | Toujours nommer la sous-requête : `AS nom` |
| CTE non terminée par virgule | `WITH a AS (...) b AS (...)` → erreur | Séparer les CTEs par une virgule |
| Référencer une CTE avant sa définition | CTE 2 fait référence à CTE 3 qui n'est pas encore définie | Définir les CTEs dans l'ordre de dépendance |

---

## Pour aller plus loin

- **Leçon 1-6** — Fonctions window : `RANK()`, `ROW_NUMBER()`, `SUM() OVER()` — pour des calculs cumulatifs et des classements sans `GROUP BY`

---

## Exercices

> Le fichier `subqueries_cte.sql` contient le corrigé. Essaie de résoudre les exercices par toi-même avant de le consulter.

### Exercice 1 — Sous-requête dans WHERE (débutant)

Affiche les titres des livres dont le prix est **supérieur au prix moyen des livres publiés après le 1er janvier 1900**.

*Indice : la sous-requête filtre d'abord les livres post-1900, puis calcule leur moyenne.*

---

### Exercice 2 — Sous-requête dans WHERE avec IN (débutant)

Affiche le prénom et le nom des auteurs qui ont **au moins un livre avec un stock supérieur à 60**.

---

### Exercice 3 — Sous-requête dans FROM (intermédiaire)

À partir d'une table dérivée qui calcule le **prix moyen par auteur**, affiche les auteurs dont le prix moyen est **supérieur à la moyenne globale** de tous les livres.

*Indice : calcule d'abord le prix moyen par auteur_id dans une sous-requête, puis filtre avec `WHERE prix_moy > (SELECT AVG(prix) FROM livres)`.*

---

### Exercice 4 — CTE simple (intermédiaire)

Avec une CTE nommée `bilan_auteur`, calcule pour chaque auteur son **nombre de livres** et son **stock total**. Ensuite, affiche uniquement les auteurs dont le stock total est **le plus élevé** (un seul résultat).

---

### Exercice 5 — CTEs chaînées (avancé)

Avec deux CTEs chaînées :
1. `prix_par_auteur` : calcule le prix moyen par auteur (avec son nom et prénom)
2. `classement` : récupère ces résultats triés par prix moyen décroissant

Affiche le **top 2** des auteurs avec le prix moyen le plus élevé, avec leur nom et leur prix moyen.
