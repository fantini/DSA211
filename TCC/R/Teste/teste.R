########################################
#
#   CHAMANDO BIBLIOTECAS IMPORTANTES
#
########################################

library(tidyverse) #pacote para manipulacao de dados
library(cluster) #algoritmo de cluster
library(dendextend) #compara dendogramas
library(factoextra) #algoritmo de cluster e visualizacao
library(fpc) #algoritmo de cluster e visualizacao
library(gridExtra) #para a funcao grid arrange
library(readxl)

#Carregar base de dados: 
examinadores <- as.data.frame(read_csv("examinadores_by_resultado.csv"))
rownames(examinadores) <- examinadores[,1]
examinadores <- examinadores[,-1]

#Padronizar variaveis
examinadores.padronizado <- scale(examinadores)

########################################
#
#    CLUSTER NAO HIERARQUICO - Examinadores
#
########################################

#AGRUPANDO Examinadores PELO METODO NAO HIERARQUICO

#Rodar o modelo
examinadores.k2 <- kmeans(examinadores.padronizado, centers = 2)

#Visualizar os clusters
fviz_cluster(examinadores.k3, data = examinadores.padronizado, main = "Cluster K2")

#Criar clusters
examinadores.k3 <- kmeans(examinadores.padronizado, centers = 3)
examinadores.k4 <- kmeans(examinadores.padronizado, centers = 4)
examinadores.k5 <- kmeans(examinadores.padronizado, centers = 5)

#Criar graficos
G1 <- fviz_cluster(examinadores.k2, geom = "point", data = examinadores.padronizado) + ggtitle("k = 2")
G2 <- fviz_cluster(examinadores.k3, geom = "point",  data = examinadores.padronizado) + ggtitle("k = 3")
G3 <- fviz_cluster(examinadores.k4, geom = "point",  data = examinadores.padronizado) + ggtitle("k = 4")
G4 <- fviz_cluster(examinadores.k5, geom = "point",  data = examinadores.padronizado) + ggtitle("k = 5")

#Imprimir graficos na mesma tela
grid.arrange(G1, G2, G3, G4, nrow = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(examinadores.padronizado, kmeans, method = "wss")

fviz_cluster(examinadores.k3, geom = "point",  data = examinadores.padronizado) + ggtitle("k = 3")

