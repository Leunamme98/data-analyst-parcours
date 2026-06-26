-- ============================================================
-- LEÇON 1-4 — Jointures : relier plusieurs tables
-- Base de données : librairiedb
-- Tables utilisées : livres (l), auteurs (a)
-- ============================================================
-- Jointures couvertes : INNER JOIN, LEFT JOIN
-- Combinaisons avec : WHERE, GROUP BY, HAVING, ORDER BY, CASE WHEN
-- ============================================================
--
-- Rappel du schéma :
--   auteurs (id, prenom, nom, nationalite, date_naissance)
--       ↑
--   livres  (id, titre, prix, date_publication, stock, auteur_id)
--
-- livres.auteur_id = auteurs.id  ← c'est sur cette clé qu'on joint
-- ============================================================


-- ============================================================
-- NIVEAU 1 — INNER JOIN
-- Retourne uniquement les lignes qui ont une correspondance
-- dans LES DEUX tables. Un livre sans auteur_id serait exclu.
-- ============================================================

-- Titre de chaque livre avec le prénom et nom de son auteur
-- l et a sont des alias : l pour livres, a pour auteurs
-- On préfixe chaque colonne (l.titre, a.prenom) pour lever toute ambiguïté
SELECT l.titre, a.prenom, a.nom
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;


-- Titre, prix et nationalité de l'auteur pour chaque livre
SELECT l.titre, l.prix, a.nationalite
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id;


-- Livres écrits par des auteurs de nationalité Française
-- WHERE s'applique APRÈS la jointure, sur le résultat combiné
SELECT l.titre
FROM livres l
INNER JOIN auteurs a ON l.auteur_id = a.id
WHERE a.nationalite = 'Française';


-- ============================================================
-- NIVEAU 2 — LEFT JOIN
-- Retourne TOUTES les lignes de la table de gauche (FROM),
-- et les colonnes de la table de droite quand il y a une
-- correspondance — NULL sinon.
-- Utile pour détecter des lignes "sans correspondance".
-- ============================================================

-- Tous les auteurs avec le nombre de livres dans la base
-- y compris les auteurs sans livre (COUNT retournerait 0)
-- Avec INNER JOIN, un auteur sans livre disparaîtrait du résultat
SELECT a.prenom, a.nom, COUNT(l.id) AS nbre_livres
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.prenom, a.nom;

-- NOTE : COUNT(l.id) compte les id non-NULL côté livres.
-- Pour un auteur sans livre, l.id sera NULL → COUNT = 0. ✓
-- COUNT(*) aurait retourné 1 au lieu de 0 dans ce cas.


-- Auteurs dont aucun livre n'a un stock supérieur à 50
-- LEFT JOIN + HAVING sur MAX(l.stock) : MAX de NULL = NULL,
-- donc un auteur sans livre vérifie aussi HAVING MAX(l.stock) <= 50
SELECT a.prenom, a.nom
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.prenom, a.nom
HAVING MAX(l.stock) <= 50;


-- ============================================================
-- NIVEAU 3 — Combinaisons avancées
-- JOIN + CASE WHEN, JOIN + agrégations multiples, TOP N
-- ============================================================

-- Titre, nom de l'auteur + colonne "disponibilite" calculée
-- CASE WHEN s'applique sur les colonnes du résultat jointé
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


-- Bilan par auteur : nombre de livres, prix moyen, stock total
-- Trié par stock total décroissant
-- LEFT JOIN pour inclure d'éventuels auteurs sans livres
SELECT
    a.nom,
    a.prenom,
    COUNT(l.id)          AS nbre_livres,
    ROUND(AVG(l.prix), 2) AS prix_moyen,
    SUM(l.stock)          AS total_stock
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.nom, a.prenom
ORDER BY SUM(l.stock) DESC;


-- Top 3 des auteurs avec le prix moyen le plus élevé
-- ORDER BY AVG(l.prix) DESC + LIMIT 3
SELECT
    a.prenom,
    a.nom,
    ROUND(AVG(l.prix), 2) AS prix_moyen
FROM auteurs a
LEFT JOIN livres l ON l.auteur_id = a.id
GROUP BY a.nom, a.prenom
ORDER BY AVG(l.prix) DESC
LIMIT 3;
