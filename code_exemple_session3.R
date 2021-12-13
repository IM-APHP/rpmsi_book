rum21$rum %>% dplyr::filter(das!= "") %>% dplyr::select(nas,dp,dr,das)

diags = c("U0711","U0712","U0714","U0715")
rum21$rum %>% dplyr::filter(dp %in% diags) %>% dplyr::select(nas,dp,dr,das)

rum21$rum %>% dplyr::filter(dp %in% diags| dr %in% diags ) %>% dplyr::select(nas,dp,dr,das)