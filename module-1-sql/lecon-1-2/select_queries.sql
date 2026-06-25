-- ============================================================
-- LEÇON 1-2 — SELECT : Interroger et filtrer des données
-- Base de données : librairiedb
-- Tables utilisées : livres, clients
-- ============================================================


-- ============================================================
-- NIVEAU 1 — Sélections simples
-- ============================================================

-- Affiche le titre et le prix de tous les livres
-- SELECT col1, col2 : on choisit uniquement les colonnes utiles (pas SELECT *)
SELECT titre, prix
FROM livres;


-- Affiche les prénoms et noms de tous les clients, triés par nom alphabétiquement
-- ORDER BY col ASC : tri croissant (A → Z). DESC serait décroissant (Z → A).
SELECT prenom, nom
FROM clients
ORDER BY nom ASC;


-- Affiche les 5 livres les plus chers
-- ORDER BY prix DESC : on trie du plus cher au moins cher
-- LIMIT 5 : on ne garde que les 5 premières lignes du résultat
SELECT titre, prix
FROM livres
ORDER BY prix DESC
LIMIT 5;


-- ============================================================
-- NIVEAU 2 — Filtres avec WHERE
-- ============================================================

-- Affiche tous les livres dont le prix est supérieur à 20€
-- WHERE filtre les lignes avant de les retourner
SELECT titre, prix
FROM livres
WHERE prix > 20;


-- Affiche tous les clients habitant à Dakar
-- UPPER() convertit la valeur en majuscules pour une comparaison insensible à la casse
-- (évite de rater 'dakar', 'Dakar', 'DAKAR')
SELECT prenom, nom, ville
FROM clients
WHERE UPPER(ville) = 'DAKAR';


-- Affiche tous les livres publiés avant l'année 1900
-- EXTRACT(YEAR FROM col) extrait uniquement l'année d'une colonne de type DATE/TIMESTAMP
SELECT titre, date_publication
FROM livres
WHERE EXTRACT(YEAR FROM date_publication) < 1900;

-- REMARQUE — EXTRACT vs comparaison directe de date :
-- La requête ci-dessus fonctionne, mais appliquer une fonction sur une colonne
-- (EXTRACT, UPPER, etc.) empêche PostgreSQL d'utiliser les index sur cette colonne.
-- Sur un grand dataset, préférer la comparaison directe, plus performante :
--
--   WHERE date_publication < '1900-01-01'
--
-- À retenir : réserver les fonctions sur colonnes aux cas où elles sont vraiment nécessaires.


-- Affiche tous les livres dont le titre contient le mot 'et'
-- LIKE avec % : le % remplace n'importe quelle suite de caractères
-- UPPER() + '%ET%' : rend la recherche insensible à la casse
SELECT titre
FROM livres
WHERE UPPER(titre) LIKE '%ET%';

-- REMARQUE — LIKE '%ET%' capte large :
-- Le motif '%ET%' va capturer tout titre contenant 'ET' n'importe où,
-- y compris des mots comme "Juliette", "Malentendu", "Nuit", "Sonate"...
-- C'est un comportement à connaître, pas une erreur ici.
-- Dans un cas réel, pour cibler le mot "et" isolé, on affinerait avec :
--
--   WHERE LOWER(titre) LIKE '% et %'
--
-- Cela exige un espace avant et après, limitant les faux positifs.


-- ============================================================
-- NIVEAU 3 — Combinaisons de clauses
-- ============================================================

-- Affiche les livres avec un stock entre 20 et 40, triés par stock décroissant
-- BETWEEN x AND y : équivalent à col >= x AND col <= y (bornes incluses)
SELECT titre, stock
FROM livres
WHERE stock BETWEEN 20 AND 40
ORDER BY stock DESC;


-- Affiche les villes distinctes où habitent les clients
-- DISTINCT élimine les doublons dans le résultat
SELECT DISTINCT ville
FROM clients;


-- Affiche les 3 livres les moins chers dont le stock est supérieur à 30
-- WHERE s'applique avant ORDER BY et LIMIT :
--   1. Filtre les livres avec stock > 30
--   2. Trie par prix croissant
--   3. Garde les 3 premiers
SELECT titre, prix, stock
FROM livres
WHERE stock > 30
ORDER BY prix ASC
LIMIT 3;
