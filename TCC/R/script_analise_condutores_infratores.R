#carregando infratores
infratores <- read_csv("qtd_infracoes_por_condutores.csv")

n_breaks <- sqrt(nrow(infratores))

hist(infratores$multas, xlab="Multas", ylab="Frequência", breaks = n_breaks)

#Avaliando 99%
outlier_cutoff = quantile(infratores$multas,0.99)
index_outlier_ROT = which(infratores$multas>outlier_cutoff)
data_ROT = infratores[-index_outlier_ROT,]
hist(data_ROT$multas, main="Histograma de Multas", xlab="Multas")

#Avaliando outliers
index_outlier_ROT = which(infratores$multas<outlier_cutoff)
data_ROT = infratores[-index_outlier_ROT,]
hist(data_ROT$multas, main="Histograma de Multas", xlab="Multas")

data_ROT

