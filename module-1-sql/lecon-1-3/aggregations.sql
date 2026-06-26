-- ============================================================
-- LEÇON 1-3 — Agrégations : résumer et grouper des données
-- Base de données : librairiedb
-- Tables utilisées : livres, clients
-- ============================================================
-- Fonctions d'agrégation : COUNT, AVG, MAX, MIN, SUM, ROUND
-- Clauses : GROUP BY, HAVING, CASE WHEN
-- Opérateur : UNION ALL
-- ============================================================


-- ============================================================
-- NIVEAU 1 — Agrégations simples (sans GROUP BY)
-- Ces fonctions calculent un résultat sur TOUTES les lignes
-- ============================================================

-- Combien y a-t-il de livres au total dans la base ?
-- COUNT(*) compte toutes les lignes, incluant les NULL
SELECT COUNT(*) AS total_livres
FROM livres;


-- Quel est le prix moyen de tous les livres ?
-- AVG() calcule la moyenne de la colonne
-- ROUND(valeur, décimales) arrondit à 2 chiffres après la virgule
SELECT ROUND(AVG(prix), 2) AS prix_moyen
FROM livres;


-- Quel est le livre le plus cher et le moins cher ? (une seule requête)
-- MAX() retourne la valeur la plus grande, MIN() la plus petite
-- UNION ALL empile deux résultats en un seul tableau
-- Une sous-requête dans WHERE isole la ligne correspondant au max/min
SELECT 'Maximum' AS type, titre, prix
FROM livres
WHERE prix = (SELECT MAX(prix) FROM livres)

UNION ALL

SELECT 'Minimum' AS type, titre, prix
FROM livres
WHERE prix = (SELECT MIN(prix) FROM livres);

-- NOTE : on utilise UNION ALL (et non UNION) car on veut conserver
-- les doublons si deux livres ont exactement le même prix min ou max.


-- ============================================================
-- NIVEAU 2 — GROUP BY : agréger par groupe
-- GROUP BY divise les lignes en groupes et applique
-- la fonction d'agrégation sur chaque groupe séparément
-- ============================================================

-- Combien de livres a écrit chaque auteur ?
-- GROUP BY auteur_id : une ligne de résultat par auteur distinct
-- COUNT(id) compte les livres dans chaque groupe
SELECT auteur_id, COUNT(id) AS nbre_livres
FROM livres
GROUP BY auteur_id;


-- Quel est le prix moyen des livres par auteur ?
SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moyen
FROM livres
GROUP BY auteur_id;


-- Quel est le stock total disponible par auteur ?
-- SUM() additionne toutes les valeurs d'un groupe
SELECT auteur_id, SUM(stock) AS stock_total
FROM livres
GROUP BY auteur_id;


-- ============================================================
-- NIVEAU 3 — HAVING, sous-requêtes et CASE WHEN
-- HAVING filtre les groupes (là où WHERE filtre les lignes)
-- ============================================================

-- Quels auteurs ont un stock total supérieur à 200 unités ?
-- HAVING s'applique APRÈS GROUP BY, sur les groupes agrégés
-- (on ne peut pas utiliser WHERE ici car le stock total
-- n'existe pas encore avant le GROUP BY)
SELECT auteur_id, SUM(stock) AS stock_total
FROM livres
GROUP BY auteur_id
HAVING SUM(stock) > 200;


-- Quelle est la ville avec le plus de clients ?
-- Sous-requête imbriquée : on calcule d'abord le COUNT par ville,
-- puis on prend le MAX de ces comptes, puis on filtre dessus.
-- C'est un pattern courant pour "le groupe avec le maximum".
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


-- Affiche les auteurs dont le prix moyen est supérieur à 16€,
-- triés par prix moyen décroissant
-- On peut combiner HAVING et ORDER BY
SELECT auteur_id, ROUND(AVG(prix), 2) AS prix_moyen
FROM livres
GROUP BY auteur_id
HAVING AVG(prix) > 16
ORDER BY AVG(prix) DESC;


-- Combien de livres (avec prix > 15€) par tranche de stock ?
-- CASE WHEN crée une colonne calculée conditionnelle (comme un IF/ELSE)
-- On peut grouper sur une expression CASE WHEN
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

-- NOTE : le CASE WHEN doit être répété à l'identique dans GROUP BY.
-- PostgreSQL 9.1+ permet de grouper par alias (GROUP BY tranche_stock),
-- mais répéter l'expression est plus portable.
