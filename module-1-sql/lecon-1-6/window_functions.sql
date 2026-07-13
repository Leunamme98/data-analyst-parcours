-- Niveau 1 — Classements

-- Classe tous les livres par prix décroissant avec ROW_NUMBER()
SELECT titre, prix, ROW_NUMBER() OVER(ORDER BY prix DESC) as rang
FROM livres;

-- Pour chaque auteur, classe ses livres du plus cher au moins cher avec RANK()
SELECT a.prenom, a.nom, l.titre, l.prix, RANK() OVER(PARTITION BY l.auteur_id ORDER BY l.prix DESC) AS rang
FROM livres l
INNER JOIN auteurs a
ON l.auteur_id = a.id;

-- Affiche le rang de chaque livre par stock avec DENSE_RANK() — sans partition
SELECT titre, stock, DENSE_RANK() OVER(ORDER BY stock DESC) AS rang
FROM livres l;

-- Niveau 2 — Agrégations sur fenêtre

-- Affiche chaque livre avec son prix et le prix moyen de tous les livres de son auteur sur la même ligne
SELECT l.titre, l.prix, CONCAT(a.prenom,' ', a.nom) AS auteur, ROUND(AVG(l.prix) OVER(PARTITION BY a.id), 2) AS prix_moy
FROM livres l
INNER JOIN auteurs a
ON l.auteur_id = a.id;

-- Affiche chaque livre avec son stock et le stock  de son auteur sur la même ligne
SELECT l.titre, l.stock, CONCAT(a.prenom,' ', a.nom) AS auteur , SUM(l.stock) OVER(PARTITION BY a.id) AS stock_total
FROM livres l
INNER JOIN auteurs a
ON l.auteur_id = a.id;

-- Affiche chaque livre avec son prix et le prix du livre le moins cher du même auteur
SELECT l.titre, l.prix, CONCAT(a.prenom,' ', a.nom) AS auteur , FIRST_VALUE(prix) OVER(PARTITION BY a.id ORDER BY prix ASC) AS plus_petit_prix
FROM livres l
INNER JOIN auteurs a
ON l.auteur_id = a.id;

-- Niveau 3 — LAG/LEAD & cumuls

-- Affiche chaque livre avec son prix et le prix du livre précédent dans l'ordre de prix croissant
SELECT titre, prix, LAG(titre) OVER(ORDER BY prix ASC) AS titre_prec, LAG(prix) OVER(ORDER BY prix ASC) AS prix_prec
FROM livres;

-- Calcule le stock cumulatif des livres triés par date de publication
SELECT titre, date_publication, stock, SUM(stock) OVER(ORDER BY date_publication ASC) AS stock_cumule
FROM livres;

-- Pour chaque auteur, affiche le livre le plus cher et le moins cher sur la même ligne que chaque livre
SELECT CONCAT(a.prenom,' ', a.nom) AS auteur,
	l.titre, l.prix,
	MIN(l.prix) OVER(PARTITION BY a.id) AS prix_min,
	MAX(l.prix) OVER(PARTITION BY a.id) AS prix_max
FROM auteurs a
INNER JOIN livres l
ON a.id = l.auteur_id;
