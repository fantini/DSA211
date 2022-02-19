
#carregando condutores
condutores <- read_csv("condutores-20220216.csv")
condutores$multa_f <- factor(condutores$multa)

set.seed(123)
bool_treino <- stats::runif(dim(condutores)[1])>.001

treino <- condutores[bool_treino,]
teste <- condutores[!bool_treino,]

head(treino)



teste$codsexo = factor(teste$codsexo)
teste$ear = factor(teste$ear)
teste$multa = factor(teste$multa)
teste$curso = factor(teste$curso)
teste$categoriavigente = factor(teste$categoriavigente)

teste %>% str

#criando arvore
arvore <- rpart(
  multa ~ codsexo + ear + categoriavigente,
  data = teste,
  method = 'class',
  control = rpart.control(cp = -1, maxdepth = 4)
)

arvore$terms

#visualizando arvore
paleta = scales::viridis_pal(begin=.75, end=1)(20)
rpart.plot::rpart.plot(arvore, box.palette = paleta)

prob = predict(arvore, teste)
class = prob[,2]>.51
tab <- table(class, teste$multa)
tab
acc <- (tab[1,1] + tab[2,2])/ sum(tab)
acc
