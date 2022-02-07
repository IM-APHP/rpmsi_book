#########################################
#
# Utilisation d'une base de données locale
# pour l'analyse des données PMSI
#
#########################################

#Paramétrages
Sys.setenv(http_proxy="http://proxym-inter.aphp.fr:8080")
Sys.setenv(https_proxy="http://proxym-inter.aphp.fr:8080")
`%+%` <- function(x,y){paste0(x,y)}
`%>%` <- magrittr::`%>%`



#Installation de duckdb
install.packages("duckdb")

#Créer une connexion
#Définition du répertoire de travail
path_db <- "C:/data/duckdb/pmsi_test.duckdb"

#Parametrage de la connexion à la base de données
connection_db <- DBI::dbConnect(duckdb::duckdb(), path_db )

#Intégration des données PMSI dans la base de données avec duckdb
p <- pmeasyr::noyau_pmeasyr(
  finess   = '750712184',
  annee = 2021,
  mois     = 11,
  path     = 'D:/data/mco/202111',
  progress = F,
  tolower_names = T, # choix de noms de colonnes minuscules : T / F
  lib = F)

pmeasyr::db_mco_out(connection_db,  p,remove = F, zip = T) 
#purrr::quietly(pmeasyr::db_mco_out)(connection_db,  p,remove = F, zip = T) -> ok

pmeasyr::db_mco_in(connection_db,  p,remove = F, zip = T) 


struct <- referime::get_table("amurm_2021")
struct <- struct %>% dplyr::rename(cdurm = uma_ej) %>%
  dplyr::distinct(cdurm,.keep_all = T)

DBI::dbWriteTable(connection_db, "mco_21_ium",struct )

an = 21

dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_rsa")




dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_ano") %>% dplyr::select(nas,cle_rsa,dtent,dtsort,factam, pbcmu, motnofact, typecont )  %>%
  
  dplyr::inner_join( 
    # any_of parce que les vars d'eligibilite ne sont dans la table que pour 2021
    dplyr::tbl(connection_db, "mco_" %+% an %+% "_rsa_rsa") %>% dplyr::select(any_of(c('cle_rsa','noseqrum','anseqta','ansor','moissor','ghm','noghs','sexe',
                                                                                       'agean','agejr','echpmsi','prov','schpmsi','dest','nbrum','duree','cdgeo',
                                                                                       'ell_gradation','surveillance_particuliere','resererve_hosp','rescrit_tarifaire',
                                                                                       'cat_nb_intervenants'))) ,
    . ) %>% 
  
  #type de séjours
  dplyr::left_join( .,
                    dplyr::tbl( connection_db, "mco_" %+% an %+% "_rum_rum" ) %>%  
                      dplyr::left_join(.,  dplyr::tbl( connection_db, "mco_" %+% an %+% "_ium" ) %>%
                                         dplyr::select( gh, cdurm, typaut, mode_hospit, nohop, lib_hop, uma,lib_uma,
                                                        lib_cc9_uma,spe_uma,lib_spe_uma,
                                                        ua, lib_ua,lib_cc9_ua, spe_ua, lib_spe_ua,
                                                        serv,lib_service, pole, lib_pole) ) ) -> query

  
query %>% dplyr::show_query()

query %>% dplyr::collect() -> df
