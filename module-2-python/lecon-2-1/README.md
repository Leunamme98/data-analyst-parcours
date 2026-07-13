# Leçon 2-1 — Environnement Python Data Analyst

## Objectifs pédagogiques

- Comprendre ce qu'est un environnement virtuel et pourquoi l'utiliser
- Installer les bibliothèques essentielles de la data analyse
- Configurer Jupyter Notebook dans VS Code
- Vérifier que l'environnement est opérationnel

---

## Concept — Pourquoi un environnement virtuel ?

Un **environnement virtuel** (`venv`) est un dossier isolé qui contient sa propre installation de Python et ses propres bibliothèques. Sans lui, toutes les bibliothèques s'installent globalement sur ton système — ce qui crée des conflits de version entre les projets.

```
Sans venv :                    Avec venv :
────────────────────           ──────────────────────────────────
Python global                  Python global
  └── pandas 1.5               ├── projet-A/venv/
  └── numpy 1.23               │     └── pandas 2.1  (version A)
  └── ...                      └── projet-B/venv/
                                      └── pandas 1.5  (version B)
```

**Règle :** un projet = un venv. Toujours activer le venv avant de travailler.

---

## Installation — étapes dans l'ordre

### Étape 1 — Se placer dans le dossier du module

```bash
cd data-analyst-parcours/module-2-python
```

### Étape 2 — Créer l'environnement virtuel

```bash
python -m venv venv
```

Un dossier `venv/` apparaît. Il contient Python et pip isolés. Ce dossier est exclu de Git (listé dans `.gitignore`).

### Étape 3 — Activer l'environnement

```bash
# Windows
venv\Scripts\activate

# macOS / Linux
source venv/bin/activate
```

Tu dois voir `(venv)` apparaître au début de la ligne dans le terminal :

```
(venv) D:\DATA-ANALYST\data-analyst-parcours-main\module-2-python>
```

> Pour désactiver le venv à tout moment : `deactivate`

### Étape 4 — Installer les bibliothèques

```bash
pip install jupyter pandas numpy matplotlib seaborn
```

Ou directement depuis le fichier de dépendances du projet :

```bash
pip install -r requirements.txt
```

### Étape 5 — Installer l'extension Jupyter dans VS Code

1. Ouvrir VS Code
2. Extensions (`Ctrl+Shift+X`)
3. Chercher **"Jupyter"** (éditeur : Microsoft)
4. Installer

### Étape 6 — Vérifier l'installation

```bash
jupyter --version
python -c "import pandas; print('pandas', pandas.__version__)"
python -c "import numpy; print('numpy', numpy.__version__)"
python -c "import matplotlib; print('matplotlib', matplotlib.__version__)"
python -c "import seaborn; print('seaborn', seaborn.__version__)"
```

---

## Les bibliothèques installées

| Bibliothèque   | Rôle                                                    | Équivalent SQL            |
|----------------|---------------------------------------------------------|---------------------------|
| `pandas`       | Manipulation de données sous forme de tableaux (DataFrames) | Tables + requêtes SELECT  |
| `numpy`        | Calculs numériques rapides, tableaux multidimensionnels | Fonctions mathématiques   |
| `matplotlib`   | Visualisation de base (graphiques, courbes, histogrammes) | —                         |
| `seaborn`      | Visualisation avancée, plus esthétique, basée sur matplotlib | —                    |
| `jupyter`      | Notebooks interactifs : code + texte + visualisations   | —                         |

---

## Utiliser Jupyter dans VS Code

### Créer un notebook

1. `Ctrl+Shift+P` → taper **"New Jupyter Notebook"** → Entrée
2. Sauvegarder avec `.ipynb` comme extension (ex : `exploration.ipynb`)

### Sélectionner le bon kernel

En haut à droite du notebook, cliquer sur le kernel → **"Select Another Kernel"** → **"Python Environments"** → choisir le Python du venv (`venv`).

> Si le venv n'apparaît pas, fermer et rouvrir VS Code depuis le dossier du projet.

### Anatomie d'un notebook

Un notebook est composé de **cellules** :

| Type de cellule | Usage                                               |
|-----------------|-----------------------------------------------------|
| **Code**        | Contient du Python exécutable                       |
| **Markdown**    | Contient du texte formaté (titres, explications)    |

- Exécuter une cellule : `Shift+Enter` (passe à la suivante) ou `Ctrl+Enter` (reste sur la cellule)
- Ajouter une cellule : `+` dans la barre ou `A` (avant) / `B` (après) en mode commande

---

## Vérification complète — premier notebook

Crée un fichier `verification.ipynb` et exécute ces cellules :

```python
# Cellule 1 — imports
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

print("Toutes les bibliothèques importées avec succès.")
print(f"pandas  : {pd.__version__}")
print(f"numpy   : {np.__version__}")
```

```python
# Cellule 2 — premier DataFrame
data = {
    "titre":  ["Les Misérables", "Hamlet", "L'Étranger"],
    "prix":   [25.90, 16.90, 14.90],
    "stock":  [50, 60, 100]
}
df = pd.DataFrame(data)
df
```

```python
# Cellule 3 — premier graphique
df.plot(kind="bar", x="titre", y="prix", legend=False, title="Prix des livres")
plt.ylabel("Prix (€)")
plt.tight_layout()
plt.show()
```

Si les trois cellules s'exécutent sans erreur, l'environnement est prêt.

---

## Structure du module 2

```
module-2-python/
├── venv/                  ← environnement virtuel (ignoré par Git)
├── requirements.txt       ← liste des dépendances à installer
├── lecon-2-1/             ← Cette leçon : setup de l'environnement
├── lecon-2-2/             ← Pandas : chargement et exploration de données
├── lecon-2-3/             ← Nettoyage et transformation
├── lecon-2-4/             ← Visualisation (matplotlib, seaborn)
└── lecon-2-5-projet/      ← Projet : analyse complète avec Python
```

---

## Pour aller plus loin

- **Leçon 2-2** — Pandas : chargement, exploration et premières statistiques sur `librairiedb`

---

## Exercices

> Ces exercices se font directement dans un notebook Jupyter. Crée un fichier `exercices_2_1.ipynb`.

### Exercice 1 — Vérification d'import (débutant)

Dans une cellule, importe les 4 bibliothèques (`pandas`, `numpy`, `matplotlib.pyplot`, `seaborn`) et affiche leur version. Ajoute une cellule Markdown au-dessus avec le titre `# Exercice 1 — Imports`.

### Exercice 2 — Premier DataFrame (débutant)

Crée un DataFrame pandas avec les données suivantes et affiche-le :

| auteur      | nationalite | nb_livres |
|-------------|-------------|-----------|
| Victor Hugo | Française   | 10        |
| Shakespeare | Anglaise    | 10        |
| Albert Camus| Française   | 10        |

### Exercice 3 — Statistiques de base (intermédiaire)

À partir du DataFrame de l'exercice 2, utilise `.describe()` pour obtenir les statistiques descriptives. Affiche aussi le nombre total de livres avec `.sum()`.

### Exercice 4 — Premier graphique (intermédiaire)

Trace un graphique en barres horizontales (`barh`) du nombre de livres par auteur. Ajoute un titre, un label sur l'axe X et affiche-le avec `plt.show()`.
