-- AXE 2 — Performance des auteurs (JOIN, GROUP BY, HAVING)

-- 6. Quel auteur génère le plus de valeur stock (stock × prix) au total ?
SELECT 
	CONCAT(a.prenom, ' ', a.nom) AS auteur, 
	SUM(l.stock*l.prix) AS valeur
FROM auteurs a
INNER JOIN livres l
ON a.id = l.auteur_id
GROUP BY CONCAT(a.prenom, ' ', a.nom)
ORDER BY SUM(l.stock*l.prix) DESC
LIMIT 1;

-- 7. Quels auteurs ont une gamme de prix étendue (écart entre leur livre le plus cher et le moins cher > 10€) ?
WITH agg_table AS (
	SELECT CONCAT(a.prenom, ' ', a.nom) AS auteur, titre, prix,
		FIRST_VALUE(l.titre) OVER(PARTITION BY a.id ORDER BY l.prix) AS titre_livre_moins_cher,
		FIRST_VALUE(l.prix) OVER(PARTITION BY a.id ORDER BY l.prix) AS prix_livre_moins_cher,
		LAST_VALUE(l.titre) OVER(PARTITION BY a.id ORDER BY l.prix ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS titre_livre_plus_cher,
		LAST_VALUE(l.prix) OVER(PARTITION BY a.id ORDER BY l.prix ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS prix_livre_plus_cher,
		ROW_NUMBER() OVER(PARTITION BY a.id ORDER BY l.prix ) AS rang
	FROM auteurs a
	INNER JOIN livres l
	ON a.id = l.auteur_id
)
SELECT auteur, titre_livre_moins_cher,prix_livre_moins_cher,titre_livre_plus_cher, prix_livre_plus_cher, (prix_livre_plus_cher - prix_livre_moins_cher) AS ecart_prix
FROM agg_table 
WHERE (prix_livre_plus_cher - prix_livre_moins_cher) > 10 AND rang = 1
ORDER BY (prix_livre_plus_cher - prix_livre_moins_cher) DESC;

-- 8. Affiche le top 3 des auteurs par prix moyen avec leur nationalité
SELECT ROW_NUMBER() OVER(ORDER BY moy_prix DESC) AS rang, *
FROM
	(SELECT
		DISTINCT CONCAT(a.prenom, ' ', a.nom) AS auteur,
		nationalite,
		ROUND(AVG(l.prix) OVER(PARTITION BY a.id), 2) AS moy_prix
	FROM auteurs a
	INNER JOIN livres l
	ON a.id = l.auteur_id) AS t
LIMIT 3;

-- 9. Quels auteurs ont plus de 5 livres avec un stock supérieur à 30 ?
SELECT 
	CONCAT(a.prenom, ' ', a.nom) AS auteur,
	COUNT(l.titre) AS nbre_livre
FROM auteurs a
	INNER JOIN livres l
	ON a.id = l.auteur_id
WHERE l.stock > 30
GROUP BY CONCAT(a.prenom, ' ', a.nom)
HAVING COUNT(l.titre) > 5
ORDER BY nbre_livre DESC, auteur

-- 10. Pour chaque nationalité, quel est l'auteur avec le plus de livres ?
SELECT nationalite, auteur, nbre_livre
FROM(
	SELECT 
		a.nationalite,
		RANK() OVER(PARTITION BY a.nationalite ORDER BY COUNT(l.titre) DESC) AS rang,
		CONCAT(a.prenom, ' ', a.nom) AS auteur,
		COUNT(l.titre) AS nbre_livre
	FROM auteurs a
		INNER JOIN livres l
		ON a.id = l.auteur_id
	GROUP BY CONCAT(a.prenom, ' ', a.nom), a.nationalite) AS t
WHERE rang = 1
ORDER BY nationalite, nbre_livre DESC;




