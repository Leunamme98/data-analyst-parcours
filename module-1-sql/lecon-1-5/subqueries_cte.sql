-- ============================================================
-- LEÇON 1-5 — Sous-requêtes et CTEs
-- Base de données : librairiedb
-- Tables utilisées : livres, auteurs
-- ============================================================
-- Concepts : sous-requêtes dans WHERE, FROM, SELECT
--            CTE (Common Table Expression) avec WITH
--            CTEs chaînées
-- ============================================================


-- ============================================================
-- NIVEAU 1 — Sous-requêtes dans WHERE
-- La sous-requête s'exécute en premier et fournit une valeur
-- (ou une liste de valeurs) utilisée pour filtrer la requête principale
-- ============================================================

-- Livres dont le prix est supérieur au prix moyen global
-- La sous-requête retourne UNE valeur scalaire : la moyenne
-- Elle est recalculée une seule fois, puis comparée pour chaque ligne
SELECT titre
FROM livres
WHERE prix > (SELECT AVG(prix) FROM livres);


-- Auteurs qui ont écrit au moins un livre publié avant 1850
-- La sous-requête retourne UNE LISTE d'auteur_id
-- IN (...) filtre les auteurs dont l'id apparaît dans cette liste
-- DISTINCT évite les doublons (un auteur peut avoir plusieurs livres avant 1850)
SELECT DISTINCT a.prenom, a.nom
FROM auteurs a
WHERE a.id IN (
    SELECT auteur_id
    FROM livres
    WHERE date_publication < '1850-01-01'
);


-- Livres dont le stock est inférieur au stock moyen global
SELECT titre
FROM livres
WHERE stock < (SELECT AVG(stock) FROM livres);


-- ============================================================
-- NIVEAU 2 — Sous-requêtes dans FROM et SELECT
-- ============================================================

-- Titre, prix, prix moyen global et écart par livre
-- Sous-requête SCALAIRE dans SELECT : retourne une seule valeur,
-- répétée sur chaque ligne du résultat.
-- Attention : une sous-requête dans SELECT est recalculée à chaque ligne
-- (inefficace sur de grands datasets — préférer une CTE dans ce cas)
SELECT
    titre,
    prix,
    (SELECT ROUND(AVG(prix), 2) FROM livres) AS prix_moy_global,
    (prix - (SELECT ROUND(AVG(prix), 2) FROM livres)) AS ecart_prix
FROM livres;


-- Auteurs ayant plus de 8 livres dans la base
-- Sous-requête dans FROM : crée une table dérivée (nommée "t")
-- La requête externe joint ensuite cette table dérivée à la table auteurs
-- La table dérivée doit toujours avoir un alias (AS t)
SELECT a.prenom, a.nom, t.nbre_livre
FROM (
    SELECT auteur_id, COUNT(id) AS nbre_livre
    FROM livres
    GROUP BY auteur_id
    HAVING COUNT(id) > 8
) AS t
JOIN auteurs a ON t.auteur_id = a.id;


-- ============================================================
-- NIVEAU 3 — CTE (Common Table Expression) avec WITH
-- Une CTE est comme une vue temporaire, définie en début de requête.
-- Avantages : lisibilité, réutilisabilité dans la même requête,
-- pas de répétition de code.
-- ============================================================

-- Stock total par auteur, filtré sur ceux dépassant 250
-- La CTE "stock_auteur" calcule le stock total par auteur
-- La requête principale filtre ensuite ce résultat
WITH stock_auteur AS (
    SELECT a.prenom, a.nom, SUM(l.stock) AS stock_total
    FROM livres l
    INNER JOIN auteurs a ON a.id = l.auteur_id
    GROUP BY a.prenom, a.nom
)
SELECT *
FROM stock_auteur
WHERE stock_total > 250;


-- Auteur le plus prolifique (le plus de livres) — CTEs chaînées
-- CTE 1 "stock_auteur" : compte les livres par auteur
-- CTE 2 "top_auteurs" : trie par nombre décroissant
-- Requête finale : prend uniquement le premier résultat
WITH
    stock_auteur AS (
        SELECT a.prenom, a.nom, COUNT(l.id) AS nbre_livre
        FROM livres l
        INNER JOIN auteurs a ON a.id = l.auteur_id
        GROUP BY a.prenom, a.nom
    ),
    top_auteurs AS (
        SELECT nom, nbre_livre
        FROM stock_auteur
        ORDER BY nbre_livre DESC
    )
SELECT *
FROM top_auteurs
LIMIT 1;

-- NOTE : avec ORDER BY dans une CTE, le comportement peut varier selon
-- le moteur SQL. L'approche la plus robuste est d'appliquer ORDER BY
-- dans la requête finale, pas dans la CTE.


-- Prix moyen par auteur, jointure avec la table auteurs, tri décroissant
-- La CTE "prix_auteur" calcule le prix moyen sans le nom (juste auteur_id)
-- La requête principale joint avec auteurs pour récupérer prénom et nom
WITH prix_auteur AS (
    SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moy
    FROM livres
    GROUP BY auteur_id
)
SELECT a.prenom, a.nom, p.prix_moy
FROM auteurs a
INNER JOIN prix_auteur p ON a.id = p.auteur_id
ORDER BY p.prix_moy DESC;
