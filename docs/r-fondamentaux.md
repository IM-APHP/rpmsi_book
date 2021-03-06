# Language R : les fondamentaux

## Instructions
R en tant que langage interprété (en opposition à un langage compilé) peut être utilisé pour envoyer des instructions qui sont exécutées directement par la machine.
Il existe donc un interpréteur R que l'on peut utiliser tel quel, par exemple comme une machine à calculer.


```r
1 / 200 * 30
```

```
## [1] 0.15
```

```r
(59 + 73 + 2) / 3
```

```
## [1] 44.66667
```

```r
sin(pi / 2)
```

```
## [1] 1
```

```r
1:10
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

Dès lors que nos instructions vont se complexifier on voit qu'il sera utile de garder la trace de nos actions et c'est la raison pour laquelle R s'utilise avec un éditeur de code qui permet de sauvegarder l'ensemble des instructions données à la machine.
Celles-ci pourront ensuite être envoyées en une seule fois, voire s'exécuter automatiquement avec l'utilisation d'un planificateur de tâches.


RStudio propose un environnement de travail intégré qui permet de réunir ces 2 fonctions principales : interpréteur et éditeur de code.
Cette intégration permet d'envoyer simplement le code écrit dans l'éditeur à l'interpréteur.
C'est cette dernière façon d'écrire du code que nous allons utiliser et qui va nous permettre d'utiliser les programmes préparés pour cette introduction.

## Objets
En complément de l'exécution d'instruction, R permet de stocker des données dans la mémoire de l'ordinateur.
Pour cela R, n'utilise que la mémoire RAM, la mémoire de travail.
Ce principe permet de garantir une exécution rapide des instructions qui utilise les données enregistrées en mémoire, à l'inverse il s'agit d'une mémoire dont la taille est limitée et qui rend donc l'utilisation du langage R plus complexe pour le traitement de données volumineuses.
Dans le cadre du traitement des données PMSI, nous pourrons utiliser un autre mode d'enregistrement des données que nous décrirons plus loin dans le livre.

En R, toute donnée stockée en mémoire est appelée un objet. Tous les objets ont 2 caractéristiques :

- un nom qui permet de les retrouver simplement 
- un type qui permet de structurer la façon dont les données sont stockées.

Il existe plusieurs types d'objets en R dont la définition et la formalisation informatique constituent le cœur du langage.
Cela peut être des nombres, des données plus complexes rangées dans des vecteurs ou des tableaux de données (datadrame) qui sont un équivalent de feuille de calcul excel avec des lignes et des colonnes, mais aussi des instructions, organisées dans une fonction.
Il existe d'autres types d'objets qui permettent de donner au langage puissance et souplesse. Parmi eux, nous mentionnons les listes qui sont très pratique et qui sont une collection d'objets qui peuvent avoir des types différents rangés une même entité.

On peut créer de nouveaux objets avec l'instruction `<-`:


```r
x <- 3 * 4 
x
```

```
## [1] 12
```

Toutes les instructions (statements) qui permettent de créer des objets (**assignment** statements) sont de la forme :


```r
nom_objet <- value
```

Le signe `=` fonctionne également, mais il est quelque peu trompeur et il est communément admis que pour bien marqué le fait qu'il s'agit de donner un nom à un objet stocké en mémoire, on préfère utiliser `<-` .

## Fonctions
L'ensemble du langage R tient donc sur ce paradigme de nom et de type d'objets et sur le fait que les objets sont accessibles par leur nom. Les fonctions constituent un type d’objets à part. Dans la mesure où, en règle générale, elles reçoivent des arguments sur lesquels on va appliquer des transformations, elle s’appelle avec des parenthèses. 


```r
function_name(arg1 = val1, arg2 = val2, ...)
```

Il n’en reste pas moins qu'elles sont des objets, stockées en mémoire, accessibles à tout moment par leur nom, lorsqu’elles sont appelées, elles réalisent l’ensemble des instructions qu’elles contiennent et renvoie leur résultat. 


```r
mean(x)
```

Les fonctions de base dont dispose le langage R sont organisées sous forme de packages. En règle générale, elles ne sont accessibles par leur nom que si nous avons demandé le chargement du package. Ce chargement a pour conséquence de placer dans l'environnement de travail le nom de l’ensemble des fonctions d’un package.

Le package qui contient le langage lui-même s’appelle `base`. Il est en grande partie constituée de fonctions écrites en C qui constituent l’apport du langage lui-même. Il est par défaut chargé en mémoire et les fonctions du package peuvent donc être utilisées sans chargement préalable comme nous l’avons vu avec l’exemple du calcul de la moyenne.

Les fonctions des différents packages peuvent néanmoins être appelées directement dès lors que l’on référence dans l’appel le nom du package :


```r
pmeasyr::irsa(p)
```

Cette fonction du package `pmeasyr` permet de réalisé l’import des RSA dans R. Avant de réaliser concrètement cet import, voyons plus en détails comment s' organise l’enregistrement des données.

## Le format des objets
Chaque donnée possède un format de base qui permet de stocker l’information. R distingue 5 types de données :

- caractère
- entiers
- nombre (réel ou décimal)
- les nombres complexes
- une variable logique oui/non

Il en existe en réalité une 6ème forme qui ne sera pas abordée ici. Avec ces différentes formes on peut constuituer d'autres types de données unitaires en particulier :

- les dates et datatime qui sont en réalité stockées sous forme numérique qui constue l'écart par rapport à un référentiel (par exemple le nombre de jour qui sépare la date du jour du 1er janvier 1970)
- les facteurs
Nous approfondirons ces différentes types au cours du livre.

Le niveau suivant le vecteur qui correspond vraiment au cœur du langage. L'instruction `:` permet de créer facilement des séquences :

```r
x<- 1:10
```

Ils sont bien sur constitués par un ensemble de données élémentaires d’un certain type. Un vecteur n’est donc constitué que d’un seul type de données. Cela permet en particulier de garantir que des opération numérique pourront être réalisée d’un bloc sur un vecteur, par exemple une addition :

```r
x+5
```

```
##  [1]  6  7  8  9 10 11 12 13 14 15
```
On voit que le chiffre 5 a été ajouté à l’ensemble des éléments du vecteur en une seule instruction. Le calcul est vectorisé c'est ce qui fait la grande force de R et qui assure à la fois une simplicité d'écriture (pas de boucle à écrire) et une rapidité d'exécution (l’ensemble du détail du calcul a été programmé en C avec le maximum d’efficacité).

En fait, le niveau de base des objets R sont des vecteurs de données élémentaires et il n'existe pas à proprement parler d'objet vecteur dont on pourrait tester le type. Nous indiquons des fonctions qui permettent d'avoir d'obtenir des information sur la nature des objets.


```r
str(x)
```

```
##  int [1:10] 1 2 3 4 5 6 7 8 9 10
```

```r
class(x)
```

```
## [1] "integer"
```

```r
typeof(x)
```

```
## [1] "integer"
```
La taille du vecteur :

```r
length(x)
```

```
## [1] 10
```

Ces vecteurs peuvent ensuite être associé en tableau de données (dataframe) qui seront les éléments les plus utilisés pour l’analyse de données PMSI.

```r
x <- data.frame(x= 1:10, y= 21:30)
```

Il s'agit en fait d'une collection de vecteurs.

```r
str(x)
```

```
## 'data.frame':	10 obs. of  2 variables:
##  $ x: int  1 2 3 4 5 6 7 8 9 10
##  $ y: int  21 22 23 24 25 26 27 28 29 30
```

```r
class(x)
```

```
## [1] "data.frame"
```

```r
typeof(x)
```

```
## [1] "list"
```

Les données de base unitaires sont accessibles par l'utilisation des crochets en identifiants les "coordonnées" dans le tableau, position de ligne et de colonne :

```r
line_number = 1
columun_number = 2
x[line_number , columun_number]
```

```
## [1] 21
```

Les dataframe ont des noms de colonnes et des noms de ligne

```r
names(x)
```

```
## [1] "x" "y"
```

```r
row.names(x)
```

```
##  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
```

Les données de base unitaires sont également accessibles en identifiant les noms de lignes et de colonnes qui sont de type caractère et non numérique :

```r
line_name = "1"
columun_name = "x"
x[line_name , columun_name]
```

```
## [1] 1
```
Enfin, on peut également identifier une colonne entière par l'utilisation du symbole `$`.

```r
x$x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

Comme un dataframe est une collection de vecteur, les colonnes des dataframes partagent les mêmes caractéristiques, et en particulier elles ne sont constituées que d’une seule catégorie de données. On peut par ailleurs utiliser le calcul vectoriel :

```r
x$x + 5
```

```
##  [1]  6  7  8  9 10 11 12 13 14 15
```

On pourrait développer les nombreuses actions qui peuvent réalisée avec les dataframe dans le paradigme historique du langage R. Nous allons néamoins faire un saut pour se concentrer directement sur les nouvelles méthodes de manipulation des objets en R dans le paradigme `tidyverse` qui propose un ensemble de packages permettant de faciliter l'analyse de données.

## La grammaire dplyr
En premier lieu, nous introduisons une fontion particulière qui a pour but de tenir compte du fait que l'on doit en pratique rarement n'utiliser qu'une seule instruction, et qu'a l'inverse on enchaine les instructions sur un même objet, qui se transforme à chaque étape. Cette opérateur qui va vous sembler atypique au premier abord, va rapidement devenir votre meilleur ami. Il a été introduit dans le package magrittr, chargeons le dans l'environement de travail de façon à 


```r
`%>%` <- magrittr::`%>%`
```
L'opérateur pipe permet donc d'enchainter les instructions, ci dessous deux instruction équivalentes :

```r
x + 5 -3
```

```
##     x  y
## 1   3 23
## 2   4 24
## 3   5 25
## 4   6 26
## 5   7 27
## 6   8 28
## 7   9 29
## 8  10 30
## 9  11 31
## 10 12 32
```

```r
x %>% + 5 %>% -3
```

```
##     x  y
## 1   3 23
## 2   4 24
## 3   5 25
## 4   6 26
## 5   7 27
## 6   8 28
## 7   9 29
## 8  10 30
## 9  11 31
## 10 12 32
```

Le second élément, est la conceptualisation, proposée par le package `dplyr`, des différentes étapes clés de l'analyse de données dans un paradigme qui ressemble au langage sql et que vous connaissez peut être.  Ces principales étapes sont :

- `select` : pour sélectionner les colonnes des dataframes
- `filter` : pour filtrer les données
- `mutate` : qui n'existe pas en sql, et qui permet de modifier les colonnes d'un dataframe.
- `join` : pour réaliser les jointures entre dataframe
- `group_by` : pour réaliser des regroupements
- `summarise`: qui permet de faire des comptes sur l'ensemble des données, par exemple compter le nombre de lignes, cette calculs tenant compte des différents niveau déclarés dans le `group_by`.

Pour tester ces différentes fonction, commençons par charger des données PMSI avec le package `pmeasyr`.


