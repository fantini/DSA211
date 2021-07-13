# Instalando e carregando pacotes -----------------------------------------

pacotes <- c("plotly","tidyverse","knitr","kableExtra","PerformanceAnalytics",
             "factoextra","reshape2","psych","ggrepel")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Questao 1

load("rho_arquivo02.RData")

rho_arquivo02

rho_arquivo02 %>% 
  melt() %>% 
  ggplot() +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  geom_text(aes(x = Var1, y = Var2, label = round(x = value, digits = 3)),
            size = 4) +
  labs(x = NULL,
       y = NULL,
       fill = "Correlacoes") +
  scale_fill_gradient2(low = "dodgerblue4", 
                       mid = "white", 
                       high = "brown4",
                       midpoint = 0) +
  theme(panel.background = element_rect("white"),
        panel.grid = element_line("grey95"),
        panel.border = element_rect(NA),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 0))

cortest.bartlett(R = rho_arquivo02)

# Questao 2 e 3

load("rho_arquivo01.RData")

rho_aqruivo01

# Questo 4

load("pca_arquivo02.RData")

summary(pca_arquivo02)

# Extraindo as Cargas Fatoriais

k <- sum((pca_arquivo02$sdev ^ 2) > 1) 

cargas_fatoriais <- pca_arquivo02$rotation[, 1:k] %*% diag(pca_arquivo02$sdev[1:k])

#Visualizando as Comunalidades

data.frame(rowSums(cargas_fatoriais ^ 2)) %>%
  rename(comunalidades = 1) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

# Questao 5

k <- sum((pca_arquivo02$sdev ^ 2) > 1) 

cargas_fatoriais <- pca_arquivo02$rotation[, 1:k] %*% diag(pca_arquivo02$sdev[1:k])

# Visualizando as cargas fatoriais

data.frame(cargas_fatoriais) %>%
  rename(F1 = X1,
         F2 = X2) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

data.frame(pca_arquivo02$rotation) %>%
  mutate(var = names(pca_arquivo02$center[1:8])) %>% 
  melt(id.vars = "var") %>%
  mutate(var = factor(var)) %>%
  ggplot(aes(x = var, y = value, fill = var)) +
  geom_bar(stat = "identity", color = "black") +
  facet_wrap(~variable) +
  labs(x = NULL, y = NULL, fill = "Legenda:") +
  scale_fill_viridis_d() +
  theme_bw()

# Questao 6

load("pca_arquivo03.RData")

summary(pca_arquivo03)


# Questao 7


  
# Questao 8

load("pca_arquivo01.RData")

summary(pca_arquivo01)

k <- sum((pca_arquivo01$sdev ^ 2) > 1)

pca_arquivo01$sdev[1] ^ 2


# Questao 10

load("pca_arquivo02.RData")

summary(pca_arquivo02)

k <- sum((pca_arquivo02$sdev ^ 2) > 1) 

cargas_fatoriais <- pca_arquivo02$rotation[, 1:k] %*% diag(pca_arquivo02$sdev[1:k])

# Visualizando as cargas fatoriais

data.frame(cargas_fatoriais) %>%
  rename(F1 = X1,
         F2 = X2) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

data.frame(pca_arquivo02$rotation) %>%
  mutate(var = names(pca_arquivo02$center[1:8])) %>% 
  melt(id.vars = "var") %>%
  mutate(var = factor(var)) %>%
  ggplot(aes(x = var, y = value, fill = var)) +
  geom_bar(stat = "identity", color = "black") +
  facet_wrap(~variable) +
  labs(x = NULL, y = NULL, fill = "Legenda:") +
  scale_fill_viridis_d() +
  theme_bw()