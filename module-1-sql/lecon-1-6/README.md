# Leçon 1-6 — Fonctions window (fonctions de fenêtre)

## Objectifs pédagogiques

- Comprendre ce qu'est une fonction window et en quoi elle diffère de GROUP BY
- Maîtriser `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` pour les classements
- Utiliser `SUM()`, `AVG()`, `MIN()`, `MAX()` sur une fenêtre glissante
- Naviguer entre les lignes avec `LAG()` et `LEAD()`
- Extraire la première et dernière valeur d'un groupe avec `FIRST_VALUE()` / `LAST_VALUE()`
- Calculer des cumuls et des moyennes mobiles

---

## Concept — Qu'est-ce qu'une fonction window ?

Une **fonction window** (ou fonction de fenêtre) calcule une valeur **pour chaque ligne**, en se basant sur un ensemble de lignes voisines défini par une **fenêtre**. Contrairement à `GROUP BY`, elle **ne réduit pas le nombre de lignes** — chaque ligne du résultat est conservée, enrichie d'une colonne calculée.

```
Avec GROUP BY :           Avec Window Function :
─────────────────         ──────────────────────────────────────
auteur | avg_prix         titre         | auteur  | prix | avg_prix_auteur
───────┼─────────         ──────────────┼─────────┼──────┼────────────────
Hugo   | 16.49            Les Misérables| Hugo    | 25.90| 16.49
Camus  | 15.34            L'Étranger    | Camus   | 14.90| 15.34
...                       La Peste      | Camus   | 19.90| 15.34
                          Notre-Dame    | Hugo    | 18.50| 16.49
                          ...
```

GROUP BY : 5 lignes (une par auteur).  
Window Function : 50 lignes (une par livre), avec la moyenne de l'auteur sur chaque ligne.

---

## Syntaxe générale

```sql
fonction_window() OVER (
    [PARTITION BY colonne]  -- découpe en groupes (optionnel)
    [ORDER BY colonne]      -- trie dans chaque groupe (optionnel)
    [ROWS BETWEEN ...]      -- définit la fenêtre (optionnel)
)
```

- **`PARTITION BY`** : remet les compteurs à zéro pour chaque groupe (comme `GROUP BY`, mais sans réduire les lignes)
- **`ORDER BY`** : définit l'ordre dans lequel les lignes sont traitées à l'intérieur de chaque partition
- **`ROWS BETWEEN`** : délimite les lignes incluses dans le calcul (utile pour les cumuls et moyennes mobiles)

---

## 1 — Fonctions de classement

### ROW_NUMBER() — numérotation séquentielle

Attribue un numéro unique à chaque ligne. En cas d'ex-æquo, les numéros sont distincts (l'ordre entre égaux est non déterministe sans critère supplémentaire).

```sql
-- Classement de tous les livres par prix décroissant
SELECT titre, prix, ROW_NUMBER() OVER(ORDER BY prix DESC) AS rang
FROM livres;
```

### RANK() — classement avec saut en cas d'ex-æquo

Deux lignes à égalité reçoivent le même rang. Le rang suivant est sauté.

```
Prix : 25.90 → rang 1
Prix : 19.90 → rang 2
Prix : 19.90 → rang 2   (ex-æquo)
Prix : 18.50 → rang 4   (le rang 3 est sauté)
```

```sql
-- Classement de chaque livre par prix, par auteur
SELECT a.prenom, a.nom, l.titre, l.prix,
    RANK() OVER(PARTITION BY l.auteur_id ORDER BY l.prix DESC) AS rang
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

### DENSE_RANK() — classement sans saut

Identique à `RANK()`, mais le rang suivant un ex-æquo n'est pas sauté.

```
Prix : 25.90 → rang 1
Prix : 19.90 → rang 2
Prix : 19.90 → rang 2   (ex-æquo)
Prix : 18.50 → rang 3   (pas de saut)
```

```sql
SELECT titre, stock, DENSE_RANK() OVER(ORDER BY stock DESC) AS rang
FROM livres;
```

### Comparatif ROW_NUMBER vs RANK vs DENSE_RANK

| Valeur | ROW_NUMBER | RANK | DENSE_RANK |
|--------|-----------|------|------------|
| 100    | 1         | 1    | 1          |
| 90     | 2         | 2    | 2          |
| 90     | 3         | 2    | 2          |
| 80     | 4         | 4    | 3          |
| 70     | 5         | 5    | 4          |

---

## 2 — Agrégations sur fenêtre

Les fonctions d'agrégation classiques (`SUM`, `AVG`, `MIN`, `MAX`, `COUNT`) peuvent être utilisées comme fonctions window avec `OVER()`.

```sql
-- Prix de chaque livre + prix moyen de son auteur sur la même ligne
SELECT
    l.titre, l.prix,
    CONCAT(a.prenom, ' ', a.nom) AS auteur,
    ROUND(AVG(l.prix) OVER(PARTITION BY a.id), 2) AS prix_moy_auteur
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

```sql
-- Stock de chaque livre + stock total de son auteur
SELECT
    l.titre, l.stock,
    CONCAT(a.prenom, ' ', a.nom) AS auteur,
    SUM(l.stock) OVER(PARTITION BY a.id) AS stock_total_auteur
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

```sql
-- Prix du livre le moins cher du même auteur sur chaque ligne
SELECT
    l.titre, l.prix,
    CONCAT(a.prenom, ' ', a.nom) AS auteur,
    FIRST_VALUE(l.prix) OVER(PARTITION BY a.id ORDER BY l.prix ASC) AS prix_min_auteur
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;
```

---

## 3 — FIRST_VALUE() et LAST_VALUE()

`FIRST_VALUE()` retourne la valeur de la première ligne de la fenêtre. `LAST_VALUE()` retourne la valeur de la dernière ligne.

```sql
-- Premier et dernier livre de chaque auteur, affiché sur chaque ligne
SELECT
    CONCAT(a.prenom, ' ', a.nom) AS auteur,
    l.titre, l.prix,
    MIN(l.prix) OVER(PARTITION BY a.id) AS prix_min,
    MAX(l.prix) OVER(PARTITION BY a.id) AS prix_max
FROM auteurs a
INNER JOIN livres l ON a.id = l.auteur_id;
```

> **Attention avec LAST_VALUE() :** par défaut, la fenêtre va du début de la partition jusqu'à la ligne courante (`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`). Pour obtenir la vraie dernière valeur, il faut spécifier :
>
> ```sql
> LAST_VALUE(prix) OVER(
>     PARTITION BY auteur_id
>     ORDER BY prix
>     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
> )
> ```

---

## 4 — LAG() et LEAD() — naviguer entre les lignes

`LAG()` accède à la valeur de la ligne **précédente**. `LEAD()` accède à la ligne **suivante**.

```sql
LAG(colonne, décalage, valeur_défaut)  OVER(ORDER BY ...)
LEAD(colonne, décalage, valeur_défaut) OVER(ORDER BY ...)
```

- `décalage` : nombre de lignes de décalage (défaut : 1)
- `valeur_défaut` : retourné si la ligne précédente/suivante n'existe pas (défaut : NULL)

```sql
-- Chaque livre avec son prix et le prix du livre précédent (par prix croissant)
SELECT
    titre, prix,
    LAG(titre) OVER(ORDER BY prix ASC) AS titre_precedent,
    LAG(prix)  OVER(ORDER BY prix ASC) AS prix_precedent
FROM livres;
```

```sql
-- Chaque livre avec le titre du livre suivant et précédent (ordre alphabétique)
SELECT
    titre,
    LEAD(titre) OVER(ORDER BY titre ASC) AS livre_suivant,
    LAG(titre)  OVER(ORDER BY titre ASC) AS livre_precedent
FROM livres;
```

---

## 5 — Cumuls et moyennes mobiles avec ROWS BETWEEN

La clause `ROWS BETWEEN` délimite la **fenêtre glissante** autour de chaque ligne.

| Expression                               | Signification                                     |
|------------------------------------------|---------------------------------------------------|
| `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` | Du début de la partition jusqu'à la ligne courante (cumul) |
| `ROWS BETWEEN 4 PRECEDING AND CURRENT ROW` | Les 4 lignes précédentes + la ligne courante (moyenne mobile sur 5) |
| `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` | Toute la partition |
| `ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING` | La ligne précédente, courante et suivante |

```sql
-- Stock cumulatif des livres, triés par date de publication
SELECT
    titre, date_publication, stock,
    SUM(stock) OVER(ORDER BY date_publication ASC) AS stock_cumule
FROM livres;
```

```sql
-- Moyenne mobile des prix sur 5 livres consécutifs (par date de publication)
SELECT
    titre, prix,
    EXTRACT(YEAR FROM date_publication) AS annee,
    ROUND(AVG(prix) OVER(
        ORDER BY date_publication
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 2) AS moy_mobile_5
FROM livres
ORDER BY date_publication ASC;
```

---

## Récapitulatif de toutes les fonctions window

### Classement

| Fonction       | Description                                   | Ex-æquo      | Saut de rang |
|----------------|-----------------------------------------------|--------------|--------------|
| `ROW_NUMBER()` | Numéro unique pour chaque ligne               | Distingués   | Sans objet   |
| `RANK()`       | Classement avec ex-æquo                       | Même rang    | Oui          |
| `DENSE_RANK()` | Classement avec ex-æquo                       | Même rang    | Non          |
| `NTILE(n)`     | Répartit les lignes en n groupes égaux        | —            | —            |
| `PERCENT_RANK()` | Rang relatif en pourcentage (0 à 1)         | —            | —            |
| `CUME_DIST()`  | Distribution cumulative                       | —            | —            |

### Agrégation sur fenêtre

| Fonction               | Description                           |
|------------------------|---------------------------------------|
| `SUM() OVER()`         | Somme sur la fenêtre                  |
| `AVG() OVER()`         | Moyenne sur la fenêtre                |
| `MIN() OVER()`         | Minimum de la fenêtre                 |
| `MAX() OVER()`         | Maximum de la fenêtre                 |
| `COUNT() OVER()`       | Nombre de lignes de la fenêtre        |

### Navigation

| Fonction             | Description                                        |
|----------------------|----------------------------------------------------|
| `LAG(col, n)`        | Valeur de la ligne n positions avant               |
| `LEAD(col, n)`       | Valeur de la ligne n positions après               |
| `FIRST_VALUE(col)`   | Première valeur de la fenêtre                      |
| `LAST_VALUE(col)`    | Dernière valeur (attention au cadrage par défaut)  |
| `NTH_VALUE(col, n)`  | n-ième valeur de la fenêtre                        |

---

## Window Function vs GROUP BY — quand choisir quoi ?

| Besoin | Solution |
|--------|---------|
| Une ligne de résultat par groupe | `GROUP BY` |
| Conserver toutes les lignes ET ajouter une valeur agrégée par groupe | Window Function |
| Classer les lignes à l'intérieur d'un groupe | Window Function + `RANK()` / `DENSE_RANK()` |
| Comparer une ligne avec la ligne précédente ou suivante | Window Function + `LAG()` / `LEAD()` |
| Calculer un cumul ou une moyenne mobile | Window Function + `ROWS BETWEEN` |

---

## Pour aller plus loin

- **Projet 1-7** — Analyse complète de `librairiedb` : application de toutes ces techniques sur 20 questions métier réelles

---

## Exercices

> Le fichier `window_functions.sql` contient le corrigé. Essaie de résoudre les exercices par toi-même avant de le consulter.

### Exercice 1 — ROW_NUMBER (débutant)

Pour chaque auteur, numérote ses livres du moins cher au plus cher avec `ROW_NUMBER()`. Affiche le nom de l'auteur, le titre, le prix et le numéro.

---

### Exercice 2 — RANK vs DENSE_RANK (débutant)

Classe tous les livres par stock décroissant en utilisant les deux fonctions `RANK()` et `DENSE_RANK()` dans la même requête. Observe la différence en cas d'ex-æquo.

---

### Exercice 3 — AVG OVER PARTITION BY (intermédiaire)

Pour chaque livre, affiche son titre, son prix, le prix moyen de l'auteur et la différence entre son prix et ce prix moyen. Trie par différence décroissante (les livres les plus éloignés de la moyenne de leur auteur en premier).

---

### Exercice 4 — LAG + LEAD (intermédiaire)

Pour chaque livre trié par date de publication croissante, affiche le titre, la date de publication, le stock, et le stock du livre publié juste avant et juste après (même catalogue global, pas par auteur).

---

### Exercice 5 — Cumul + FIRST_VALUE (avancé)

Pour chaque auteur, affiche ses livres triés par prix croissant avec :
- Le stock cumulatif (dans l'ordre des prix)
- Le titre de son livre le moins cher (FIRST_VALUE)
- Le titre de son livre le plus cher (LAST_VALUE avec cadrage complet)
