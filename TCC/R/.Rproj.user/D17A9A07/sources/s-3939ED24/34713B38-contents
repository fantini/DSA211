#carregando condutores
condutores <- read_csv("condutores-20220216.csv")

set.seed(2360873)

bool_treino <- stats::runif(dim(condutores)[1])>.001

treino <- condutores[bool_treino,]
teste <- condutores[!bool_treino,]

head(treino)



teste$codsexo = factor(teste$codsexo)
teste$ear = factor(teste$ear)
teste$multa = factor(teste$multa)
teste$curso = factor(teste$curso)
teste$categoriavigente = factor(teste$categoriavigente)

levels(teste$multa) <- c("N", "S")
levels(teste$curso) <- c("N", "S")
levels(teste$codsexo) <- c("M", "F")
levels(teste$ear) <- c("N", "S")
levels(teste$ear)

teste %>% str

controle <- caret::trainControl(
  "cv",
  number = 10,
  summaryFunction = twoClassSummary, # Função de avaliação de performance
  classProbs = TRUE # Necessário para calcular a curva ROC
)

modelo <- caret::train(
  multa ~ codsexo + ear, 
  data = teste, 
  method = "xgbTree",
  trControl = controle,
  tuneGrid = NULL,
  verbosity = 0)

modelo

avalia <- function(modelo, nome_modelo="modelo"){
  p_treino <- predict(modelo, treino, type='prob') # Probabilidade predita
  c_treino <- predict(modelo, treino)              # Classifica��o
  
  #Base de teste
  p_teste <- predict(modelo, teste, type='prob')
  c_teste <- predict(modelo, teste)
  
  # Data frame de avalia��o (Treino)
  aval_treino <- data.frame(obs=treino$Survived, 
                            pred=c_treino,
                            Y = p_treino[,2],
                            N = 1-p_treino[,2]
  )
  
  # Data frame de avalia��o (Teste)
  aval_teste <- data.frame(obs=teste$Survived, 
                           pred=c_teste,
                           Y = p_teste[,2],
                           N = 1-p_teste[,2]
  )
  
  tcs_treino <- caret::twoClassSummary(aval_treino, 
                                       lev=levels(aval_treino$obs))
  tcs_teste <- caret::twoClassSummary(aval_teste, 
                                      lev=levels(aval_teste$obs))
  ##########################
  # Curva ROC              #
  
  CurvaROC <- ggplot2::ggplot(aval_teste, aes(d = obs, m = Y, colour='1')) + 
    plotROC::geom_roc(n.cuts = 0, color="blue") +
    plotROC::geom_roc(data=aval_treino,
                      aes(d = obs, m = Y, colour='1'),
                      n.cuts = 0, color = "red") +
    scale_color_viridis_d(direction = -1, begin=0, end=.25) +
    theme(legend.position = "none") +
    ggtitle(paste("Curva ROC | ", nome_modelo, " | AUC-treino=",
                  percent(tcs_treino[1]),
                  "| AUC_teste = ",
                  percent(tcs_teste[1]))
    )
  
  print('Avalia��o base de treino')
  print(tcs_treino)
  print('Avalia��o base de teste')
  print(tcs_teste)
  CurvaROC
}

avalia(modelo, nome_modelo="XGBoosting")
