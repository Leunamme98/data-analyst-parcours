-- 16. Pour chaque auteur, quel est le rang de chaque livre par prix avec DENSE_RANK() ?
SELECT 
	CONCAT(a.prenom, ' ', a.nom) AS auteur,
	DENSE_RANK() OVER(PARTITION BY a.id ORDER BY l.prix DESC) AS rang,
	prix,
	l.titre
FROM auteurs a 
INNER JOIN livres l
ON a.id = l.auteur_id;

-- 17. Affiche chaque livre avec son prix, le prix moyen de son auteur, et l'écart en % entre les deux
SELECT
	titre, prix,
	ROUND(AVG(prix) OVER(PARTITION BY auteur_id), 2) AS moy_prix_auteur,
	ROUND((ABS(prix - ROUND(AVG(prix) OVER(PARTITION BY auteur_id), 2)) / ROUND(AVG(prix) OVER(PARTITION BY auteur_id), 2)) * 100, 2) AS "ecart_%"
FROM livres
ORDER BY "ecart_%" DESC;

-- 18. Pour chaque livre, affiche le titre du livre suivant et précédent dans l'ordre alphabétique (LAG + LEAD)
SELECT
	titre,
	LEAD(titre) OVER(ORDER BY titre ASC) AS livre_suivant,
	LAG(titre) OVER(ORDER BY titre ASC) AS livre_precedant
FROM livres;

-- 19. Calcule le stock cumulatif par auteur, trié par date de publication
SELECT 
	CONCAT(a.prenom, ' ', a.nom) AS auteur, stock, date_publication::DATE,
	SUM(stock) OVER(PARTITION BY a.id ORDER BY date_publication ASC) AS stock_cumule
FROM auteurs a 
INNER JOIN livres l
ON a.id = l.auteur_id;	

-- 20. Identifie pour chaque auteur son livre le plus cher et classe ces livres entre eux avec RANK()

WITH agg_tab AS (
    SELECT
        CONCAT(a.prenom, ' ', a.nom) AS auteur,
        FIRST_VALUE(l.titre) OVER (
            PARTITION BY a.id
            ORDER BY l.prix DESC
        ) AS livre_plus_cher,
        FIRST_VALUE(l.prix) OVER (
            PARTITION BY a.id
            ORDER BY l.prix DESC
        ) AS prix_plus_cher
    FROM auteurs a
    JOIN livres l
      ON a.id = l.auteur_id
),
top_livres AS (
    SELECT DISTINCT
        auteur,
        livre_plus_cher,
        prix_plus_cher
    FROM agg_tab
)
SELECT
    RANK() OVER (ORDER BY prix_plus_cher DESC) AS rang,
    auteur,
    livre_plus_cher,
    prix_plus_cher
FROM top_livres;