# Instalação e Carregamento de Todos os Pacotes --------------------------------

pacotes <- c("prophet","tidymodels","fpp2","tidyverse","tseries","itsmr",
             "timetk","modeltime","glmnet","h2o","modeltime.h2o")



if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

################################################################################
# PROPHET ######################################################################
################################################################################

load("air_passengers.RData")
df_train = subset(air_passengers, ds < "1959-01-01")
df_test = subset(air_passengers, ds >= "1959-01-01")

# Como foi analisado antes, a sazonalidade não é constante no tempo, mas aumenta 
# com a tendência. Os modelos aditivos não são os melhores para lidar com essas 
# séries temporais. Mas com o Prophet podemos passar da sazonalidade aditiva para 
# a sazonalidade multiplicativa por meio do parâmetro "seasonality_mode".

# Não esqueça de confirmar se o pacote "prophet" está ativo
m <- prophet(df_train,seasonality.mode = 'multiplicative')

# Vamos definir o período da previsão e a frequência (m, s, a)
future <- make_future_dataframe(m, 24, freq = 'm', include_history = F)
forecast <- predict(m, future)
plot(m, forecast)

# Para efeito de comparação, vamos avaliar o modelo com o RMSE, MAE e MAPE.

pred <- forecast$yhat
err <- df_test$y - forecast$yhat
mape <- mean(abs(err) / (pred+ err)) * 100
rmse <- sqrt(mean(err^2, na.rm = TRUE)) 
mae <- mean(abs(err), na.rm = TRUE) 
cbind(mape, rmse, mae)

# Para facilitar, vamos comparar os dois

## Modelo Arima
# mape     rmse      mae
# 2.356519 14.12564 10.62677

## Modelo Prophet
# mape     rmse      mae
# 5.463905 31.08188 25.89196

################################################################################
###### ARIMAX E SARIMAX ########################################################
################################################################################

# base: uschange: mudanças percentuais nas despesas de consumo pessoal, renda,
# produção, poupança, e taxa de desemprego nos EUA entre 1960 e 2016
# A base está no pacote fpp2

str(uschange) # formato dos dados
head(uschange) # avaliação das 5 primeiras linhas
summary(uschange) # análise das variáveis

uschange_df <- uschange[,1:2] # subconjunto da base
autoplot(uschange_df, facets=TRUE) + # plotando os dados
  xlab("Year") + ylab("") +
  ggtitle("Quarterly changes in US consumptionand personal income")

# Plotando a autocorrelação, aparentemente a variável "income" é mais estacionária
ggAcf(uschange_df) # plotando o ACF
ggPacf(uschange_df) # plotando o PCF

# Decomposição
# variável "consumption"
uschange_freq_4 <- uschange_df[,"Consumption"] %>% ts(., frequency=4)
uschange_stl <- stl(uschange_freq_4, s.window = "periodic")
autoplot(uschange_stl)

# variável "income"
uschange_income_freq_4 <- uschange_df[,"Income"] %>% ts(., frequency=4) 
uschange_income_stl <- stl(uschange_income_freq_4, s.window = "periodic")
autoplot(uschange_income_stl)

# Forecast pelo modelo ARIMAX, argumento xreg

# Arimax - Autoregressive Integrated Moving Average with Explanatory Variable
# Modelo de regressão múltipla com um ou mais termos autorregressivos (AR) e um 
# ou um ou mais termos de média móvel (MA). Adequado para prever quando os dados
# são estacionários/não estacionários e multivariados com qualquer tipo de 
# padrão de dados, ou seja, tendência/sazonalidade/ciclicidade.

uschange_arimax <- auto.arima(uschange_df[,"Consumption"], # especificando a tendência
                             xreg = uschange_df[,"Income"], # variável exógena
                             trace = TRUE, 
                             seasonal= FALSE,
                             stepwise=FALSE,
                             approximation=FALSE)

summary(uschange_arimax) # avaliação do modelo
checkresiduals(uschange_arimax) # avaliação dos resíduos do modelo  
test(resid(uschange_arimax)) # testes dos resíduos do modelo

# Os resíduos não são claros sobre a estacionariedade. Seria o SARIMAX melhor?

# Forecast pelo modelo SARIMAX, inclusão da sazonalidade
uschange_sarimax <- auto.arima(uschange_df[,"Consumption"], # especificação do modelo
                              xreg = uschange_df[,"Income"], # variável exógena
                              trace = TRUE, 
                              seasonal= TRUE, # altera o argumento
                              stepwise=FALSE,
                              approximation=FALSE)

summary(uschange_sarimax) # avaliação do modelo
checkresiduals(uschange_sarimax) # p valor não significativo
# os resíduos são conjuntamente não correlacionados.

# Especificando a série 
uschange_ts <- ts(uschange_df, frequency = 4, start = 1970, end= 2016 )

# Separando a base em treino e teste
uschange_train <- window(uschange_ts, end=2010)
uschange_test <- window(uschange_ts, start=2011)

# Treinando o modelo apenas com dados de treino
uschange_arimax2 <- auto.arima(uschange_train[,"Consumption"], # especificando a tendência
                              xreg = uschange_train[,"Income"], # variável exógena
                              trace = FALSE, # não apresentar modelos modificados
                              seasonal= FALSE, # não permitir modelo SARIMAX
                              stepwise= FALSE,
                              approximation=FALSE)

# Elaborando as previsões
myforecasts <- forecast::forecast(uschange_arimax2, xreg=rep(uschange_test[,"Income"],20))

# Plotando as previsões
autoplot(myforecasts) + autolayer(uschange_ts[,"Consumption"]) + xlim(1995, 2017)

############## Previsão usando a média dos preditores para uma imagem mais clara

# Elaborando as previsões
myforecasts <- forecast::forecast(uschange_arimax2, xreg= rep(mean(uschange_test[,"Income"]), 25) )

# Plotando as previsões
autoplot(myforecasts) + autolayer(uschange_ts[,"Consumption"]) + xlim(1995, 2017)

################################################################################
###### MODELTIME ###############################################################
################################################################################

# Pacote Modeltime: Tidy Time Series Forecasting using Tidymodels
# Framework: clássicos (ARIMA), novos métodos (Prophet), machine learning (Tidymodels)

# Tidymodels: estrutura dos dados

# O foco será avaliar as séries de maneira automática (Prophet, ARIMA), uso de 
# Machine Learning (ElasticNet, Random Forest) e Híbrido (Prophet-XGBoost)

# Confirme se os pacotes do script "pacotes.R" estão ativos.

bike_transactions_tbl <- bike_sharing_daily %>% # carregando a base 
  select(dteday, cnt) %>%
  set_names(c("date", "value")) 

bike_transactions_tbl # avaliando a estrutura dos dados

bike_transactions_tbl %>% # plotando os dados
  plot_time_series(date, value, .interactive = FALSE)

# Vamos separar a base em treino e teste, time_series_split()
splits <- bike_transactions_tbl %>% # período de 3 meses
  time_series_split(assess = "3 months", cumulative = TRUE)

# Convertendo a base em treino e teste
splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(date, value, .interactive = FALSE)

# Vamos a modelagem

# 1. Modelos automáticos, integração do forecast e prophet
# AutoArima
model_fit_arima <- arima_reg() %>% # algoritmo e parâmetro
  set_engine("auto_arima") %>% # seleção da função do pacote
  fit(value ~ date, training(splits)) # inserção da coluna data como regressor

model_fit_arima # sumário do modelo

#Prophet
model_fit_prophet <- prophet_reg(seasonality_yearly = TRUE) %>%  # inserção da sazonalidade
  set_engine("prophet") %>% # algoritmo prophet
  fit(value ~ date, training(splits))

model_fit_prophet # sumário do modelo

# 2. Modelos de Machine Learning
# Pipeline: Pré-processamento, especificação do modelo, fluxo para combinar o 
# pré-processamento, especificação do modelo e modelo de ajuste.

# Adição de etapas de série temporal
recipe_spec <- recipe(value ~ date, training(splits)) %>%
  step_timeseries_signature(date) %>%
  step_rm(contains("am.pm"), contains("hour"), contains("minute"),
          contains("second"), contains("xts")) %>%
  step_fourier(date, period = 365, K = 5) %>%
  step_dummy(all_nominal())

recipe_spec %>% prep() %>% juice()

# ElasticNet: regressão regularizada que combina linearmente os métodos Lasso e Ridge
model_spec_glmnet <- linear_reg(penalty = 0.01, mixture = 0.5) %>%
  set_engine("glmnet")

# Vamos aplicar o workflox
workflow_fit_glmnet <- workflow() %>%
  add_model(model_spec_glmnet) %>% # especificação do modelo
  add_recipe(recipe_spec %>% step_rm(date)) %>% # adicionando o pré-processamento
  fit(training(splits)) # ajustando o fluxo

# Random Forest: método para classificação, regressão e outras por meio da 
# construção de árvores de decisão no treinamento
model_spec_rf <- rand_forest(trees = 500, min_n = 50) %>% # especificando o modelo
  set_engine("randomForest")

workflow_fit_rf <- workflow() %>% # aplicando o fluxo
  add_model(model_spec_rf) %>%
  add_recipe(recipe_spec %>% step_rm(date)) %>%
  fit(training(splits))

# 3. Modelos Híbridos de Machine Learning

# Iniciando o fluxo
model_spec_prophet_boost <- prophet_boost(seasonality_yearly = TRUE) %>%
  set_engine("prophet_xgboost") 

workflow_fit_prophet_boost <- workflow() %>% # aplicando o fluxo
  add_model(model_spec_prophet_boost) %>%
  add_recipe(recipe_spec) %>%
  fit(training(splits))

workflow_fit_prophet_boost # ajustando o fluxo

# Workflow do pacote Modeltime
# 1. Criando a tabela
# 2. Calibrando, testando a previsão e a acurácia
# 3. Reajustando e fazendo a previsão

# Criando a tabela 
model_table <- modeltime_table(
  model_fit_arima, 
  model_fit_prophet,
  workflow_fit_glmnet,
  workflow_fit_rf,
  workflow_fit_prophet_boost
) 

# Confirme se o pacote ""glmnet" está ativo
model_table # avaliando tabela

# Calibrando
calibration_table <- model_table %>%
  modeltime_calibrate(testing(splits))

calibration_table # avaliando a tabela 

# Testando a previsão
calibration_table %>% # gerando os dados de previsão para os testes da tabela
  modeltime_forecast(actual_data = bike_transactions_tbl) %>%
  plot_modeltime_forecast(.interactive = FALSE) # plotando

# Avaliando a acurácia
calibration_table %>%
  modeltime_accuracy() %>% # criando métricas de acurácia
  table_modeltime_accuracy(.interactive = FALSE) # criando tabela de comparação

# LEMBRETE #####################################################################
# MAPE - erro absoluto do percentual da média
## Medida de precisão. Mede a precisão como uma porcentagem e pode ser calculado como o 
## erro percentual absoluto médio para cada périodo de tempo menos os valores reais
# divididos pelos valores reais.

# RMSE - raiz do erro quadrático da média
## Usado para avaliar a medida das diferenças entre os valores (amostra ou população) previstos
## por mum modelo ou um estimador e os valores observados

# MAE - erro absoluto da média
## Medida de erros entre observações emparelhadas que expressam o mesmo fenômeno

# Analizando os resultados

calibration_table %>% # Removendo o modelo ARIMA pela baixa acurácia
  filter(.model_id != 1) %>%
  
  # Refinando a previsão futura
  modeltime_refit(bike_transactions_tbl) %>%
  modeltime_forecast(h = "12 months", actual_data = bike_transactions_tbl) %>%
  plot_modeltime_forecast(.interactive = FALSE)

################################################################################
###### AUTOMATIC FORECASTING ###################################################
################################################################################

# Base: Vendas Semanais do Walmart disponível no pacote timetk

data_tbl <- walmart_sales_weekly %>% # carregando a base
  select(id, Date, Weekly_Sales)

# Plotando a série
data_tbl %>% 
  group_by(id) %>% 
  plot_time_series(
    .date_var    = Date,
    .value       = Weekly_Sales,
    .facet_ncol  = 2,
    .smooth      = F,
    .interactive = F
  )

# Gerando uma base de treino e teste

splits <- time_series_split(data_tbl, assess = "3 month", cumulative = TRUE) # período de 3 meses

recipe_spec <- recipe(Weekly_Sales ~ ., data = training(splits)) %>%
  step_timeseries_signature(Date) 

train_tbl <- training(splits) %>% bake(prep(recipe_spec), .) # base de treino
test_tbl  <- testing(splits) %>% bake(prep(recipe_spec), .) # base de teste

################################################################################
################################################################################
# Para que possam implementar o h20 é preciso que tenham o Java instalado
################################################################################
# Caso não tenha o link de acesso para download é: https://java.com/en/
################################################################################
h2o.init(
  nthreads = -1,
  ip       = 'localhost',
  port     = 54321
)

model_spec <- automl_reg(mode = 'regression') %>% # uso do algoritmo de ML
  set_engine(
    engine                     = 'h2o',
    max_runtime_secs           = 5, 
    max_runtime_secs_per_model = 3,
    max_models                 = 3,
    nfolds                     = 5,
    exclude_algos              = c("DeepLearning"),
    verbosity                  = NULL,
    seed                       = 786
  ) 

model_spec # avaliando a especificação do modelo

# Treinando o modelo
model_fitted <- model_spec %>%
  fit(Weekly_Sales ~ ., data = train_tbl)

# Checando o modelo
model_fitted

# Prevendo o modelo de teste
predict(model_fitted, test_tbl)

# Como o modelo preparado voltamos para o fluxo do Modeltime
# 1. Criando a tabela
# 2. Calibrando, testando a previsão e a acurácia
# 3. Reajustando e fazendo a previsão

# Criando a tabela modelo
modeltime_tbl <- modeltime_table(
  model_fitted
) 

# Avaliando a tabela
modeltime_tbl

# Calibrando, testando e configurando a acurácia do modelo
modeltime_tbl %>%
  modeltime_calibrate(test_tbl) %>%
  modeltime_forecast(
    new_data    = test_tbl,
    actual_data = data_tbl,
    keep_data   = TRUE
  ) %>%
  group_by(id) %>%
  plot_modeltime_forecast(
    .facet_ncol = 2, 
    .interactive = FALSE
  )

# Fazendo a previsão
data_prepared_tbl <- bind_rows(train_tbl, test_tbl) # preparando os dados

future_tbl <- data_prepared_tbl %>% # criando o dataset
  group_by(id) %>%
  future_frame(.length_out = "1 year") %>%
  ungroup()

future_prepared_tbl <- bake(prep(recipe_spec), future_tbl)

# Retreinando todo a base de dados. Prática para melhorar o resultado das previsões
refit_tbl <- modeltime_tbl %>%
  modeltime_refit(data_prepared_tbl)

# Visualiação da previsão
refit_tbl %>%
  modeltime_forecast(
    new_data    = future_prepared_tbl,
    actual_data = data_prepared_tbl,
    keep_data   = TRUE
  ) %>%
  group_by(id) %>%
  plot_modeltime_forecast(
    .facet_ncol  = 2,
    .interactive = FALSE
  )
