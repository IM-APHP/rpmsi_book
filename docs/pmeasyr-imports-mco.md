# pmeasyr : Imports MCO



## Les différents fichiers à importer 
|Nom       |Fonction                           |
|:---------|:----------------------------------|
|[irsa](https://guillaumepressiat.github.io/pmeasyr/reference/irsa.html)      |~ MCO - Import des RSA             |
|[irum](https://guillaumepressiat.github.io/pmeasyr/reference/irum.html)      |~ MCO - Import des RUM             |
|[idiap](https://guillaumepressiat.github.io/pmeasyr/reference/idiap.html)     |~ MCO - Import des DIAP            |
|[idmi_mco](https://guillaumepressiat.github.io/pmeasyr/reference/idmi_mco.html)  |~ MCO - Import des DMI             |
|[iium](https://guillaumepressiat.github.io/pmeasyr/reference/iium.html)      |~ MCO - Import des donnees UM      |
|[ileg_mco](https://guillaumepressiat.github.io/pmeasyr/reference/ileg_mco.html)  |~ MCO - Import des erreurs Leg     |
|[imed_mco](https://guillaumepressiat.github.io/pmeasyr/reference/imed_mco.html)  |~ MCO - Import des Med             |
|[ipo](https://guillaumepressiat.github.io/pmeasyr/reference/ipo.html)       |~ MCO - Import des PO              |
|[iano_mco](https://guillaumepressiat.github.io/pmeasyr/reference/iano_mco.html)  |~ MCO - Import des Anohosp         |

Source : [pmeasyr-book](https://guillaumepressiat.github.io/pmeasyr-book/import-des-donn%C3%A9es.html#mco)

## Noyau pmeasyr

Comme les différents paramètres permettant à ```pmeasyr``` de réaliser l'import (et en particulier de retrouver le bon fichier zipper sur le disque) sont réutilisés plusieurs fois, nous pouvons créer un objet ```pmeasyr``` destiné à stocker toutes ces informarions, appelé, noyau :


```r
path_data = 'path/to/your/data/folder'

p<-pmeasyr::noyau_pmeasyr(finess = 750712184, 
                          annee = 2021, 
                          mois = 8, 
                          path = path_data,
                          tolower_names = TRUE)
```
## Imports des RSA

 Type|Import                                                                               |
|----:|:------------------------------------------------------------------------------------|
|    1|Light      : Partie fixe                                                             |
|    2|Light+     : Partie fixe + stream en ligne (+) actes et das                          |
|    3|Light++    : Partie fixe + stream en ligne (++) actes, das, typaut um et dpdr des um |
|    4|Standard   : Partie fixe + creation des tables actes, das et rsa_um                  |
|    5|Standard+  : Partie fixe + creation des tables actes, das et rsa_um + stream (+)     |
|    6|Standard++ : Partie fixe + creation des tables actes, das et rsa_um + stream (++)    |

Source : [pmeasyr-book](https://guillaumepressiat.github.io/pmeasyr-book/import-des-donn%C3%A9es.html#mco)


```r
pmeasyr::adezip(p,
                liste = c("rsa","tra"), 
                type = "out")

pmeasyr::irsa(p,
    typi = 4,
    tolower_names = TRUE ) -> rsa21
```

## Import des RUM

| Type|Import                                                          |
|----:|:---------------------------------------------------------------|
|    1|XLight    : Partie fixe                                         |
|    2|Light     : Partie fixe + stream en ligne des actes, das et dad |
|    3|Standard  : Partie fixe + table actes, das, dad                 |
|    4|Standard+ : Partie fixe + stream + table actes, das, dad        |

Source : [pmeasyr-book](https://guillaumepressiat.github.io/pmeasyr-book/import-des-donn%C3%A9es.html#mco)



```r
pmeasyr::adezip(p,
                liste = c("rss"), 
                type = "in")

rum21<- pmeasyr::irum(p,
             typi = 4,
             tolower_names = TRUE )
```


## Import des fichiers TRA et ANO

Le fichier TRA est un fichier du out qui permet de relier les données anonymes du out aux données du in.

Il comprend un lien entre :

- clé rsa,
- numéro de rss, 
- numéro de sejour (nas),
- date d’entrée
- date de sortie du séjour

L'import se fait en 2 parties : import du fichier avec la fonction ```itra```, ajout des colonnes dans la table des rsa ```inner_tra``` .

Le fichier ANO contient les données de l'ANOHSP, on utilise ici les ano du out auquel il faut ajouter également les élements du TRA.

```r
pmeasyr::itra(p) -> tra
pmeasyr::iano_mco(p) -> rsa_ano 

pmeasyr::inner_tra(rsa15$rsa, tra) -> rsa15$rsa
pmeasyr::inner_tra(rsa_ano, tra) -> rsa_ano
```


## Table pmeasyr des formats

Les fonctions d'import de ```pmeasyr``` utilisent les formats officiels défini par l'ATIH pour constituer les fichiers qui seront mis en entrées et sortie des logiciels développés par l'agence et qui permettront l'échange de données ([formats officiels](https://www.atih.sante.fr/formats-pmsi-2021) des données en entrée des logiciels permettant la transmission).

C'est format sont stockés dans le package sous la forme d'un table de format accèssible aux utilisateurs

```r
pmeasyr::formats 

pmeasyr::formats %>% View()
```
La fonction ```View()``` permet d'accéder à un visionneur de code

**Liste des variables pour la table RSA en 2021**

```r
pmeasyr::formats %>% dplyr::filter(table == rsa, an == 21)
```

**Le TRA dans les différents champs et les différentes années **

Remarquez l'utilisation de la fonction ```dplyr::n()``` qui permet de compter le nombre de ligne dans un dataframe 

```r
pmeasyr::formats %>% dplyr::filter(table == "tra") %>% 
  dplyr::group_by(champ,an) %>% dplyr::summarise(nb = dplyr::n() ) %>% View()
```

**Nombre d'années disponibles pour chaucn des champs avec visablisation du noms des tables importables**

Pour compter le nombre d'éléments distinct dans un vecteur, on utilise les fonctions ```length()``` et ```unique()``` .


```r
#exemple length(unique(x))

x = c(4,4,5,5,5,5,6,6,6)

length(x)

unique(x)

length(unique(x))
```


Mise en application pour compter le nombre d'années disponibles par champ et par table

```r
pmeasyr::formats %>% dplyr::group_by(champ,table) %>% 
  dplyr::summarise(nb_annee = length(unique(an))) %>% View()
```

NB: on voit qu'un package peut contenir à la fois des fonctions et des jeux de données. C'est le cas ici avec la table ```formats``` qui contient des données de parmatrage.

### Récupérer des référentiels sur referime

Le package [referime](https://github.com/NamikTaright/referime) maintenu par Namik Taright alimente le serveur de référentiels du DIM de l'AP-HP. Il est  à la base d'un webservice utilisé par différents entités de l'institution pour accéder aux référentiels PMSI. Il contient de nombreux fichiers de références utiles pour l'analyse des données PMSI.

### Fichier descriptif des UMA sur referime

Le fichier AMURM est maintenu par le DIM du siège et comprend de nombreuses données utiles sur les UM. Dans sa forme actuelle il comprend également les UA qui sont le niveau en dessous de l'UMA. Dans la mesure où il peut y avoir plusieurs UA par UMA, il peut contenir plusieurs lignes pour une seule UMA. 


```r
library(referime)

amurm21<- referime::get_table("amurm_2021")

View(amurm21)
```



#### DMS de la base nationale

La colonne ```anseqta``` contient l'information sur l'année de version du tarif. Elle comprend :

- les séjours de l'année n à partir du 1er mars 
- les séjours de l'année n+1 jusqu'au 28/29 février




```r
#dms base nationales
dms_nationales <- referime::get_table("ghm_dms_nationales")

View(dms_nationales)
```

Attention, par construction le calcul des dms sur la base nationale ne peut être en cours d'année, pour l'année en cours on se contente d'utiliser les dms calculées sur l'année précédente. Pour cela on utilise la fonction ```dplyr::bind_rows``` qui permet de concaténer des dataframes par lignes (sont équivalant par colonne est ```dplyr::bind_cols``` ).

Exemple d'utilisation de 


```r
#Exemple de fusion de 2 jeux de données qui n'ont pas les mêmes colonnes
dplyr::bind_rows(
  
  dms_nationales %>% dplyr::filter( anseqta=="2020", !is.na(ghm) ) %>% 
    dplyr::select( anseqta, dms_n, ghm ),
  
  dms_nationales %>% dplyr::filter( anseqta=="2020", !is.na(ghs), ghs!="" ) %>% 
    dplyr::select( anseqta, dms_n, ghs )
  
) -> test

test

test %>% dplyr::filter(!is.na(ghm))


test %>% dplyr::filter(!is.na(ghs))
```

Application pour créer une table de référentiel base nationale complète.


```r
#2021 pas encore présente dans le fichier, on utilise 2020
dms_nationales<- dms_nationales %>% dplyr::filter(anseqta=="2020") %>%
  dplyr::mutate(anseqta = "2021") %>%
  dplyr::bind_rows(dms_nationales,.)
```

NB : les fonctions ```dplyr``` sont plus souples que les fonctions natives de R et elles tolèrent que les 2 dataframes n'aient pas exactement le même nombre de colonnes. Dans ce cas, elles créent des colonnes vides pour les colones qui pouraient manquer dans l'un des 2 dataframe.



#### Autres références utiles

```r
#Actes CCAM : icr, actes chriurgicaux
icr <- referime::get_table("ccam_icr") %>% filter(activite  == 1)
rgp <- referime::get_table("ccam_regroupement") %>% filter(activite  == 1, regroupement == "ADC")
acte_chir <- rgp %>% select(code) %>% inner_join(icr, by = c("code"))
cim <- referime::get_table("cim") %>%
  dplyr::distinct(code,.keep_all = TRUE) %>%
  dplyr::select(code,lib_court)
#Regroupements GHM
regroupement <- referime::get_table('ghm_ghm_regroupement')
```


## Création d'une table contenant la plus part des informations utiles

Les données du in et out GENRSA ont chacune leur utilité, mais elles sont en partie redondantes. Afin de mieux s'y retrouver nous vous proposons de créer une table pivot constutée par la jointure de plusieurs tables et qui contiendra les principales données utiles pour l'analyse de l'activité.

Quelques détails sur les foncitons de jointure


```r
?dplyr::left_join
```

Nous utilsons les fonctions de jointure pour fusionner les tables ano, rsa, rum et amurm sans déclarer les colonnes qui permettront la jointure dans le ```by```.

```r
data21 <- rsa_ano %>% dplyr::select(nas,cle_rsa,dtent,dtsort,factam, pbcmu, motnofact, typecont )  %>%
  dplyr::inner_join( .,
                     rsa21$rsa %>% dplyr::select(cle_rsa,noseqrum,anseqta,ansor,moissor,ghm,noghs,sexe,agean,
                                                 agejr,echpmsi,prov,schpmsi,dest,nbrum,duree)) 
data21 <- data21 %>%
  dplyr::left_join( .,
                    rum21$rum )
```

Danslce fichier  ```amurm``` les UMA entité juridique sont dénommées ```uma_ej``` alors que dans le nom de cette variable importée avec ```pmeasyr``` est ```cdurm``` . On change le nom de la variable avant la fusion des tables.

Par ailleurs comme on souhaite une seule ligne par UMA on procède à un déboulonnage. On utilise ici la fonction ```dplyr::distinct```

```r
amurm21 %>% dplyr::rename(cdurm = uma_ej) %>%
  View()
```

Ecrite comme cela l'ensemble des colonnes de la table sont supprimées. On ajoute ```.keep_all = T```


```r
amurm21 %>% dplyr::rename(cdurm = uma_ej) %>%
  dplyr::distinct(cdurm,.keep_all = T) %>%
  View()
```

On utilise cette nouvelle table dans la jointure, en ne slectionnant que les colonnes qui nous interessent


```r
data21 <- data21 %>%
  dplyr::left_join( .,
                    amurm21 %>%  dplyr::rename(cdurm = uma_ej) %>%
                      dplyr::distinct(cdurm,.keep_all = T) %>%
                      dplyr::select( gh, cdurm, typaut, mode_hospit, nohop, 
                                     lib_hop,lib_cc9_uma,spe_uma,lib_spe_uma) ) 
```

**Ajout des dms dans la base nationale** : Attention jointure complexe car les dms de la base nationale sont préférentiellement calculées au niveau GHS mais dans certain cas également au niveau GHM (soins pallialits par exemple). Enfin les DMS ne sont pas calculées pour tous les GHM (séances par exemple). Au final on procède en 3 étapes :

- table intermédaire 1 résultat de l'appariement des rum avec la table de référence sur le GHM
- table intermédaire 2 résultat de l'appariement des rum avec la table de référence sur le GHS
- ajout des séjours n'appartenant à aucune des 2 tables ci dessus



```r
#ajout d'une indicatrice pour repréer les lignes de la table iniatale
data21<- data21 %>% dplyr::mutate(id = 1:nrow(data21))

#Merge rsa, dms pour les cas ou la référence dans ghm_dms_nationales = ghm
data21_dms1<- dplyr::inner_join(data21 %>% dplyr::rename(ghs = noghs),
                                dms_nationales %>% dplyr::filter(ghs!="", !is.na(ghs)) %>% dplyr::distinct(anseqta,ghs,.keep_all = T) 
)

#Merge rsa, dms pour les cas ou la référence dans ghm_dms_nationales = ghm
data21_dms2<-inner_join(data21%>%rename(ghs = noghs),
                        dms_nationales%>%filter(ghs=="") %>% dplyr::select(-ghs) %>%  dplyr::distinct(anseqta,ghm,.keep_all = T)  )


data21_2 <- dplyr::bind_rows(data21_dms1,data21_dms2)
data21 <- dplyr::bind_rows(data21_2, data21 %>% dplyr::filter(! id %in% c(data21_dms1$id,data21_dms2$id) ) )

rm(data21_dms1,data21_dms2,data21_2) 
```
