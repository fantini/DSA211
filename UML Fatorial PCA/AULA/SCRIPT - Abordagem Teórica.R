
# Instalando e carregando pacotes -----------------------------------------

pacotes <- c("tidyverse","knitr","kableExtra","car","rgl","gridExtra",
             "PerformanceAnalytics","reshape2","rayshader","psych","pracma",
             "polynom","rqPen","ggrepel")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}


# Abordagem Teórica -------------------------------------------------------

# Carregando a base de dados
load("notasfatorial.RData")

# Apresentando a base de dados:
notasfatorial %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

# Para facilitar, vamos considerar apenas 3 variáveis: as notas da disciplina
# de finanças; as notas da disciplina de custos; e as notas da disciplina de
# marketing.

scatter3d(notas_financas ~ notas_custos + notas_marketing, 
          data = notasfatorial, 
          surface = FALSE, 
          point.col = "dodgerblue4",
          axis.col = rep(x = "black", 
                         times = 3),
          bg.col = "white")

# Consideramos apenas 3 variáveis e a análise já não é das mais fáceis, certo?
# Vamos tentar observá-las duas a duas.


# A) Notas da Disciplina de Custos x Notas da Disciplina de Finanças
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_financas, y = notas_custos), 
             color = "dodgerblue4",
             size = 2) +
  labs(x = "Notas da Disciplina de Finanças",
       y = "Notas da Disciplina de Custos") +
  theme_bw()

# Notaram a tendência linear? Se não, olhem a seguir:
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_financas, y = notas_custos), 
             color = "dodgerblue4",
             size = 2) +
  geom_smooth(aes(x = notas_financas, y = notas_custos),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Finanças",
       y = "Notas da Disciplina de Custos") +
  theme_bw()


# B) Notas da Disciplina de Marketing x Notas da Disciplina de Custos
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_custos, y = notas_marketing), 
             color = "dodgerblue4",
             size = 2) +
  labs(x = "Notas da Disciplina de Custos",
       y = "Notas da Disciplina de Marketing") +
  theme_bw()

# Há alguma tendência linear facilmente identificável? Vejamos:
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_custos, y = notas_marketing), 
             color = "dodgerblue4",
             size = 2) +
  geom_smooth(aes(x = notas_custos, y = notas_marketing),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Custos",
       y = "Notas da Disciplina de Marketing") +
  theme_bw()


# C) Notas da Disciplina de Finanças x Notas da Disciplina de Marketing
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_marketing, y = notas_financas), 
             color = "dodgerblue4",
             size = 2) +
  labs(x = "Notas da Disciplina de Marketing",
       y = "Notas da Disciplina de Finanças") +
  theme_bw()

# E dessa vez, você consegue visualizar alguma tendência linear?
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_marketing, y = notas_financas), 
             color = "dodgerblue4",
             size = 2) +
  geom_smooth(aes(x = notas_marketing, y = notas_financas),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Marketing",
       y = "Notas da Disciplina de Finanças") +
  theme_bw()

# Vamos salvar tudo e observar as relações estudadas em cojunto:

# Salvando o gráfico das Notas da Disciplina de Custos x Notas da Disciplina 
# de Finanças
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_financas, y = notas_custos), 
             color = "dodgerblue4",
             size = 2) +
  geom_smooth(aes(x = notas_financas, y = notas_custos),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Finanças",
       y = "Notas da Disciplina de Custos") +
  theme_bw() -> A

# Salvando o gráfico das Notas da Disciplina de Marketing x Notas da 
# Disciplina de Custos
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_custos, y = notas_marketing), 
             color = "dodgerblue4",
             size = 2,
             shape = 17) +
  geom_smooth(aes(x = notas_custos, y = notas_marketing),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Custos",
       y = "Notas da Disciplina de Marketing") +
  theme_bw() -> B

# Salvando o gráfico das Notas da Disciplina de Finanças x Notas da 
# Disciplina de Marketing
notasfatorial %>% 
  ggplot() +
  geom_point(aes(x = notas_marketing, y = notas_financas), 
             color = "dodgerblue4",
             size = 2,
             shape = 15) +
  geom_smooth(aes(x = notas_marketing, y = notas_financas),
              color = "darkgoldenrod3", 
              method = "lm", 
              formula = y ~ x, 
              se = FALSE,
              size = 1.2) +
  labs(x = "Notas da Disciplina de Marketing",
       y = "Notas da Disciplina de Finanças") +
  theme_bw() -> C

# Juntando tudo:
grid.arrange(A, B, C) # acione o zoom para uma melhor visualização

# A quais conclusões preliminares podemos chegar?

# número máximo de fatores para extração = número de variáveis
# relação linear positiva entre custos e finanças
# identificados 2 fatores a principio (marketing e custos x finanças)

# Como saber quando existe a possibilidade de se utilizar uma PCA?

# O primeiro passo é a construção da matriz de correlações (rho). Feito isso,
# a literatura costuma mencionar 3 métodos principais para responder à 
# pergunta acima: 1) a estatística Kaiser-Meyer-Olkin (KMO); 2) o alpha de 
# Cronbach; e 3) o teste de esfericidade de Bartlett.


# Salvando a Matriz de Correlações -----------------------------------
rho <- cor(notasfatorial[,2:5])

# Observando as correlações entre variáveis
chart.Correlation(notasfatorial[,2:5])

# Construindo um mapa de calor a partir das correlações
rho %>% 
  melt() %>% 
  ggplot() +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  geom_text(aes(x = Var1, y = Var2, label = round(x = value, digits = 3)),
            size = 4) +
  labs(x = NULL,
       y = NULL,
       fill = "Correlações") +
  scale_fill_gradient2(low = "dodgerblue4", 
                       mid = "white", 
                       high = "brown4",
                       midpoint = 0) +
  theme(panel.background = element_rect("white"),
        panel.grid = element_line("grey95"),
        panel.border = element_rect(NA),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 0))

# Construindo um mapa de calor 3D a partir das correlações

# Primeiro passo: salvando o mapa de calor 2D
plot3d_rho <- rho %>% 
  melt() %>% 
  ggplot() +
  geom_tile(aes(x = Var1, y = Var2, fill = value, color = value),
            color = "black") +
  labs(x = NULL,
       y = NULL) +
  viridis::scale_fill_viridis("Correlações") +
  theme(axis.text = element_text(size = 12),
        title = element_text(size = 12,face = "bold"),
        panel.border= element_rect(size = 2, color = "black", fill = NA))

# Segundo passo: visualizando o plot 3D
plot_gg(ggobj = plot3d_rho, 
        multicore = TRUE, 
        width = 6, 
        height = 6, 
        scale = 300, 
        background = "white",
        shadowcolor = "dodgerblue4")


# A estatística KMO -------------------------------------------------------
KMO(r = rho)


# O teste de efericidade de Bartlett --------------------------------------
cortest.bartlett(R = rho)

# De onde vêm os graus de liberdade?
(ncol(rho) * (ncol(rho) - 1)) / 2

# De onde vem o p-valor do teste de efericidade de Bartlett?
pchisq(q = 192.3685, df = 6, lower.tail = FALSE)

# OBS: com isso, podemos identificar que p-valor � consider�velmente
# inferior a 0,05, ou seja, as correla��es de Pearson entre os pares de
# vari�veis s�o estatisticamente diferentes de 0.


# Passo 2: A definição propriamente dita dos fatores ----------------------

# A extração dos eigenvalues da matriz de correlações
eigenvalues_rho <- eigen(rho)

# Eigenvalues
eigenvalues_rho$values

# Outra forma de cálculo dos eigenvalues da matriz rho, a partir de seu
# polinômio característico, seria:

polinomio_caracteristico <- charpoly(rho)
polinomio_caracteristico # resultados da esquerda para a direita, sendo o
# termo mais à esquerda o com maior potência; e o
# termo mais à direita, o termo independente.


polinomio_caracteristico_invertido <- as.polynomial(rev(polinomio_caracteristico))
# a função as.polynomial() exige que os termos de entrada de um dado 
# polinômio sejam iniciados pelo termo independente; depois o termo de 
# potência 1; depois, de potência 2, e assim sucessivamente.

solve(polinomio_caracteristico_invertido) # eigenvalues de rho


# Note que a soma dos eigenvalues é igual à quantidade de variáveis 
# envolvidas
sum(eigenvalues_rho$values)

# Portanto, outra maneira de se olhar para os eigenvalues é entendê-los como
# variâncias compartilhadas de todas as variáveis. Note:

# Calculando a variância compartilhada
var_compartilhada <- (eigenvalues_rho$values/sum(eigenvalues_rho$values))
var_compartilhada

sum(var_compartilhada) # a soma das variâncias compartilhadas é igual a 1,
                       # isto é, 100%. De outra forma:

# Calculando a variância compartilhada cumulativa
var_cumulativa <- cumsum(var_compartilhada)
var_cumulativa

# Estabelecendo o número máximo possível de fatores
principais_componentes <- 1:sum(eigenvalues_rho$values)
principais_componentes

# Juntando tudo o que temos até o momento:
data.frame(principais_componentes = paste0("PC", principais_componentes),
           eigenvalue = eigenvalues_rho$values,
           var_compartilhada = var_compartilhada,
           var_cumulativa = var_cumulativa) -> relatorio_eigen

# Overview dos resultados até o momento
relatorio_eigen %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

# Exploração visual do compartilhamento das variâncias compartilhadas entre
# os componentes principais
relatorio_eigen %>% 
  ggplot(aes(x = principais_componentes, 
             y = var_compartilhada,
             group = 1,
             label = paste0(round(var_compartilhada * 100,
                                  digits = 2), "%"))) +
  geom_col(fill = "dodgerblue4", color = "black") +
  geom_line(color = "darkgoldenrod3",
            size = 1.2) +
  geom_point(size = 2) +
  geom_text(size = 3, vjust = 2, color = "white") +
  labs(x = "Componentes Principais",
       y = "Variância Compartilhada") +
  theme_bw()


# A determinação dos autovetores a partir de seus respectivos eigenvalues
eigenvalues_rho$vectors

# Visualizando os pesos que cada variável tem em cada componente principal 
# obtido pela PCA
data.frame(eigenvalues_rho$vectors) %>% 
  rename(PC1 = X1, PC2 = X2, PC3 = X3, PC4 = X4) %>% 
  mutate(var = names(notasfatorial[2:5])) %>% 
  melt(id.vars = "var") %>% 
  mutate(var = factor(var)) %>% 
  ggplot(aes(x = var, y = value, fill = var)) +
  geom_bar(stat = "identity", color = "black") +
  facet_wrap(~variable) +
  labs(x = NULL, y = NULL, fill = "Legenda:") +
  scale_fill_viridis_d() +
  theme_bw()

# Determinados os eigenvectors, podemos confirmar sua ligação direta com os
# eigenvalues aferidos, da seguinte maneira:

# Estabelecendo a matriz diagonal de eigenvalues (L2)
L2 <- diag(eigenvalues_rho$values)
L2

# Assim, com os eigenvectors calculados, podemos provar que V'.rho.V = L2
prova_01 <- t(eigenvalues_rho$vectors) %*% rho %*% eigenvalues_rho$vectors
round(x = prova_01,
      digits = 14)

# Calculando os scores fatoriais
# Relembrando:
eigenvalues_rho$values
eigenvalues_rho$vectors

# Então:
eigenvalues_rho$vectors[1,1] / sqrt(eigenvalues_rho$values[1])
eigenvalues_rho$vectors[2,1] / sqrt(eigenvalues_rho$values[1])
eigenvalues_rho$vectors[3,1] / sqrt(eigenvalues_rho$values[1])
eigenvalues_rho$vectors[4,1] / sqrt(eigenvalues_rho$values[1])

# Scores fatoriais do segundo fator

# Relembrando:
eigenvalues_rho$values
eigenvalues_rho$vectors

# Então:
eigenvalues_rho$vectors[1,2] / sqrt(eigenvalues_rho$values[2])
eigenvalues_rho$vectors[2,2] / sqrt(eigenvalues_rho$values[2])
eigenvalues_rho$vectors[3,2] / sqrt(eigenvalues_rho$values[2])
eigenvalues_rho$vectors[4,2] / sqrt(eigenvalues_rho$values[2])

# Scores fatoriais do terceiro fator

# Relembrando:
eigenvalues_rho$values
eigenvalues_rho$vectors

# Então:
eigenvalues_rho$vectors[1,3] / sqrt(eigenvalues_rho$values[3])
eigenvalues_rho$vectors[2,3] / sqrt(eigenvalues_rho$values[3])
eigenvalues_rho$vectors[3,3] / sqrt(eigenvalues_rho$values[3])
eigenvalues_rho$vectors[4,3] / sqrt(eigenvalues_rho$values[3])

# Scores fatoriais do quarto fator

# Relembrando:
eigenvalues_rho$values
eigenvalues_rho$vectors

# Então:
eigenvalues_rho$vectors[1,4] / sqrt(eigenvalues_rho$values[4])
eigenvalues_rho$vectors[2,4] / sqrt(eigenvalues_rho$values[4])
eigenvalues_rho$vectors[3,4] / sqrt(eigenvalues_rho$values[4])
eigenvalues_rho$vectors[4,4] / sqrt(eigenvalues_rho$values[4])


# De forma simplificada:
scores_fatoriais <- t(eigenvalues_rho$vectors)/sqrt(eigenvalues_rho$values)
scores_fatoriais

# Calculando os fatores

# O primeiro passo é o de padronização da base de dados pelo procedimento
# zscores, utilizando a função scale():

notasfatorial_std <- notasfatorial %>% 
  column_to_rownames("estudante") %>% 
  scale() %>% 
  data.frame()


# A seguir, vamos criar um objeto que servirá como um receptáculo para os
# k fatores (4, no caso estudado) a serem calculados:
fatores <- list()

# Agora, utilizaremos a função for
for(i in 1:nrow(scores_fatoriais)){
  fatores[[i]] <- rowSums(x = sweep(x = notasfatorial_std, 
                             MARGIN = 2, 
                             STATS = scores_fatoriais[i,], 
                             FUN = `*`))
}

# Feito isso, para fins didáticos, vamos transformar o objeto fatores em um
# data frame para melhor visualização e assimiliação de seu conteúdo:
fatores_df <- data.frame((sapply(X = fatores, FUN = c)))
fatores_df

fatores_df %>%
  rename(F1 = X1,
         F2 = X2,
         F3 = X3,
         F4 = X4) %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

# Podemos verificar que os fatores calculados, de fato, são ortogonais entre
# si, isto é, possuem correlações iguais a 0:
round(x = cor(fatores_df), 
      digits = 14)


# O cálculo das cargas fatoriais ------------------------------------------

# As cargas fatoriais referem-se aos coeficientes de correlação de Pearson
# entre as variáveis originais e cada um dos fatores.

# Buscando verificar a afirmação acima, faremos o seguinte: 1) combinaremos
# a base original 'notasfatorial' com o objeto 'fatores_df'; 2) depois,
# calcularemos as correlações entre as variáveis e originais e os fatores.

# Combinando a base original 'notasfatorial' com o objeto 'fatores_df':
notasfatorial_final <-  cbind(notasfatorial,
                              fatores_df) %>% 
  rename(F1 = X1,
         F2 = X2,
         F3 = X3,
         F4 = X4) 

# Calculando as correlações entre as variáveis e originais e os fatores
correlacoes_entre_fatores <- cor(notasfatorial_final[,2:9])

# Visualização gráfica das correlações entre as variáveis e originais e os 
# fatores
correlacoes_entre_fatores %>% 
  melt() %>% 
  filter(Var1 %in% c("F1","F2","F3","F4") &
           Var2 %in% c("notas_financas","notas_custos",
                       "notas_marketing","notas_atuarias")) %>% 
  ggplot() +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  geom_text(aes(x = Var1, y = Var2, label = round(x = value, digits = 3)),
            size = 4) +
  labs(x = NULL,
       y = NULL,
       fill = "Correlações") +
  scale_fill_gradient2(low = "dodgerblue4", 
                       mid = "white", 
                       high = "brown4",
                       midpoint = 0) +
  theme(panel.background = element_rect("white"),
        panel.grid = element_line("grey95"),
        panel.border = element_rect(NA),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 0))

# Relatório das correlações entre as variáveis e originais e os fatores
correlacoes_entre_fatores %>% 
  melt() %>% 
  filter(Var1 %in% c("F1","F2","F3","F4") &
           Var2 %in% c("notas_financas","notas_custos",
                       "notas_marketing","notas_atuarias")) %>% 
  dcast(Var1 ~ Var2) %>% 
  column_to_rownames("Var1") -> correlacoes_entre_fatores_df


correlacoes_entre_fatores_df %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

# É interessante notar que, se somarmos os quadrados das cargas fatoriais do
# objeto 'correlacoes_entre_fatores_df', o resultado dirá respeito aos 
# eigenvalues anteriormente calculados
correlacoes_entre_fatores_df %>% 
  mutate(eigenvalues = notas_financas^2 + notas_custos^2 +
           notas_marketing^2 + notas_atuarias^2) %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = T, 
                font_size = 12)

correlacoes_entre_fatores_df %>% 
  mutate(eigenvalues = notas_financas^2 + notas_custos^2 +
           notas_marketing^2 + notas_atuarias^2) %>% 
  filter(eigenvalues > 1) %>% 
  select(-eigenvalues) %>% 
  t() %>% 
  data.frame() %>% 
  square() %>% 
  mutate(comunalidades = rowSums(.))

# Elaborando um loading plot
correlacoes_entre_fatores_df %>% 
  t() %>% 
  data.frame() %>% 
  rownames_to_column("variaveis") %>% 
  ggplot(aes(x = F1, y = F2, label = variaveis)) +
  geom_point(color = "dodgerblue4",
             size = 2) +
  geom_text_repel() +
  geom_vline(aes(xintercept = 0), linetype = "dashed", color = "red") +
  geom_hline(aes(yintercept = 0), linetype = "dashed", color = "red") +
  expand_limits(x= c(-1.25, 0.25), y=c(-0.25, 1)) +
  labs(x = paste("Dimensão 1", paste0("(",round(var_compartilhada[1] * 100, 
                                            digits = 2),"%)")),
       y = paste("Dimensão 2", paste0("(",round(var_compartilhada[2] * 100, 
                                                digits = 2),"%)"))) +
  theme_bw()

# Fim da abordagem teórica -----------------------------------------------
