-- 3) Insertions dans nos tables : 

INSERT INTO auteurs(nom, prenom, nationalite, date_naissance) VALUES
('Hugo', 'Victor', 'Française', '1802-02-26'),
('Shakespeare', 'William', 'Anglaise', '1564-04-23'),
('Austen', 'Jane', 'Anglaise', '1775-12-16'),
('Camus', 'Albert', 'Française', '1913-11-07'),
('Leon Lev', 'Russe', 'Russe', '1828-09-09');

INSERT INTO livres (titre, prix, date_publication, stock, auteur_id) VALUES

-- Victor Hugo
('Les Misérables', 25.90, '1862-01-01', 50, 1),
('Notre-Dame de Paris', 18.50, '1831-01-01', 40, 1),
('Les Contemplations', 15.00, '1856-01-01', 30, 1),
('La Légende des siècles', 22.90, '1859-01-01', 20, 1),
('Les Châtiments', 14.90, '1853-01-01', 25, 1),
('Cromwell', 12.00, '1827-01-01', 15, 1),
('Hernani', 10.50, '1830-01-01', 35, 1),
('Ruy Blas', 11.90, '1838-01-01', 45, 1),
('Le Dernier Jour d’un condamné', 13.50, '1829-01-01', 30, 1),
('Quatrevingt-treize', 19.90, '1874-01-01', 20, 1),


-- William Shakespeare
('Hamlet', 16.90, '1603-01-01', 60, 2),
('Macbeth', 14.90, '1606-01-01', 55, 2),
('Roméo et Juliette', 13.90, '1597-01-01', 70, 2),
('Othello', 15.50, '1604-01-01', 40, 2),
('Le Roi Lear', 17.00, '1606-01-01', 35, 2),
('La Tempête', 12.90, '1611-01-01', 45, 2),
('Le Songe d’une nuit d’été', 18.90, '1600-01-01', 25, 2),
('Jules César', 14.50, '1599-01-01', 30, 2),
('Richard III', 16.00, '1593-01-01', 20, 2),
('Beaucoup de bruit pour rien', 13.00, '1598-01-01', 35, 2),


-- Jane Austen
('Orgueil et Préjugés', 20.90, '1813-01-01', 80, 3),
('Raison et Sentiments', 18.50, '1811-01-01', 60, 3),
('Emma', 17.90, '1815-01-01', 45, 3),
('Mansfield Park', 19.90, '1814-01-01', 35, 3),
('Persuasion', 15.90, '1817-01-01', 50, 3),
('L’Abbaye de Northanger', 14.90, '1817-01-01', 25, 3),
('Lady Susan', 12.90, '1871-01-01', 30, 3),
('Les Watson', 10.90, '1871-01-01', 15, 3),
('Sanditon', 13.50, '1870-01-01', 20, 3),
('Juvenilia', 11.90, '1790-01-01', 10, 3),


-- Albert Camus
('L’Étranger', 14.90, '1942-01-01', 100, 4),
('La Peste', 19.90, '1947-01-01', 80, 4),
('Le Mythe de Sisyphe', 16.50, '1942-01-01', 50, 4),
('La Chute', 18.00, '1956-01-01', 40, 4),
('L’Homme révolté', 17.90, '1951-01-01', 35, 4),
('Noces', 12.50, '1938-01-01', 25, 4),
('L’Envers et l’Endroit', 11.90, '1937-01-01', 20, 4),
('Caligula', 13.90, '1944-01-01', 45, 4),
('Le Malentendu', 12.90, '1944-01-01', 30, 4),
('Les Justes', 15.00, '1949-01-01', 25, 4),


-- Léon Tolstoï
('Guerre et Paix', 29.90, '1869-01-01', 70, 5),
('Anna Karénine', 24.90, '1878-01-01', 65, 5),
('La Mort d’Ivan Ilitch', 14.90, '1886-01-01', 40, 5),
('Résurrection', 22.00, '1899-01-01', 35, 5),
('Hadji Mourat', 13.90, '1912-01-01', 30, 5),
('Sonate à Kreutzer', 15.50, '1889-01-01', 25, 5),
('Enfance', 12.00, '1852-01-01', 20, 5),
('Adolescence', 12.50, '1854-01-01', 20, 5),
('Maître et Serviteur', 11.90, '1895-01-01', 15, 5),
('Le Père Serge', 13.00, '1911-01-01', 25, 5);


INSERT INTO clients(prenom, nom, email, ville) VALUES
('Emmanuel', 'Apedo', 'emmanuel.apedo@gmail.com', 'Lome'),
('Kossi', 'Mensah', 'kossi.mensah@gmail.com', 'Lome'),
('Ama', 'Kouassi', 'ama.kouassi@gmail.com', 'Abidjan'),
('Jean', 'Dupont', 'jean.dupont@gmail.com', 'Paris'),
('Sophie', 'Martin', 'sophie.martin@gmail.com', 'Lyon'),
('Alice', 'Durand', 'alice.durand@gmail.com', 'Marseille'),
('Paul', 'Bernard', 'paul.bernard@gmail.com', 'Toulouse'),
('Nadia', 'Traore', 'nadia.traore@gmail.com', 'Dakar'),
('Ibrahim', 'Diallo', 'ibrahim.diallo@gmail.com', 'Conakry'),
('Fatou', 'Ba', 'fatou.ba@gmail.com', 'Dakar');