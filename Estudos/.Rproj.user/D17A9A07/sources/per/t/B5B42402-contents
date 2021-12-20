library("tidyverse")

# DATA WRANGLING

log <- log %>% rename(
  consumer=1,
  ocorrencia=2,
  path=3,
  source=4,
  tempo=5,
  ip=6
)

log_v2 <- log %>% select(path,ocorrencia,tempo) %>%
  filter(ocorrencia < as.POSIXct(tz = "GMT","2021-12-02 09:00:00"))

view(log_v2)
head(log_v2)

log_v2$ocorrencia_cut <- cut(log_v2$ocorrencia, breaks = "5 min")

log_v3 <- log_v2 %>% group_by(path, ocorrencia_cut) %>% 
  summarise(tempo_médio = mean(tempo),
            mínimo = min(tempo),
            máximo = max(tempo),
            contagem = n()) %>% 
  arrange(desc(path,ocorrencia_cut))

View(log_v3)

head(log_v2)
