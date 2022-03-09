
#carregando condutores
condutores <- read_csv("condutores-20220216.csv")

head(condutores)

condutores$codsexo = factor(condutores$codsexo)
condutores$ear = factor(condutores$ear)
condutores$multa = factor(condutores$multa)
condutores$curso = factor(condutores$curso)
condutores$categoriavigente = factor(condutores$categoriavigente)

levels(condutores$multa) <- c("N", "S")
levels(condutores$curso) <- c("N", "S")
levels(condutores$codsexo) <- c("I", "M", "F")
levels(condutores$ear) <- c("N", "S")

set.seed(123)
bool_treino <- stats::runif(dim(condutores)[1])>.25

treino <- condutores[bool_treino,]
teste <- condutores[!bool_treino,]

head(treino)

treino %>% str

#criando arvore
arvore <- rpart(
  curso ~ codsexo + ear + categoriavigente + multa + idade,
  data = treino,
#  method = 'class',
  control = rpart.control(cp = -0.5, maxdepth = 4)
)

arvore$frame

#visualizando arvore
paleta = scales::viridis_pal(begin=.75, end=1)(20)
rpart.plot::rpart.plot(arvore, box.palette = paleta)

printcp(arvore)

prob = predict(arvore, teste)
class = prob[,2]>.02
tab <- table(class, teste$curso)
tab
acc <- (tab[1,1] + tab[2,2])/ sum(tab)
acc
