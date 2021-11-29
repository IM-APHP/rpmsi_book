## Exemple de création d'un objet avec R
x <- 1:10
x


##Calcul vectorisés
x+5


## Les différentes façon de connaître le type d'un objet
str(x)
class(x)
typeof(x)

# Trouver la taille d'un vecteur
length(x)

#Créer un dataframe
x <- data.frame( x = 1:10, y = 21:30, colonne1 = 31:40 )

#Type d'objets
str(x)
class(x)
typeof(x)

#Nom des colonnes
names(x)

#Accéder aux données élémentaires
line_number = 1
columun_number = 2
x[line_number , columun_number]

#Noms des lignes et des colonnes
names(x)
row.names(x)

#Accéder aux données élémentaires par les noms des dimensions
line_name = "1"
columun_name = "x"
x[line_name , columun_name]

#Sélectionner une colonne 
x$x

# Ajouter 5 à la première colonne
x$x + 5


#Utiliser le pipe
`%>%` <- magrittr::`%>%`

x + 5 -3

x %>% + 5 %>% -3



#Dézippage des RUM groupés (nommés RSS dans les outils ATIH)
pmeasyr::adezip(finess = 750712184, 
                annee = 2021, 
                mois = 8, 
                path = 'C:/Users/3056269/Documents/data/mco', 
                liste = c("rss"), 
                type = "in")


#Import des RUM groupés (nommés RSS dans les outils ATIH)
pmeasyr::irum(finess = 750712184, 
              annee = 2021, 
              mois = 8, 
              path = 'C:/Users/3056269/Documents/data/mco', 
              typi = 4, 
              tolower_names = TRUE ) -> rum21
typeof(rum21)
names(rum21)

library(dplyr)

rum21$rum %>% filter(dp == "I10")

rum21$rum %>% filter(dp == "I10") %>%
  mutate(moissor = format(d8soue,"%m")  )%>%
  select(nas,moissor)


#Nobmre de séjours par mois dont le diagnostic princial est I10
rum21$rum %>% dplyr::filter(dp == "I10") %>%
  mutate(moissor = format(d8soue,"%m")  ) %>%
  group_by(moissor) %>%
  summarise(nb = n())



# Création d'un tableau avec les dates de séjours
dates_sejours <- rum21$rum %>% 
  group_by(nas) %>%
  summarise(dtentr = min(d8eeue),
            dtsor = max(d8soue)) %>%
  ungroup()


#Compter le nombre de séjours
rum21$rum %>% dplyr::filter(dp == "I10") %>%
  left_join(.,dates_sejours) %>%
  mutate(moissor = format(dtsor,"%m")  ) %>%
  group_by(moissor) %>%
  summarise(nb = n())

#Rechercher I10 dans les DAS
rum21$das %>% dplyr::filter(das == "I10") -> das_i10

rum21$rum %>% dplyr::filter(dp == "I10" | nas %in% das_i10$nas ) %>%
  left_join(.,dates_sejours) %>%
  mutate(moissor = format(dtsor,"%m")  ) %>%
  group_by(moissor) %>%
  summarise(nb = length(unique(nas)))


rum21$rum %>% dplyr::filter(dp == "I10" | nas %in% das_i10$nas, 
                            substr(cdresi,1,2) == "75" ) %>%
  left_join(.,dates_sejours) %>%
  mutate(moissor = format(dtsor,"%m")  ) %>%
  group_by(moissor) %>%
  summarise(nb = length(unique(nas)))


#Charger Référime
devtools::install_github('https://github.com/NamikTaright/referime.git')
