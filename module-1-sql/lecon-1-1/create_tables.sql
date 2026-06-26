-- 1) Création de la base de données "librairiedb"
CREATE DATABASE librairiedb;

-- 2) Création des tables auteurs, livres et clients :
-- Table "auteurs"
CREATE TABLE IF NOT EXISTS auteurs(
    id SERIAL PRIMARY KEY ,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    nationalite TEXT NOT NULL,
    date_naissance DATE NOT NULL
);

-- Table "livres"
CREATE TABLE IF NOT EXISTS livres(
    id SERIAL PRIMARY KEY,
    titre TEXT NOT NULL,
	prix NUMERIC(15,2) NOT NULL,
    date_publication TIMESTAMP NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    auteur_id INT,
    FOREIGN KEY (auteur_id) REFERENCES auteurs(id)
);

-- Table "clients"
CREATE TABLE IF NOT EXISTS clients(
    id SERIAL PRIMARY KEY,
    prenom TEXT NOT NULL,
    nom TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ville TEXT NOT NULL
);




-- 4) Vérification : 
SELECT * FROM auteurs;
SELECT * FROM livres;
SELECT * FROM clients;





























