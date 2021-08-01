# Pacotes a serem instalados e carregados ---------------------------------

#Pacotes utilizados
pacotes <- c("plotly","tidyverse","ggrepel","sjPlot","reshape2","knitr",
             "kableExtra","FactoMineR")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Questao 1: De acordo com o arquivo baixado, quantas dimensoes seriam
# necessarias para explicar a completude da inercia principal total dos dados?

load("anacor_arquivo02.RData")
anacor_arquivo02$call$ncp

# Questao 2: De acordo com o arquivo baixado, ao se adotar um mapa perceptual 
# tridimensional, aproximadamente, qual o percentual da inercia principal total
# seria explicado?

load("anacor_arquivo02.RData")
sum(anacor_arquivo02$eig[1:3,2])

# Questao 3: De acordo com o arquivo baixado, caso assumíssemos um mapa 
# perceptual bidimensional, qual seria, aproximadamente, o percentual da 
# inercia principal total explicado?

load("acm_arquivo01.RData")
sum(acm_arquivo01$eig[1:2,2])

# Questao 4: De acordo com o arquivo baixado, ao se adotar um mapa perceptual
# bidimensional, aproximadamente, qual o percentual da inercia principal total 
# seria explicado?

load("anacor_arquivo03.RData")
sum(anacor_arquivo03$eig[1:2,2])

# Questao 5: De acordo com o arquivo baixado, quantas dimensoes seriam 
# necessarias para explicar a completude da inercia principal total dos dados?

load("anacor_arquivo03.RData")
anacor_arquivo03$call$ncp

# Questao 6: De acordo com o arquivo baixado, respectivamente, as coordenadas 
# dos eixos das abcissas e das ordenadas para a categoria Universidades 
# Publicas Estaduais, são:

load("anacor_arquivo02.RData")
anacor_arquivo02$row$coord[3,]

# Questao 7: De acordo com o arquivo baixado, pode-se sugerir que as 
# intensidades maiores do sintoma “febre” (high fever) estao mais fortemente 
# associados a:

load("acm_arquivo02.RData")
acm_arquivo02

# Questao 8: De acordo com o arquivo baixado, pode-se dizer que as associacoes
# mais intensas (> 1,96) com o indicador CPC1, dar-se-ao para as:

load("anacor_arquivo01.RData")
anacor_arquivo01

# Questao 9: De acordo com o arquivo baixado, pode-se sugerir que as 
# intensidades maiores do sintoma “dores nas articulacoes” (intense arthralgia)
# estao mais fortemente associados a:

load("acm_arquivo02.RData")
acm_arquivo02

# Questao 10: De acordo com o arquivo baixado, pode-se sugerir que as 
# intensidades menores do sintoma “febre” (no fever e low fever) estao mais 
# fortemente associados a:

load("acm_arquivo02.RData")
acm_arquivo02
