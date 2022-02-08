`%+%` <- function(x,y){paste0(x,y)}
`%>%` <- magrittr::`%>%`

#Noyau de paramètre pmeasyr

# Définir le chemin générique des données
path_data = 'path/to/your/data/folder'
path_data = 'D:/data/mco/202111'

#Création d'un noyau de paramètres pmeasyr
p<-pmeasyr::noyau_pmeasyr(finess = 750712184, 
                          annee = 2021, 
                          mois = 11, 
                          path = path_data,
                          tolower_names = TRUE)



#Dizappge des fichiers out
pmeasyr::adezip(p,
                liste = c("rsa","tra","ano"), 
                type = "out")



#Import des rsa
pmeasyr::irsa(p,
    typi = 4 ) -> rsa21



#Dézippage des fichiers in
pmeasyr::adezip(p,
                liste = c("rss"), 
                type = "in")

#Import des rum
rum21<- pmeasyr::irum(p,
             typi = 4 )


#Import du fichier ano
rsa_ano <- pmeasyr::iano_mco(p)

#Import du TRA et ajout des infos établissements sur les rsa
pmeasyr::itra(p) -> tra

pmeasyr::inner_tra(rsa21$rsa, tra) -> rsa21$rsa
pmeasyr::inner_tra(rsa_ano, tra) -> rsa_ano



# Formats des fichiers sources
pmeasyr::formats 

pmeasyr::formats %>% View()

# Liste des variables pour la table RSA en 2021
pmeasyr::formats %>% dplyr::filter(table == "rsa", an == 21)%>% View()


# Le TRA dans les différents champs et les différentes années 
pmeasyr::formats %>% dplyr::filter(table == "tra") %>% 
  dplyr::group_by(champ,an) %>% dplyr::summarise(nb = dplyr::n() ) %>% View()

#exemple length(unique(x))

x = c(4,4,5,5,5,5,6,6,6)

length(x)

unique(x)

length(unique(x))


# Nombre d'années disponibles pour chaucn des champs avec visablisation du noms des tables importables
pmeasyr::formats %>% dplyr::group_by(champ,table) %>% 
  dplyr::summarise(nb_annee = length(unique(an))) %>% View()


#Récupérer des données avec référime

library(referime)

amurm21<- referime::get_table("amurm_2021")

View(amurm21)




#dms base nationales
dms_nationales <- referime::get_table("ghm_dms_nationales")

View(dms_nationales)



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

#2021 pas encore présente dans le fichier, on utilise 2020
dms_nationales %>% dplyr::filter(anseqta=="2020") %>%
  dplyr::mutate(anseqta = "2021") %>%
  dplyr::bind_rows(.,dms_nationales) -> dms_nationales




#Actes CCAM : icr, actes chriurgicaux
icr <- referime::get_table("ccam_icr") %>% dplyr::filter(activite  == 1)
ccam_rgp <- referime::get_table("ccam_regroupement") %>% dplyr::filter(activite  == 1, regroupement == "ADC")
acte_chir <- ccam_rgp %>% dplyr::select(code) %>% dplyr::inner_join(icr, by = c("code"))
cim <- referime::get_table("cim") %>%
  dplyr::distinct(code, .keep_all = TRUE) %>%
  dplyr::select(code,lib_court)

#Selectionner le dernier libellé disponible
cim <- referime::get_table("cim")%>% 
  dplyr::arrange(code,anseqta) %>%
  dplyr::group_by(code) %>%
  dplyr::filter(dplyr::row_number()==dplyr::n()) %>%
  dplyr::select(code,lib_court)

#Regroupements GHM
ghm_rgp <- referime::get_table('ghm_ghm_regroupement')

write.table(cim,file = "D:/data/cim.csv",sep=";",row.names = FALSE )
xlsx::write.xlsx(cim,file = "D:/data/cim.xlsx")

#http://referime.aphp.fr:8000/public/accueil.html

# Les jointures

?dplyr::left_join


#joiture ano,rsa,rum
data21 <- rsa_ano %>% dplyr::select(nas,cle_rsa,dtent,dtsort,factam, pbcmu, motnofact, typecont )  %>%
  dplyr::inner_join( .,
                     rsa21$rsa %>% dplyr::select(cle_rsa,noseqrum,anseqta,ansor,moissor,ghm,noghs,sexe,agean,
                                                 agejr,echpmsi,prov,schpmsi,dest,nbrum,duree)) 
data21 <- data21 %>%
  dplyr::left_join( .,
                    rum21$rum )

#Ajoutr des UMA

#utilisation de distinct

amurm21 %>% dplyr::rename(cdurm = uma_ej) %>%
  View()


amurm21 %>% dplyr::rename(cdurm = uma_ej) %>%
  dplyr::distinct(cdurm,.keep_all = T) %>%
  View()


data21 <- data21 %>%
  dplyr::left_join( .,
                    amurm21 %>%  dplyr::rename(cdurm = uma_ej) %>%
                      dplyr::distinct(cdurm,.keep_all = T) %>%
                      dplyr::select( gh, cdurm, typaut, mode_hospit, nohop, 
                                     lib_hop,lib_cc9_uma,spe_uma,lib_spe_uma) ) 


#Ajout des DMS de référence

data21<- data21 %>% dplyr::mutate(id = 1:nrow(data21))

data21_dms1<- dplyr::inner_join(data21 %>% dplyr::rename(ghs = noghs),
                                dms_nationales %>% dplyr::filter(ghs!="") %>% dplyr::distinct(anseqta,ghs,.keep_all = T) 
)

#Merge rsa, dms pour les cas ou la référence dans ghm_dms_nationales = ghm
data21_dms2<-inner_join(data21%>%rename(ghs = noghs),
                        dms_nationales%>%filter(ghs=="") %>% dplyr::select(-ghs) %>%  dplyr::distinct(anseqta,ghm,.keep_all = T)  )


data21_2 <- dplyr::bind_rows(data21_dms1,data21_dms2)
data21 <- dplyr::bind_rows(data21_2, data21 %>% dplyr::filter(! id %in% c(data21_dms1$id,data21_dms2$id) ) )

rm(data21_dms1,data21_dms2,data21_2) 
                   