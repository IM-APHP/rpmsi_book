Sys.setenv(http_proxy="http://proxym-inter.aphp.fr:8080")
Sys.setenv(https_proxy="http://proxym-inter.aphp.fr:8080")

install.packages("tidyverse")
install.packages("remotes")
remotes::install_github('guillaumepressiat/pmeasyr')

#devtools::install_github('https://github.com/NamikTaright/referime.git')
remotes::install_github('https://github.com/NamikTaright/referime.git')
