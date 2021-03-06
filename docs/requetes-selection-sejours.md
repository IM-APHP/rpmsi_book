# pmeasyr : Imports MCO dans une base de données

## Les variables diagnosctics dans la table RUM

- DP
- DR
- DAS


```r
rum21$rum %>% dplyr::filter(das!= "") %>% dplyr::select(nas,dp,dr,das)
```

Requête dans les diagnostics principaux

```r
diags = c("U0711","U0712","U0714","U0715")
rum21$rum %>% dplyr::filter(dp %in% diags) %>% dplyr::select(nas,dp,dr,das)

rum21$rum %>% dplyr::filter(dp %in% diags| dr %in% diags ) %>% dplyr::select(nas,dp,dr,das)
```
Requete dans les diagnostics associés : 

la fonction ```grepl``` de rechercher d'une chaine de caractères dans une autre chaine de caractères (ex un mot dans une phrase)

```r
grepl("Patrick", "Patrick mange du poulet")
```

On peut rechercher plusieurs chaines de caracètères différentes à l'aide du pipe (|)

```r
grepl("Patrick|Paul", "Patrick mange du poulet")
```

Aplliquée sur le format des diagnostcs associés 

```r
diags = c("U0711","U0712","U0714","U0715")
diags = "U0711|U0712|U0714|U0715"

%>% filter(grepl(diags, dpdrum)|grepl(diags, das))
```


## La table diagnostics des RUM



*** A noter *** type de diagnostics dans la table ```rsa$diag``` :

- 1 = DP du séjour
- 2 = DR du séjour
- 3 = DP des UM
- 4 = DR des UM
- 5 = DA
