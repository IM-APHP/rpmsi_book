# pmeasyr : Imports MCO dans une base de données

Les données PMSI étant par nature volumineuses, il est parfois difficile de travailler avec des logiciels tels que R qui stockent les données dans la mémoire RAM de la machine. Une solution est d'utiliser des logiciels de bases de données qui permettent de stocker les données sur le disque dur et offre des solutions de requêtage optimiséees. Il existent de nombreux logiciels de gestion de bases de données, dont certains sont à la fois très simples à installer un ordinateur de bureau et facilement interfaçable avec R. Nous verrons dans ce chapitre une des solutions possibles [duckdb](https://duckdb.org/).

En règle générale ces logiciels utilisent le language de requête SQL. Mais afin de garantir une unité de la programmation avec R, les développeurs de la librarie ```dplyr``` ont prévu des interfaces entre R et le language SQL. On peut donc utiliser un de ces logiciels de base de données sans programmer en SQL en utilisant uniquement avec la librarie ```dplyr``` . Par ailleurs, le package ```pmeasyr``` propose des fonctions qui permettent d'importer les données dans la base de données, ce qui simplifie encore l'utilisation pour l'analyse de données PMSI volumineuses.

**A lire** : [une très courte introduction aux requêtes avec duckdb](https://guillaumepressiat.github.io/blog/2019/10/duckdb) par Guillaume Pressiat. 

En pratique, on utilise le package DBI, qui permet de se connecter en R à de nombreux logiciels de base de données, et qui est installé par défaut avec ```dplyr``` , et la package ```duckdb``` qui permet d'installer directement avec R à la fois l'application ```duckdb``` et le pilote de connexion R qui sera utilisé par ```DBI```. 

### Installation de la librarie duckdb pour R

```r
install.packages("duckdb")

# Chargement des packages et fonctions utiles
library(pmeasyr)
library(duckdb)
library(referime)
```

Une base duckdb correspond à un fichier unique dont on déclare le chemin 

### Création d'une connexion

```r
#Définition du répertoire de travail
path_db <- "D:/data/duckdb/pmsi_test.duckdb"

#Parametrage de la connexion à la base de données
connection_db <- DBI::dbConnect(duckdb::duckdb(), path_db )
```


### Imports pmeaysr


```r
# noyau pmeasyr

p <- pmeasyr::noyau_pmeasyr(
  finess   = '750712184',
  annee = 2021,
  mois     = 11,
  path     = 'D:/data/mco/202111',
  progress = F,
  tolower_names = T, # choix de noms de colonnes minuscules : T / F
  lib = F)
```


Les fonctions ```pmeasyr::db_mco_out``` et ```pmeasyr::db_mco_in``` permettent d'importer les principales tables à partir des fichiers de remontée.


```r
pmeasyr::db_mco_out(connection_db,  p,remove = F, zip = T) 

pmeasyr::db_mco_in(connection_db,  p,remove = F, zip = T) 
```

Importer des informations sur les strcutures à partir de referime (tables amurm)

```r
struct <- referime::get_table("amurm_2021")
struct <- struct %>% dplyr::rename(cdurm = uma_ej) %>%
  dplyr::distinct(cdurm,.keep_all = T)

DBI::dbWriteTable(connection_db, "mco_21_ium",struct )
```

Visualiser le contenu de la table mco_21_rsa_rsa

```r
an = 21
dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_rsa")
```

Pour l'instant les données restent dans la base de données et ne sont pas importer dans la mémoire comme traditionnellement en R. Les opération classique en SQL sont possible:

- sélection des colonnes (clause SELECT en SQL) avec ```dplyr::select```
- appliquer des critères de sélection sur les données (clause WHERE en SQL) avec ```dplyr::filter```
- réaliser des jointure entre les tables (fonction JOIN en SQL) avec ```dplyr::inner_join```  , ```dplyr::left_join```,```dplyr::right_join```,```dplyr::full_join```

### Création d'une requêtes complexe

Exemple de requêtes complexe utilisée dans le projet Tableau de bord fluidité des parcours

```r
dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_ano") %>% dplyr::select(nas,cle_rsa,dtent,dtsort,factam, pbcmu, motnofact, typecont )  %>%
  
  dplyr::inner_join( 
    # any_of parce que les vars d'eligibilite ne sont dans la table que pour 2021
    dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_rsa") %>%
      dplyr::select(any_of(c('cle_rsa','noseqrum','anseqta','ansor','moissor','ghm','noghs','sexe',
                                                                                       'agean','agejr','echpmsi','prov','schpmsi','dest','nbrum','duree','cdgeo',
                                                                                       'ell_gradation','surveillance_particuliere','resererve_hosp','rescrit_tarifaire',
                                                                                       'cat_nb_intervenants'))) ,
    . ) %>% 
  
  #type de séjours
  dplyr::left_join( .,
                    dplyr::tbl( connection_db, "mco_" %+% an %+% "_rum_rum" ) %>%  
                      dplyr::left_join(.,  dplyr::tbl( connection_db, "mco_" %+% an %+% "_ium" ) %>%
                                         dplyr::select( gh, cdurm, typaut, mode_hospit, nohop, lib_hop, uma,lib_uma, lib_cc9_uma,spe_uma,lib_spe_uma,
                                                        ua, lib_ua,lib_cc9_ua, spe_ua, lib_spe_ua, serv,lib_service, pole, lib_pole) ) ) -> query
```

En pratique l'ensemble de ce code est transcodé en SQL par ```dplyr``` et envoyé à la base de données. 
A ce stade le code SQL qui est "testé" sur la base duckdb mais les données ne sont pas importées dans R. 

On peut visualiser le code SQL généré avec la fonction ```dplyr::show_query()```


```r
query %>% dplyr::show_query()
```

Afin de faire des calcul plus complexes, nous devons importer les données dans R, cette opération est réalisée avec la fonction ```dplyr::collect``` .  


```r
df <- query %>% dplyr::collect()
```
