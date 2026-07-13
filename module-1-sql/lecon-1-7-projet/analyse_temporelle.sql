-- AXE 3 — Analyse temporelle
-- (DATE, sous-requêtes, CTE)
-- 11. Combien de livres ont été publiés par décennie ?
SELECT
	((EXTRACT(YEAR FROM date_publication)::INT)/10)*10 AS decenie,
	COUNT(id) AS nbre_livre
FROM livres
GROUP BY ((EXTRACT(YEAR FROM date_publication)::INT)/10)*10
ORDER BY decenie ASC;

-- 12. Quel auteur a la carrière la plus longue (écart entre son premier et dernier livre publié) ?
SELECT 
	DISTINCT CONCAT(a.prenom, ' ', a.nom) AS auteur,
	AGE(MAX(l.date_publication) OVER(PARTITION BY a.id), MIN(l.date_publication) OVER(PARTITION BY a.id)) AS duree_carriere
FROM auteurs a
INNER JOIN livres l
ON a.id = l.auteur_id
ORDER BY duree_carriere DESC
LIMIT 1;

-- 13. Avec une CTE, identifie les livres publiés après 1900 dont le stock est dans le top 10 global
WITH livre_agg AS (
	SELECT 
		RANK() OVER(ORDER BY stock DESC) AS rang,
		titre, 
		date_publication, 
		stock
	FROM livres
)
SELECT rang, titre, date_publication::DATE, stock
FROM livre_agg
WHERE rang <= 10 AND EXTRACT(YEAR FROM date_publication) > 1900
ORDER BY stock DESC;

-- 14. Y a-t-il une corrélation entre l'ancienneté d'un livre (année de publication) et son prix ? (affiche année, prix, et moyenne mobile sur 5 livres consécutifs)
SELECT 
	titre, prix,
	EXTRACT(YEAR FROM date_publication) AS annee_pub,
	ROUND(AVG(prix) OVER(ORDER BY date_publication ROWS BETWEEN 4 PRECEDING AND CURRENT ROW), 2)AS moy_mobile_5
FROM livres
ORDER BY annee_pub ASC

-- 15. Quels livres ont été publiés la même année qu'un autre livre du même auteur 
SELECT
	CONCAT(a.prenom, ' ', a.nom) AS auteur,
	l1.titre, l1.date_publication,
	l2.titre AS meme_livre, l2.date_publication,
	EXTRACT(YEAR FROM l1.date_publication) AS "year"
FROM livres l1
JOIN livres l2
ON l1.auteur_id = l2.auteur_id
INNER JOIN auteurs a
ON l1.auteur_id = a.id
WHERE 
	EXTRACT(YEAR FROM l1.date_publication) = EXTRACT(YEAR FROM l2.date_publication)
	AND l1.id < l2.id
ORDER BY auteur, "year";