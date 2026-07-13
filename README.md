# Data Analyst Parcours — APEDO Kossi Emmanuel

> Parcours complet Data Analyst — SQL, Python, Power BI  
> Portfolio de progression structuré et guide d'apprentissage open source

---

## À propos de moi

**Apedo Kossi Emmanuel** — Ingénieur en Conception Informatique (Bac+5, IAI Gabon), Data Analyst, certifié Google Data Analytics.

Expérience en analyse de données télécom chez **Huawei Technologies Gabon** (PostgreSQL, SQL avancé, segmentation clients, reporting automatisé) et en développement fullstack (Spring Boot, Angular, Docker). Plus de 8 ans d'expérience en enseignement — ce qui m'amène à aborder la data autant comme praticien que comme pédagogue.

- LinkedIn : [linkedin.com/in/ApedoKossiEmmanuel](https://linkedin.com/in/ApedoKossiEmmanuel)
- GitHub : [github.com/Leunamme98](https://github.com/Leunamme98)
- Email : apedokossiemmanuel@gmail.com

---

## À propos de ce dépôt

Ce dépôt a deux objectifs :

1. **Portfolio** — tracer ma progression et démontrer mes compétences en data analyse, module par module
2. **Guide d'apprentissage** — servir de référence structurée à toute personne qui veut apprendre la data analyse depuis zéro

Chaque leçon contient :
- Des **scripts commentés** prêts à être exécutés
- Un **README pédagogique** qui explique les concepts, les commandes et les pièges courants

---

## À qui s'adresse ce parcours ?

- Les **débutants complets** qui n'ont jamais écrit une ligne de SQL ou de Python
- Les **personnes en reconversion** qui cherchent une progression structurée
- Les **étudiants** qui veulent un guide pratique avec des exercices concrets

**Prérequis :** aucune connaissance en programmation requise pour commencer le Module 1.

---

## Technologies utilisées

| Technologie            | Usage                                    | Version recommandée |
|------------------------|------------------------------------------|---------------------|
| PostgreSQL             | Base de données relationnelle — Module 1 | 15+                 |
| DBeaver                | Interface graphique pour PostgreSQL      | Dernière version    |
| Python                 | Analyse de données — Module 2            | 3.11+               |
| pandas / NumPy         | Manipulation de données                  | 2.x                 |
| matplotlib / seaborn   | Visualisation                            | Dernières versions  |
| Power BI Desktop       | Tableaux de bord — Module 3              | Gratuit             |
| Git / GitHub           | Versionnement et partage                 | Dernière version    |

---

## Structure du parcours

```
data-analyst-parcours/
│
├── module-1-sql/               # Maîtriser SQL avec PostgreSQL
│   ├── lecon-1-1/              ✅ Création de base de données (DDL + INSERT)
│   ├── lecon-1-2/              ✅ Interroger et filtrer (SELECT, WHERE, ORDER BY)
│   ├── lecon-1-3/              ✅ Agrégations (COUNT, SUM, AVG, GROUP BY, HAVING)
│   ├── lecon-1-4/              ✅ Jointures (INNER JOIN, LEFT JOIN, etc.)
│   ├── lecon-1-5/              ✅ Sous-requêtes et CTEs
│   ├── lecon-1-6/              ✅ Fonctions window (RANK, ROW_NUMBER, etc.)
│   └── lecon-1-7-projet/       ✅ Projet — Analyse complète librairiedb (20 requêtes)
│
├── module-2-python/            🔄 Analyse de données avec Python
│   ├── lecon-2-1/              ✅ Environnement : venv, Jupyter, pandas, numpy...
│   ├── lecon-2-2/              📋 Pandas : chargement et exploration
│   ├── lecon-2-3/              📋 Nettoyage et transformation
│   ├── lecon-2-4/              📋 Visualisation (matplotlib, seaborn)
│   └── lecon-2-5-projet/       📋 Projet d'analyse complet
│
├── module-3-powerbi/           📋 Tableaux de bord avec Power BI
│   ├── lecon-3-1/              Connexion aux données et modèle
│   ├── lecon-3-2/              Mesures DAX essentielles
│   └── lecon-3-3/              Rapports interactifs
│
└── module-4-projets/           📋 Projets de bout en bout
    ├── projet-1-ventes/        Analyse des ventes d'une librairie
    ├── projet-2-rh/            Analyse RH et turnover
    └── projet-3-marketing/     Analyse d'une campagne marketing
```

**Légende :** ✅ Terminé · 🔄 En cours · 📋 À venir

---

## Comment démarrer

### Étape 1 — Cloner le dépôt

```bash
git clone https://github.com/Leunamme98/data-analyst-parcours.git
cd data-analyst-parcours
```

### Étape 2 — Installer les outils (Module 1 — SQL)

1. **PostgreSQL** : [postgresql.org/download](https://www.postgresql.org/download/) — le moteur de base de données
2. **DBeaver** : [dbeaver.io](https://dbeaver.io/) — interface graphique gratuite pour écrire et exécuter du SQL
3. Ouvrir DBeaver → Nouvelle connexion → PostgreSQL → `localhost`, port `5432`

### Étape 3 — Suivre les leçons dans l'ordre

Lire le `README.md` de chaque leçon en premier, puis exécuter les scripts SQL dans DBeaver.

```
lecon-1-1 → lecon-1-2 → lecon-1-3 → ...
```

---

## Progression

### Module 1 — SQL

| Leçon | Sujet                          | Statut      |
|-------|--------------------------------|-------------|
| 1-1   | Création de base de données    | ✅ Terminé  |
| 1-2   | SELECT, WHERE, ORDER BY, LIMIT | ✅ Terminé  |
| 1-3   | Agrégations et GROUP BY        | ✅ Terminé  |
| 1-4   | Jointures                      | ✅ Terminé  |
| 1-5   | Sous-requêtes et CTEs          | ✅ Terminé  |
| 1-6   | Fonctions window               | ✅ Terminé  |
| 1-7   | Projet — Analyse librairiedb   | ✅ Terminé  |

### Module 2 — Python

| Leçon | Sujet                          | Statut      |
|-------|--------------------------------|-------------|
| 2-1   | Environnement (venv, Jupyter)  | ✅ Terminé  |
| 2-2   | Pandas — exploration           | 📋 À venir  |
| 2-3   | Nettoyage et transformation    | 📋 À venir  |
| 2-4   | Visualisation                  | 📋 À venir  |

### Module 3 — Power BI · Module 4 — Projets

> À venir.

---

## Base de données fil rouge — `librairiedb`

Tout le Module 1 s'appuie sur une base de données de librairie fictive construite en leçon 1-1.

| Table     | Description                              | Lignes |
|-----------|------------------------------------------|--------|
| `auteurs` | 5 auteurs classiques (Hugo, Camus, etc.) | 5      |
| `livres`  | 50 livres répartis entre les auteurs     | 50     |
| `clients` | 10 clients de plusieurs pays             | 10     |

Cette base simple mais réaliste permet d'aborder tous les concepts SQL : création, requêtes, agrégations, jointures, sous-requêtes et fonctions window.

---

*Ce dépôt est libre d'utilisation à des fins d'apprentissage.*
