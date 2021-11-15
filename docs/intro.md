# Introduction

R est un langage de programmation ce qui signifie qu'il est une interface entre des instructions données par un utilisateur, dans une forme écrite, et les capacités de calcul de l'ordinateur.
Ces capacités sont très grandes dès lors que les instructions qui lui sont données peuvent être exécutées sans erreur, et c'est bien l'art de la programmation qui est de réussir à utiliser ces fonctionnalités sans erreur.
L'idée qui sous tend la création des langages tels que R est de simplifier le plus possible ces interactions, de façon à simplifier la vie des utilisateurs.
L'informatique peut permettre de résoudre de nombreux problèmes et R est un langage spécialisé dans le calcul statistique.
Ces dernières années, la perception de cette discipline a beaucoup évolué et en particulier avec l'avènement d'une vision peut être plus globale que le calcul statistique lui-même, celle de la science des données, qui inclut également de nombreuses étapes de traitement et préparation des données elles-mêmes et qui sont un préalable au calcul à proprement parler.
R a suivi ces évolutions avec le développement de package spécifiques qui sont venus enrichir l'architecture de base du langage et qui proposent une nouvelle façon d'écrire le code très influencée par l'idée que chaque projet est en fait l'exécution de tâches élémentaires successives qui s'enchaînent sous la forme d'une chaîne de traitement.
Nous allons voir dans les premiers chapitres de ce livre les éléments de base du langage et comment ces nouvelles méthodes de programmation peuvent être particulièrement adaptées à l'analyse des données PMSI.

Cette introduction à la programmation en R qui se veut la plus pragmatique possible, est exclusivement orienté vers l'analyse des données PMSI de façon à faire de R un de vos outils de travail directement opérationnel. Elle ne doit pas faire perdre de vue que toute personne qui souhaitera à l'issue de cette introduction s'engager dans l'utilisation de R sur le long terme, devra approfondir sa connaissance du langage afin de devenir complètement autonome.
La chance est qu'il existe 2 ouvrages de références qui vont permettront d'acquérir ces compétences :
- [R for Data Science](https://r4ds.had.co.nz/)
- [Advanced R](https://adv-r.hadley.nz) La lecture de ces livres nous apparaît indispensable et loin d'être insurmontable au contraire.
Cette introduction à R a pour objectif de vous donner l'envie d'aller plus loin.

## Les notions et concepts que vous aller acquérir

R est un language de programmation, ce qui veut dire que vous allez faire de la programmation.
Que cela n'inquiètes pas trop ceux qui n'en ont pas l'habitude, c'est au final assez simple.

R est un langage de programmation, ce qui veut dire que vous allez faire de la programmation.
Que cela n'inquiète pas trop ceux qui n'en ont pas l'habitude, c'est au final assez simple.


On peut classiquement séparer en 4 les étapes d'un projet d'analyse des données PMSI :

1- Importer les données. Pour nous cela repose essentiellement par l'utilisation du package [pmeasyr](https://github.com/GuillaumePressiat/pmeasyr), qui permet d'importer les fichiers officiels en entrée et sortie du logiciel GENRSA et qui sont donc utilisés par les établissements pour la transmission des données à l'ATIH. Il est souvent nécessaire pour bien exploiter les données PMSI d'utiliser des référentiels (CIM, CCAM, GHM,...).
La plupart des référentiels utiles sont regroupés dans le package [referime](https://github.com/NamikTaright/referime).Néanmoins d'autres types de données peuvent vous êtes utiles et nous couvrirons également le sujets de l'import des données dans d'autres format.

2- Préparer et transformer des données brute afin par exemple de créer de nouvelle variables qui nous permettent de répondre aux questions posées.

3- L’analyse de données elles-mêmes. Dans le cadre des projets PMSI c'est souvent la sélections de séjours et la réalisation de statistiques descriptives. Certains projets plus complexes nécessitent de faire de la modélisation.

4- Enfin, nous avons besoin de communiquer des résultats sous forme de données tabulées et de représentations graphiques.

Ce livre a pour objectif de vous donner les bases qui vous permettrons de réaliser ces 4 étapes.


