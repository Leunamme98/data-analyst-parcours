# Data Analyst Parcours

> Parcours complet pour devenir Data Analyst — SQL, Python, Power BI  
> Ce dépôt sert à la fois de **portfolio de progression** et de **guide d'apprentissage** pour toute personne souhaitant entrer dans la data.

---

## À propos de ce dépôt

Ce dépôt retrace mon apprentissage de la data analyse, module par module, leçon par leçon. Chaque leçon contient :

- Un ou plusieurs **scripts commentés** prêts à être exécutés
- Un **README détaillé** qui explique les concepts, les commandes et les pièges à éviter

L'objectif est double :
1. **Portfolio** — montrer ma progression et mes compétences techniques
2. **Guide** — servir de référence à quiconque apprend la data analyse

---

## Qui peut suivre ce parcours ?

Ce parcours est conçu pour :

- Les **débutants complets** qui n'ont jamais écrit une ligne de SQL ou de Python
- Les **personnes en reconversion** qui veulent structurer leur apprentissage
- Les **étudiants** qui cherchent un guide pratique avec des exercices concrets

**Prérequis :**
- Savoir utiliser un ordinateur (installer un logiciel, naviguer dans des dossiers)
- Aucune connaissance en programmation requise pour commencer

---

## Technologies utilisées

| Technologie  | Usage                                      | Version recommandée |
|--------------|--------------------------------------------|---------------------|
| PostgreSQL   | Base de données relationnelle — Module 1   | 15+                 |
| DBeaver      | Interface graphique pour PostgreSQL        | Dernière version    |
| Python       | Analyse de données — Module 2              | 3.11+               |
| pandas       | Manipulation de données en Python          | 2.x                 |
| matplotlib / seaborn | Visualisation en Python           | Dernières versions  |
| Power BI     | Tableaux de bord — Module 3                | Desktop (gratuit)   |
| Git / GitHub | Versionnement et partage du code           | Dernière version    |

---

## Structure du parcours

```
data-analyst-parcours/
│
├── module-1-sql/               # Maîtriser SQL avec PostgreSQL
│   ├── lecon-1-1/              # Création de base de données (DDL + INSERT)
│   ├── lecon-1-2/              # Interroger et filtrer (SELECT, WHERE, ORDER BY)
│   ├── lecon-1-3/              # Agrégations (COUNT, SUM, AVG, GROUP BY, HAVING)
│   ├── lecon-1-4/              # Jointures (INNER JOIN, LEFT JOIN, etc.)     [à venir]
│   ├── lecon-1-5/              # Sous-requêtes et CTEs                       [à venir]
│   └── lecon-1-6/              # Fonctions window (RANK, ROW_NUMBER, etc.)   [à venir]
│
├── module-2-python/            # Analyse de données avec Python               [à venir]
│   ├── lecon-2-1/              # Introduction à pandas
│   ├── lecon-2-2/              # Nettoyage et transformation de données
│   ├── lecon-2-3/              # Visualisation avec matplotlib et seaborn
│   └── lecon-2-4/              # Projet d'analyse complet
│
├── module-3-powerbi/           # Tableaux de bord avec Power BI               [à venir]
│   ├── lecon-3-1/              # Connexion aux données et modèle de données
│   ├── lecon-3-2/              # Mesures DAX essentielles
│   └── lecon-3-3/              # Création de rapports interactifs
│
└── module-4-projets/           # Projets de bout en bout                      [à venir]
    ├── projet-1-ventes/        # Analyse des ventes d'une librairie
    ├── projet-2-rh/            # Analyse RH et turnover
    └── projet-3-marketing/     # Analyse d'une campagne marketing
```

---

## Comment suivre le parcours

### Étape 1 — Cloner le dépôt

```bash
git clone https://github.com/Leunamme98/data-analyst-parcours.git
cd data-analyst-parcours
```

### Étape 2 — Installer les outils (Module 1 - SQL)

1. Télécharger et installer **PostgreSQL** : https://www.postgresql.org/download/
2. Télécharger et installer **DBeaver** (interface graphique gratuite) : https://dbeaver.io/
3. Ouvrir DBeaver, créer une connexion vers PostgreSQL (host: `localhost`, port: `5432`)

### Étape 3 — Suivre les leçons dans l'ordre

Chaque dossier de leçon contient un `README.md` à lire en premier, puis les scripts SQL à exécuter dans DBeaver ou `psql`.

```
lecon-1-1 → lecon-1-2 → lecon-1-3 → ...
```

> Conseil : ne pas sauter de leçon. Chaque leçon s'appuie sur la précédente.

---

## Progression

### Module 1 — SQL

| Leçon | Sujet                              | Statut      |
|-------|------------------------------------|-------------|
| 1-1   | Création de base de données        | Terminé     |
| 1-2   | SELECT, WHERE, ORDER BY, LIMIT     | Terminé     |
| 1-3   | Agrégations et GROUP BY            | Terminé     |
| 1-4   | Jointures                          | En cours    |
| 1-5   | Sous-requêtes et CTEs              | À venir     |
| 1-6   | Fonctions window                   | À venir     |

### Module 2 — Python

| Leçon | Sujet                              | Statut      |
|-------|------------------------------------|-------------|
| 2-1   | Introduction à pandas              | À venir     |
| 2-2   | Nettoyage de données               | À venir     |
| 2-3   | Visualisation                      | À venir     |

### Module 3 — Power BI

| Leçon | Sujet                              | Statut      |
|-------|------------------------------------|-------------|
| 3-1   | Modèle de données                  | À venir     |
| 3-2   | DAX                                | À venir     |
| 3-3   | Rapports                           | À venir     |

---

## Base de données fil rouge — `librairiedb`

Tout le Module 1 SQL s'appuie sur une base de données de librairie fictive : **librairiedb**.

Elle contient 3 tables :

| Table     | Description                              | Lignes |
|-----------|------------------------------------------|--------|
| `auteurs` | 5 auteurs classiques (Hugo, Camus, etc.) | 5      |
| `livres`  | 50 livres répartis entre les auteurs     | 50     |
| `clients` | 10 clients de plusieurs pays             | 10     |

Cette base simple mais réaliste permet d'aborder tous les concepts SQL : création, requêtes, agrégations, jointures, sous-requêtes.

---

## Auteur

**Emmanuel Apedo** — Apprenant Data Analyst  
GitHub : [@Leunamme98](https://github.com/Leunamme98)

---

## Utilisation

Ce dépôt est libre d'utilisation à des fins d'apprentissage. Si ce parcours vous est utile, n'hésitez pas à laisser une étoile sur le dépôt.
