# Leçon 1-4 — Jointures : relier plusieurs tables

## Objectifs pédagogiques

- Comprendre pourquoi les jointures existent et quand les utiliser
- Maîtriser `INNER JOIN` : lignes communes aux deux tables
- Maîtriser `LEFT JOIN` : toutes les lignes de gauche + correspondances
- Connaître `RIGHT JOIN`, `FULL JOIN` et `CROSS JOIN`
- Combiner jointures avec `WHERE`, `GROUP BY`, `HAVING`, `CASE WHEN`
- Utiliser les alias de table pour des requêtes lisibles

---

## Concept — Pourquoi joindre des tables ?

Dans une base relationnelle, les données sont **séparées en tables** pour éviter la duplication. La table `livres` ne contient pas le nom de l'auteur en toutes lettres — elle contient seulement son `auteur_id`. La jointure permet de **reconstituer l'information complète** au moment de la requête.

```
livres                          auteurs
─────────────────────────       ──────────────────────────
id | titre           | auteur_id    id | prenom  | nom
───┼─────────────────┼──────────    ───┼─────────┼──────────
1  | Les Misérables  |  1      ──►  1  | Victor  | Hugo
2  | Hamlet          |  2      ──►  2  | William | Shakespeare
3  | L'Étranger      |  4      ──►  4  | Albert  | Camus
```

Sans jointure, on verrait `auteur_id = 1`. Avec jointure, on voit `Victor Hugo`.

---

## Schéma utilisé dans cette leçon

```
auteurs (id, prenom, nom, nationalite, date_naissance)
    │
    │  auteurs.id ←── livres.auteur_id
    │
livres  (id, titre, prix, date_publication, stock, auteur_id)
```

La jointure se fait toujours sur : `livres.auteur_id = auteurs.id`

---

## Les alias de table

Un alias est un nom court donné à une table pour simplifier l'écriture. On les déclare juste après le nom de la table.

```sql
FROM livres l        -- l est l'alias de livres
INNER JOIN auteurs a -- a est l'alias de auteurs
```

On peut ensuite écrire `l.titre` au lieu de `livres.titre` et `a.nom` au lieu de `auteurs.nom`. C'est obligatoire quand deux tables ont une colonne du même nom (ex : les deux ont `id`).

```sql
-- Sans alias : ambigu
SELECT id, titre FROM livres INNER JOIN auteurs ON ...
--     ↑ quel id ? livres.id ou auteurs.id ?

-- Avec alias : clair
SELECT l.id, l.titre, a.nom FROM livres l INNER JOIN auteurs a ON l.auteur_id = a.id
```

---

## INNER JOIN — Lignes communes aux deux tables

`INNER JOIN` retourne uniquement les lignes qui ont **une correspondance dans les deux tables**.

```
Table A      Table B         INNER JOIN
────────     ────────        ──────────
  1  ───────►  1    ──────►    1
  2  ───────►  2    ──────►    2
  3            ✗              (exclu)
  ✗            4              (exclu)
```

**Diagramme de Venn :**
```
    ┌────┬────┐
    │    │▓▓▓▓│
    │  A │▓▓▓▓│ B
    │    │▓▓▓▓│
    └────┴────┘
         ↑ seule la partie commune est retournée
```

### Syntaxe

```sql
SELECT colonnes
FROM table_gauche alias_g
INNER JOIN table_droite alias_d ON alias_g.cle = alias_d.cle;
```

### Exemples

```sql
-- Titre et auteur de chaque livre
SELECT l.titre, a.prenom, a.nom
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

```sql
-- Titre, prix et nationalité de l'auteur
SELECT l.titre, l.prix, a.nationalite
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

```sql
-- Livres d'auteurs français uniquement
-- WHERE filtre APRÈS la jointure, sur le résultat combiné
SELECT l.titre
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id
WHERE a.nationalite = 'Française';
```

---

## LEFT JOIN — Toutes les lignes de gauche

`LEFT JOIN` retourne **toutes les lignes de la table de gauche** (celle après `FROM`), et les colonnes de droite quand il y a une correspondance — `NULL` sinon.

```
Table A      Table B         LEFT JOIN
────────     ────────        ──────────
  1  ───────►  1    ──────►    1  | données B
  2  ───────►  2    ──────►    2  | données B
  3            ✗    ──────►    3  | NULL
```

**Diagramme de Venn :**
```
    ┌────┬────┐
    │▓▓▓▓│▓▓▓▓│
    │▓▓▓▓│▓▓▓▓│ B
    │▓▓▓▓│▓▓▓▓│
    └────┴────┘
     ↑ toute la table A est conservée
```

### Quand utiliser LEFT JOIN ?

- Voir **tous les enregistrements d'une table**, même sans correspondance dans l'autre
- Détecter les **enregistrements orphelins** (ex : auteurs sans livres)
- Faire des statistiques incluant les **valeurs zéro** (pas seulement les non-vides)

### Exemples

```sql
-- Tous les auteurs avec leur nombre de livres (0 si aucun)
-- Avec INNER JOIN, un auteur sans livre serait exclu
SELECT a.prenom, a.nom, COUNT(l.id) AS nbre_livres
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.prenom, a.nom;
```

> `COUNT(l.id)` compte les `id` non-NULL côté livres. Pour un auteur sans livre, `l.id` sera `NULL` → `COUNT = 0`.  
> Ne pas utiliser `COUNT(*)` ici — il retournerait 1 au lieu de 0.

```sql
-- Auteurs dont aucun livre n'a un stock supérieur à 50
SELECT a.prenom, a.nom
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.prenom, a.nom
HAVING MAX(l.stock) <= 50;
```

---

## Les autres types de jointures

### RIGHT JOIN

Symétrique du `LEFT JOIN` : retourne **toutes les lignes de la table de droite**, avec `NULL` pour les colonnes de gauche sans correspondance.

```sql
-- Tous les livres avec leurs auteurs, même si l'auteur_id est NULL
SELECT l.titre, a.nom
FROM auteurs a
RIGHT JOIN livres l ON l.auteur_id = a.id;
```

> En pratique, on préfère réécrire un `RIGHT JOIN` en `LEFT JOIN` en inversant l'ordre des tables — c'est plus lisible.

---

### FULL OUTER JOIN

Retourne **toutes les lignes des deux tables**, avec `NULL` là où il n'y a pas de correspondance.

```
Table A      Table B         FULL OUTER JOIN
────────     ────────        ──────────────────
  1  ───────►  1    ──────►    1  | données B
  2  ───────►  2    ──────►    2  | données B
  3            ✗    ──────►    3  | NULL
  ✗            4    ──────►  NULL | données B
```

```sql
SELECT l.titre, a.nom
FROM livres l
FULL OUTER JOIN auteurs a ON l.auteur_id = a.id;
```

---

### CROSS JOIN

Produit **cartésien** : chaque ligne de A est combinée avec chaque ligne de B. Si A a 5 lignes et B a 10 lignes → 50 lignes résultantes. Rarement utilisé dans un contexte analytique.

```sql
-- Toutes les combinaisons possibles auteur × livre (même sans lien)
SELECT a.nom, l.titre
FROM auteurs a
CROSS JOIN livres l;
-- Retourne 5 × 50 = 250 lignes
```

---

### SELF JOIN

Une table jointe à **elle-même**. Utile pour des hiérarchies (manager/employé) ou des comparaisons intra-table. Les deux alias sont obligatoires.

```sql
-- Exemple conceptuel : comparer des livres du même auteur
SELECT l1.titre AS livre1, l2.titre AS livre2, l1.auteur_id
FROM livres l1
INNER JOIN livres l2 ON l1.auteur_id = l2.auteur_id
WHERE l1.id < l2.id;  -- évite les doublons (A,B) et (B,A)
```

---

## Tableau récapitulatif des jointures

| Type           | Lignes retournées                                           | Cas d'usage typique                          |
|----------------|--------------------------------------------------------------|----------------------------------------------|
| `INNER JOIN`   | Seulement les lignes avec correspondance dans les deux tables | La grande majorité des analyses             |
| `LEFT JOIN`    | Toutes les lignes de gauche + correspondances de droite (NULL si absent) | Inclure les "zéros", détecter les orphelins |
| `RIGHT JOIN`   | Toutes les lignes de droite + correspondances de gauche (NULL si absent) | Rarement utilisé (préférer LEFT JOIN inversé) |
| `FULL OUTER JOIN` | Toutes les lignes des deux tables (NULL si pas de correspondance) | Réconciliation de données entre deux sources |
| `CROSS JOIN`   | Produit cartésien (toutes les combinaisons possibles)        | Génération de combinaisons                  |
| `SELF JOIN`    | Jointure d'une table sur elle-même                           | Hiérarchies, comparaisons intra-table       |

---

## Combinaisons avancées

### JOIN + CASE WHEN

```sql
-- Disponibilité calculée dans la même requête
SELECT
    l.titre,
    a.prenom,
    a.nom,
    CASE
        WHEN l.stock > 0 THEN 'En stock'
        ELSE 'Rupture'
    END AS disponibilite
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

### JOIN + agrégations multiples

```sql
-- Bilan complet par auteur (livres, prix moyen, stock total)
SELECT
    a.nom,
    a.prenom,
    COUNT(l.id)           AS nbre_livres,
    ROUND(AVG(l.prix), 2) AS prix_moyen,
    SUM(l.stock)          AS total_stock
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.nom, a.prenom
ORDER BY SUM(l.stock) DESC;
```

### JOIN + TOP N

```sql
-- Top 3 des auteurs avec le prix moyen le plus élevé
SELECT
    a.prenom,
    a.nom,
    ROUND(AVG(l.prix), 2) AS prix_moyen
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.nom, a.prenom
ORDER BY AVG(l.prix) DESC
LIMIT 3;
```

---

## Ordre d'exécution avec JOIN

```
1. FROM + JOIN   → constitue la table combinée
2. WHERE         → filtre les lignes
3. GROUP BY      → forme les groupes
4. Agrégations   → calcule COUNT, SUM, AVG…
5. HAVING        → filtre les groupes
6. SELECT        → sélectionne les colonnes
7. ORDER BY      → trie
8. LIMIT         → coupe
```

---

## Erreurs courantes à éviter

| Erreur | Cause | Solution |
|--------|-------|----------|
| `column "id" is ambiguous` | Deux tables ont une colonne `id` sans préfixe | Préfixer : `l.id`, `a.id` |
| `INNER JOIN` au lieu de `LEFT JOIN` | On perd les lignes sans correspondance | Utiliser `LEFT JOIN` si on veut garder les "zéros" |
| `COUNT(*)` pour compter les enfants en `LEFT JOIN` | Retourne 1 même quand il n'y a pas de correspondance | Utiliser `COUNT(l.id)` |
| Oublier le `ON` | La jointure devient un produit cartésien implicite | Toujours spécifier la condition `ON` |
| `WHERE` sur une colonne NULL issue d'un `LEFT JOIN` | `WHERE l.titre = 'X'` exclut les NULL, annulant l'effet du LEFT JOIN | Utiliser `IS NULL` ou déplacer la condition dans le `ON` |

---

## Pour aller plus loin

- **Leçon 1-5** — Sous-requêtes et CTEs : réécrire des jointures complexes de façon plus lisible
- **Leçon 1-6** — Fonctions window : `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` par groupe
