## Esta etapa da aula mostra como funciona a raspagem de dados com R
## Vamos capturar dados disponíveis em um site público
## Pois tais dados não são disponibilizados para download em um arquivo consolidado

### 1. Instalar os pacotes (caso necessário)
# install.packages("tidyverse")
# install.packages("rvest")

### 2. Ler os pacotes
library(tidyverse)
library(rvest)

### 3. Informar o link principal
main_link <- "http://www.ssp.sp.gov.br/Estatistica/Trimestrais.aspx"

### 4. Pegar os links de todos os trimestres desde 2017
all_links <- main_link %>%
  read_html() %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  as_tibble() %>%
  filter(str_detect(value, "Estatistica/plantrim/")) %>%
  mutate(ano_trimestre = basename(value)) %>%
  separate(ano_trimestre, c("ano", "trimestre"), sep = "-", remove = FALSE) %>%
  filter(ano >= 2017) %>%
  mutate(url = paste0("http://www.ssp.sp.gov.br/Estatistica/plantrim/", ano_trimestre)) %>%
  select(url)

### 5. Pegar dados APENAS no primeiro link
dados <- all_links$url[1] %>%
  read_html() %>%
  html_table(fill = TRUE) %>%
  as.data.frame() %>%
  filter(!str_detect(X1, "Comunicado|Lei|Resolução|Trim") & X2 != "") %>%
  rename(item = X1, crime = X2, capital = X3,
         grande_sp = X4, interior = X5, deinter_1 = X6,
         deinter_2 = X7, deinter_3 = X8, deinter_4 = X9,
         deinter_5 = X10, deinter_6 = X11, deinter_7 = X12,
         deinter_8 = X13, deinter_9 = X14, deinter_10 = X15,
         estado = X16) %>%
  select(-item) %>%
  filter(!str_detect(capital, "Capital")) %>%
  slice(1:74) %>%
  mutate(link_original = basename(all_links$url[1]))

### 6. Criar loop para pegar os dados EM TODOS OS LINKS
# Repare que o código é muito similar ao de cima
# Mas usamos o 'i' em vez do 1 porque vamos iterar
get_dados <- function(i){
    all_links$url[i] %>%
    read_html() %>%
    html_table(fill = TRUE) %>%
    as.data.frame() %>%
    filter(!str_detect(X1, "Comunicado|Lei|Resolução|Trim") & X2 != "") %>%
    rename(item = X1, crime = X2, capital = X3,
           grande_sp = X4, interior = X5, deinter_1 = X6,
           deinter_2 = X7, deinter_3 = X8, deinter_4 = X9,
           deinter_5 = X10, deinter_6 = X11, deinter_7 = X12,
           deinter_8 = X13, deinter_9 = X14, deinter_10 = X15,
           estado = X16) %>%
    select(-item) %>%
    filter(!str_detect(capital, "Capital")) %>%
    slice(1:74) %>%
    mutate(link_original = basename(all_links$url[i]))
}

all_dados <- map_dfr(1:length(all_links$url), get_dados)

### 7. Tratar e padronizar os dados
# Vamos melhorar a nossa base de dados
# Teremos uma coluna para informar o período/trimestre
# E a coluna com número vira, de fato, número
all_dados_tidy <- all_dados %>%
  separate(link_original, c("ano", "trimestre"), sep = "-") %>%
  mutate(trimestre = str_remove_all(trimestre, "\\.htm"),
         grande_sp = parse_number(str_remove_all(grande_sp, "\\.")))

### 8. Analisar os dados da GRANDE SÃO PAULO quanto a FURTO DE VEÍCULOS

furto_v <- all_dados_tidy %>%
  select(trimestre, ano, crime, grande_sp) %>%
  filter(crime == "Furto de veículos")

furto_v %>%
  ggplot(aes(x = trimestre, y = grande_sp, color = ano)) +
  ylim(3000, 6500) +
  scale_x_discrete(labels=c("Jan-Mar", "Abr-Jun", "Jul-Set", "Out-Dez")) +
  labs(x = "Trimestre", y = "Furto de veículos") +
  geom_point()

furto_v %>%
  ggplot(aes(x = trimestre, y = grande_sp, group = ano, color = ano)) +
  #ylim(3000, 6500) +
  scale_x_discrete(labels=c("Jan-Mar", "Abr-Jun", "Jul-Set", "Out-Dez")) +
  labs(x = "Trimestre", y = "Furto de veículos") +
  geom_line()

### 9. Analisar os dados da GRANDE SÃO PAULO quanto a APREENSÃO DE ARMAS DE FOGO

armas_f <- all_dados_tidy %>%
  select(trimestre, ano, crime, grande_sp) %>%
  filter(crime == "Armas de fogo apreendidas")

armas_f %>%
  ggplot(aes(x = trimestre, y = grande_sp, color = ano)) +
  scale_x_discrete(labels=c("Jan-Mar", "Abr-Jun", "Jul-Set", "Out-Dez")) +
  labs(x = "Trimestre", y = "Armas de fogo apreendidas") +
  geom_point()

armas_f %>%
  ggplot(aes(x = trimestre, y = grande_sp, group = ano, color = ano)) +
  #ylim(350, 650) +
  scale_x_discrete(labels=c("1º", "2º", "3º", "4º")) +
  labs(x = "Trimestre", y = "Armas de fogo apreendidas") +
  geom_line() +
  facet_wrap(~ano)

