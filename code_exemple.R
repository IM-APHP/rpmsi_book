
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
  summarise(nb = length(unique(nas)))
