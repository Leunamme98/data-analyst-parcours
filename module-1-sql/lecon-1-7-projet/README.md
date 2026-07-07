# Projet Module 1 — Analyse complète d'une librairie avec SQL

## Contexte du projet

Ce projet clôture le **Module 1 — SQL** du parcours Data Analyst. Il s'appuie sur la base de données `librairiedb` construite en leçon 1-1 et mobilise l'ensemble des techniques SQL vues tout au long du module : SELECT, filtres, agrégations, jointures, sous-requêtes, CTEs et fonctions window.

L'objectif est de simuler une **analyse réelle de données** : à partir d'un catalogue de 50 livres répartis entre 5 auteurs classiques, répondre à des questions métier concrètes organisées en 4 axes analytiques.

**Base de données :** `librairiedb`  
**Tables utilisées :** `livres`, `auteurs`  
**Fichiers SQL :**
- `analyse_catalogue.sql` — Axe 1 (requêtes 1 à 5)
- `analyse_auteurs.sql` — Axe 2 (requêtes 6 à 10)
- `analyse_temporelle.sql` — Axe 3 (requêtes 11 à 15)
- `analyse_classements.sql` — Axe 4 (requêtes 16 à 20)

---

## Les 4 axes analysés

### Axe 1 — Analyse du catalogue
*Techniques : SELECT, JOIN, WHERE, GROUP BY, CASE WHEN, CTE, Window Functions*

| # | Question |
|---|----------|
| 1 | Nombre de livres disponibles par nationalité d'auteur |
| 2 | Top 5 des livres avec le meilleur rapport qualité-stock (score = stock / prix) |
| 3 | Répartition du catalogue par tranche de prix : économique / standard / premium |
| 4 | Pourcentage du catalogue représenté par chaque auteur |
| 5 | Livres avec stock inférieur à la moyenne ET prix supérieur à la moyenne |

### Axe 2 — Performance des auteurs
*Techniques : JOIN, GROUP BY, HAVING, Window Functions (FIRST_VALUE, LAST_VALUE, RANK, ROW_NUMBER)*

| # | Question |
|---|----------|
| 6  | Auteur générant la plus grande valeur stock (stock × prix) |
| 7  | Auteurs avec une gamme de prix étendue (écart > 10€ entre le moins cher et le plus cher) |
| 8  | Top 3 des auteurs par prix moyen avec leur nationalité |
| 9  | Auteurs avec plus de 5 livres dont le stock dépasse 30 unités |
| 10 | Pour chaque nationalité, l'auteur avec le plus de livres (RANK par partition) |

### Axe 3 — Analyse temporelle
*Techniques : EXTRACT, DATE, SELF JOIN, CTE, Window Functions (AGE, moyenne mobile)*

| #  | Question |
|----|----------|
| 11 | Nombre de livres publiés par décennie |
| 12 | Auteur avec la carrière la plus longue (écart entre première et dernière publication) |
| 13 | Livres post-1900 classés dans le top 10 global par stock |
| 14 | Corrélation ancienneté / prix — prix et moyenne mobile sur 5 livres consécutifs |
| 15 | Livres publiés la même année par le même auteur (SELF JOIN) |

### Axe 4 — Classements et comparaisons
*Techniques : Window Functions (DENSE_RANK, RANK, LAG, LEAD, FIRST_VALUE, SUM cumulatif), CTE*

| #  | Question |
|----|----------|
| 16 | Rang de chaque livre par prix dans le catalogue de son auteur (DENSE_RANK PARTITION BY) |
| 17 | Prix, prix moyen de l'auteur et écart en % pour chaque livre |
| 18 | Titre du livre suivant et précédent par ordre alphabétique (LAG + LEAD) |
| 19 | Stock cumulatif par auteur trié par date de publication |
| 20 | Livre le plus cher de chaque auteur, classés entre eux avec RANK() — via CTE + FIRST_VALUE |

---

## Insights marquants

### Insight 1 — Un catalogue parfaitement équilibré, mais c'est une exception

Chaque auteur représente exactement **20% du catalogue** (10 livres sur 50). Dans une vraie librairie, cette symétrie est rare — elle révèle une base de données construite pour l'apprentissage. En pratique, un tel équilibre serait un signal à investiguer : est-il volontaire (politique d'achat) ou artificiel ?

### Insight 2 — Camus génère la plus grande valeur stock malgré des prix modérés

Albert Camus affiche la **valeur stock totale la plus élevée** (stock × prix), non pas grâce à des prix élevés (son prix moyen est le plus bas : ~15.34€), mais grâce à des **stocks massifs** : L'Étranger à 100 unités, La Peste à 80 unités. C'est un exemple classique de stratégie volume : compenser les marges faibles par la rotation.

### Insight 3 — Tolstoï domine les prix et la variabilité

Léon Tolstoï affiche le **prix moyen le plus élevé** (~17.05€) avec un écart de **18€** entre son livre le moins cher (*Père Serge*, 13€) et le plus cher (*Guerre et Paix*, 29.90€) — la gamme la plus étendue de tous les auteurs. Ce catalogue hétérogène reflète la diversité réelle des formats : romans courts vs fresques historiques.

### Insight 4 — Victor Hugo a la carrière éditée la plus longue

Hugo publie de *Cromwell* (1827) à *Quatrevingt-treize* (1874), soit **47 ans de production** dans la base. Shakespeare, au contraire, concentre ses publications sur ~20 ans (1593-1611). Cette différence temporelle impacte directement les analyses de corrélation ancienneté/prix.

### Insight 5 — Les livres les plus chers sont aussi les moins disponibles

La requête "stock < moyenne globale ET prix > moyenne globale" identifie une tension structurelle : les **livres à prix élevé ont tendance à être moins bien stockés**. Ce pattern suggère soit une décision commerciale (limiter l'exposition aux produits à forte valeur), soit une demande plus faible sur les œuvres premium.

---

## Techniques SQL utilisées

| Technique | Requêtes | Description |
|-----------|----------|-------------|
| `SELECT`, `WHERE`, `ORDER BY`, `LIMIT` | 2, 5, 13 | Filtres et sélections de base |
| `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG` | 1, 3, 9, 11 | Agrégations par groupe |
| `CASE WHEN` | 3 | Segmentation en catégories de prix |
| `INNER JOIN` | 1, 6, 7, 8, 10, 12, 15, 16, 19, 20 | Jointure livres ↔ auteurs |
| `SELF JOIN` | 15 | Comparer des lignes de la même table |
| `CTE (WITH)` | 5, 7, 13, 20 | Décomposition des requêtes complexes |
| `EXTRACT`, `AGE` | 11, 12, 14, 15 | Manipulation de dates |
| `CONCAT` | 6, 7, 8, 10, 12, 16, 19, 20 | Concaténation de chaînes |
| `ROUND`, `ABS` | 17 | Mise en forme numérique |
| `ROW_NUMBER()` | 8, 10 | Numérotation séquentielle |
| `RANK()` | 10, 20 | Classement avec ex-æquo |
| `DENSE_RANK()` | 16 | Classement sans saut de rang |
| `AVG() OVER(PARTITION BY)` | 4, 17 | Prix moyen par groupe sur chaque ligne |
| `SUM() OVER(PARTITION BY)` | 5 | Stock total par auteur sur chaque ligne |
| `SUM() OVER(ORDER BY)` | 19 | Stock cumulatif par date |
| `AVG() OVER(ORDER BY ROWS BETWEEN)` | 14 | Moyenne mobile sur 5 livres |
| `FIRST_VALUE()` / `LAST_VALUE()` | 7, 20 | Premier / dernier élément d'une partition |
| `LAG()` / `LEAD()` | 18 | Valeur ligne précédente / suivante |
| Casting `::NUMERIC`, `::DATE`, `::INT` | 4, 11, 13 | Conversion de types |

---

## Structure des fichiers

```
lecon-1-7-projet/
├── analyse_catalogue.sql    # Axe 1 — requêtes 1 à 5
├── analyse_auteurs.sql      # Axe 2 — requêtes 6 à 10
├── analyse_temporelle.sql   # Axe 3 — requêtes 11 à 15
└── analyse_classements.sql  # Axe 4 — requêtes 16 à 20
```

---

## Ce que ce projet démontre

Ce projet couvre l'ensemble du spectre SQL d'un Data Analyst junior à intermédiaire :

- **Exploration** : filtres, tris, agrégations simples
- **Croisement de données** : jointures, GROUP BY multi-colonnes, HAVING
- **Requêtes avancées** : CTEs chaînées, sous-requêtes dans FROM et SELECT
- **Analyse comparative** : fonctions window avec PARTITION BY, cumuls, LAG/LEAD
- **Raisonnement analytique** : traduction de questions métier en SQL

Il constitue la base du **Projet 1 du Module 4** (analyse complète des ventes d'une librairie), qui reprendra cette structure avec des données réelles et un pipeline Python + Power BI.
