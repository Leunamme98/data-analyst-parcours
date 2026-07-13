-- AXE 1 — Analyse du catalogue (SELECT, filtres, agrégations)

-- Combien de livres sont disponibles par nationalité d'auteur ?
SELECT a.nationalite,SUM(l.stock) AS stock_dispo, COUNT(l.titre) AS nbre_livres_dispo
FROM livres l
INNER JOIN auteurs a
ON l.auteur_id = a.id
WHERE l.stock > 0
GROUP BY a.nationalite;

-- Quels sont les 5 livres avec le meilleur rapport qualité-stock (stock élevé ET prix bas — à toi de définir les seuils) ?
SELECT titre, prix, stock, ROUND(((stock::NUMERIC)/prix),2) AS score
FROM livres
WHERE stock > 30
ORDER BY score DESC
LIMIT 5;

-- Quelle est la répartition du catalogue par tranche de prix : économique (< 15€), standard (15-20€), premium (> 20€) ?
SELECT 
	CASE
		WHEN prix < 15 THEN 'Economique'
		WHEN prix BETWEEN 15 AND 20 THEN 'Standard'
		ELSE 'Premium'
	END AS categorie,
	COUNT(titre) AS nbre_livre
FROM livres
GROUP BY 
	CASE
		WHEN prix < 15 THEN 'Economique'
		WHEN prix BETWEEN 15 AND 20 THEN 'Standard'
		ELSE 'Premium'
	END;
	
-- Quel pourcentage du catalogue total représente chaque auteur ?
SELECT DISTINCT CONCAT(a.prenom, ' ', a.nom) AS auteur, 
		ROUND((((COUNT(l.titre) OVER(PARTITION BY a.id))::NUMERIC)/((COUNT(l.id) OVER())::NUMERIC)),2)*100 AS "pourcentage %"
FROM auteurs a
INNER JOIN livres l
ON a.id = l.auteur_id;

-- Quels livres ont un stock inférieur à la moyenne et un prix supérieur à la moyenne ? (livres chers ET peu disponibles)
WITH livres_agg AS (
	SELECT titre,
		stock, ROUND((AVG(stock) OVER()),0) AS avg_stock, prix,
		ROUND((AVG(prix) OVER()),2) AS avg_prix
	FROM livres
)
SELECT *
FROM livres_agg
WHERE stock < avg_stock AND prix > avg_prix;


