# Este é o arquivo com o código da aula de introdução à linguagem R,
# do programa Milhas do Conhecimento

# 0.0- OBJETIVO DA AULA DE HOJE:

# O R tem muitas funcionalidades: calculadora, automação, um monte de técnicas
# da estatística...

# Para jornalistas, ele é ótimo para facilitar análises de bases de dados.
# Seja para abrir bases que são grandes demais para o Excel/Google Planilhas,
# ou para escrever, em poucas linhas, um código que pode ser repetido e que,
# no Excel, teria que ser feito manualmente.

# Nesta oficina, vamos aprender comandos em R para calcular a cobertura vacinal
# contra a Covid-19 de cada município brasileiro.
# Com esses comandos, vocês vão poder fazer análises parecidas com outros dados!

# 0.1- INTRODUÇÃO

# Q: Por que esses comentários estão com uma # no início da linha?
# R: Porque sem eles o programa acha que você está escrevendo um comando!

# Q: Escrevi meu comando, como faço para o programa rodar o código?
# R1: Posicione o cursor em cima do código que você quer rodar e clique no botão "Run" no topo!
# R2: Você também pode rodar só uma parte do código, selecionando o trecho com o mouse.
# R3: O atalho do teclado para o botão "Run" é o CTRL+ENTER.

# 0.2- INSTALANDO E CARREGANDO PACOTES
# Q: O que são pacotes?
# R: São "acessórios" do RStudio. Você instala no seu pra ter mais opções de comandos.

# Q: Como instalo um pacote no RStudio?
# R: A função se chama install.packages
# DICA: Na hora de instalar pacotes, os nomes vão entre aspas!

install.packages("tidyverse")
# Conjunto de vários pacotes super úteis para manipular tabelas

install.packages("lubridate")
# Pacote que ajuda a formatar colunas com datas pra facilitar a manipulação

install.packages("janitor")
# Pacote que ajuda a "limpar" colunas com nomes bagunçados (como acentuação)

install.packages("tidylog")
# Pacote que te dá um relatório do que foi feito quando você rodou um comando

# Q: Ok, instalei o pacote. E agora, como faço o pacote funcionar?
# R: Você escreve a função "library", igual nos exemplos abaixo:
# DICA: Na hora de carregar pacotes, os nomes NÃO vão entre aspas!

library(tidyverse)
library(lubridate)
library(janitor)
library(tidylog)

# Agora que temos os acessórios para analisar dados, MÃOS À OBRA!

# 1- BAIXANDO NOSSA BASE DE DADOS
# Nosso exemplo é a base de vacinas aplicadas por município brasileiro.
# Vamos usar um modelo já baixado antes, dentro da pasta "data-raw": municipios_vacinas.csv
# Mas você pode achá-la aqui: https://qsprod.saude.gov.br/extensions/DEMAS_C19Vacina/DEMAS_C19Vacina.html
# O botão para o download está no fim da página à esquerda.

# 2- LENDO BASE DE DADOS (OU TABELA/PLANILHA/DATAFRAME...)
# Vamos ao mesmo tempo criar um "objeto" dentro do nosso Rstudio e atribui a
# esse objeto os dados do arquivo que já baixamos.

# A "frase" abaixo dá o seguinte comando para o programa:
# - Crie um objeto chamado "municipios_vacinas"...
# - ...onde você vai colocar a tabela lida a partir deste arquivo nesta pasta...
# - ...e aproveita e coloca o encoding "UTF-8" pra gente poder ver os acentos direitinho.

municipios_vacinas <- read.csv2("data-raw/municipios_vacinas.csv", encoding = "UTF-8")

# Primeiro, coloque o cursor em qualquer parte do código acima e clique em CTRL+ENTER.
# O resultado deve ter aparecido na caixa "Environment":
# um objeto chamado "municipios_vacinas" e, ao lado, a seguinte expressão:
# "20539 obs. of 8 variables"
# O "obs." significa "observações", que na verdade é um sinônimo de "linha".
# A palavra "variables" (variáveis) é um sinônimo de "coluna".
# Isso quer dizer que temos um dataframe/tabela de 20539 linhas e 8 colunas.

# Mas... Não temos apenas 5.570 municípios? Por que a base tem mais de 20 mil linhas?
# Vamos ver nosso objeto para descobrir!

# 3- VENDO NOSSO DATAFRAME

# Para isso, rode o código abaixo (coloque o cursor na linha e CTRL+ENTER de novo)

View(municipios_vacinas)

# Note como cada município brasileiro aparece mais de uma vez!
# Afinal, o dataframe está detalhando as doses de cada fabricante em cada município.
# Com poucos comandos poderemos somar todas as doses...
# ...mas antes, vamos aplicar algumas técnicas de LIMPEZA DE DADOS.

# 4- LIMPANDO NOSSOS DADOS

# Quando abriu a vista (View), Você notou que os nomes das colunas estão estranhos?
# O ideal é que, como os nomes de objetos, os nomes de colunas sigam algumas regras:
# -Não ter espaços
# -Não ter acentos
# -Não começar com números
# -De preferência, todas as letras em minúscula
# Isso evita inúmeros problemas, já que o RStudio é sensível às maiúsculas e minúsculas.
# Por isso, o nome dos objetos e variáveis precisa ser sempre exato no código.
# Do contrário, os comandos podem dar erro.

# Uma forma simples de limpar colunas com nomes estranhos é combinando dois comandos:
# glimpse + rename. Primeiro, o glimpse:

glimpse(municipios_vacinas)

# Vejam que ele te dá acesso fácil ao nome das colunas, dentro da caixa "Console".
# Com isso podemos copiar e colar esses nomes exatos no comando "rename".
# Para fazer isso, vamos "editar" nosso objeto "municipios_vacinas".

municipios_vacinas <- municipios_vacinas %>%
  rename(
    municipio = X.U.FEFF.Município,
    cod_ibge = Cód..IBGE,
    uf = UF,
    regiao = Região,
    fabricante = Fabricante,
    doses_aplicadas = Doses.Aplicadas,
    dose_1 = Dose.1,
    dose_2 = Dose.2
  )

# Essa tarefa exige a expressão %>%, também chamada de "pipe".
# Em termos simples: o "pipe" funciona como uma vírgula entre uma função e outra.
# Você pode escrever o pipe com esse comando: CTRL+SHIFT+M.
# Em seguida, incluímos a função "rename".
# Os parênteses são necessários para o RStudio entender que o que colocamos
# lá dentro está ligado diretamente à função "rename".
# DICA: O primeiro nome que escrevo é como quero que a coluna se chame.

# Pronto! Essa é uma base simples de limpar.
# Agora podemos começar a fazer algumas análises.

# 5- MANIPULANDO NOSSOS DADOS
# OBS: A palavra "manipulação" aqui é sinônimo de "mexer".
# Não estamos adulterando nem falsificando dados, obviamente!

# As manipulações que vamos aprender hoje são:
# 5.1- Filtrar só algumas linhas da tabela
# 5.2- Selecionar só algumas colunas da tabela
# 5.3- Agrupar e somar valores da tabela
# 5.4- Ordenar nossa tabela
# 5.5- Juntar duas tabelas em uma terceira
# 5.6- Criar novas colunas com cálculos matemáticos

# 5.1- Aplicando filtros
# Aqui começamos a aprender nomes de funções muito úteis na ciência de dados.
# O lado bom delas é que são nomes simples e intuitivos.
# O comando de filtros se chama... "filter".
# No exercício abaixo, vamos filtrar a tabela apenas pelos municípios de Alagoas:

alagoas <- municipios_vacinas %>%
  filter(uf == "AL")

# Notem que o resultado é um segundo objeto no nosso "Environment".
# Ele tem 321 observações/linhas e as mesmas 8 variáveis/colunas.
# Para ver o dataframe/tabela, fazemos uma View mais uma vez:

View(alagoas)

# Dessa vez, nosso comando disse o seguinte para o RStudio:
# Crie um objeto chamado "alagoas" a partir do objeto "municipios_vacinas"...
# ...mas inclua no "alagoas" só as linhas em que a coluna "uf" seja igual a "AL".

# OBSERVAÇÃO 1: Repararam que o sinal de "igual" é diferente do que usamos no "rename"?
# O motivo é que aqui estamos usando um OPERADOR LÓGICO. Os principais são:
# igual a: ==
# diferente de: !=
# maior que: >
# maior ou igual a: >=
# menor que: <
# menor ou igual a: <=

# OBSERVAÇÃO 2: Repararam que coloquei a sigla de Alagoas entre aspas?
# Isso foi necessário porque os dados podem ter CLASSES (OU TIPOS) DIFERENTES.
# Nesse caso, a classe da variável/coluna UF é "texto", que em programação se chama "character".
# Quando estamos falando de valores em string, colocamos o conteúdo entre aspas.
# Quando estamos falando de alguma classe de números, o conteúdo vai fora das aspas.
# Exemplos de character: nomes e datas
# Exemplos de tipos numéricos: números inteiros (real), números decimais (decimal)
# Tipo lógico: TRUE ou FALSE

# No próximo exercício vamos filtrar só os municípios que já aplicaram mais de 10.000 doses:

dez_mil_doses <- municipios_vacinas %>%
  filter(doses_aplicadas > 10000)

# Pronto, nosso terceiro objeto tem 1.571 linhas e as mesmas 8 colunas.
# Lembrando que não se trata de 1.571 municípios!

# Bom, mas e como fazemos se quisermos incluir dois filtros ao mesmo tempo?
# Basta usar os operadores & (E) e | (OU). Por exemplo:

alagoas_dez_mil_doses <- municipios_vacinas %>%
  filter(uf == "AL" & doses_aplicadas > 10000)

# Agora nosso resultado tem apenas 17 linhas, e as mesmas 8 colunas.

# 5.2- Selecionar colunas
# Isso é porque o comando "filter" só muda o tamanho das linhas, ele nunca mexe nas colunas.
# Se quiser selecionar que comandos quero na tabela final, o comando é o... "select".

alagoas_dez_mil_doses_select1 <- municipios_vacinas %>%
  filter(uf == "AL" & doses_aplicadas > 10000) %>%
  select(municipio, uf, fabricante, doses_aplicadas)

# Veja que agora só temos quatro colunas no objeto "alagoas_dez_mil_doses".
# Mas digamos que eu queira ficar com todas as colunas, menos uma, o cod_ibge.
# Pra isso, usamos o select também, mas com um sinal de "menos":

alagoas_dez_mil_doses_select2 <- municipios_vacinas %>%
  filter(uf == "AL" & doses_aplicadas > 10000) %>%
  select(-cod_ibge)

# 5.3- Agrupar e somar

# Nesse próximo capítulo, vamos finalmente agrupar as doses aplicadas em cada municípios.
# Para isso, vamos usar a função... "group_by"!
# ALERTA: A função "group_by" nunca vem sozinha. Ela sempre precisa de um complemento.
# No nosso caso, o complemento vai ser a SOMA.

vacinas_aplicadas <- municipios_vacinas %>%
  group_by(municipio, uf) %>%
  summarise(
    total_doses = sum(doses_aplicadas)
  )

# Notaram algum problema nesse resultado?
# Em vez de 5.570 linhas, uma pra cada município, nosso objeto tem 5.597 linhas.
# Vamos fazer mais um View pra ver se achamos o problema.

View(vacinas_aplicadas)

# Notem que as primeiras linhas da tabela estão com um traço no nome do município.
# Isso pode ser um problema do nosso dataframe.
# Vamos investigar aplicando separando só essas linhas estranhas:

municipios_estranhos <- municipios_vacinas %>%
  filter(municipio == "-")

View(municipios_estranhos)

# Bom, já vimos que existem 27 linhas desse tipo, uma pra cada estado.
# Elas não parecem afetar nossa análise.
# Então podemos acrescentar mais um filtro pra exclui-las da análise.


vacinas_aplicadas <- municipios_vacinas %>%
  filter(municipio != "-") %>%
  group_by(municipio, cod_ibge, uf) %>%
  summarise(
    total_doses = sum(doses_aplicadas)
  )

# Agora sim! Chegamos à nossa tabela com os 5.570 municípios.
# Mas qual é o município com mais doses totais aplicadas?
# Não precisamos olhar manualmente, é só acrescentar mais uma linha ao código.
# A função que arruma o dataframe a partir dos valores de uma coluna é a... "arrange".

vacinas_aplicadas <- municipios_vacinas %>%
  filter(municipio != "-") %>%
  group_by(municipio, cod_ibge, uf) %>%
  summarise(
    total_doses = sum(doses_aplicadas),
    total_dose_1 = sum(dose_1),
    total_dose_2 = sum(dose_2)
  ) %>%
  arrange(desc(total_doses))

# Como esperávamos, as maiores cidades do país são as que ficam no topo da lista.
# Notem que incluí a palavra "desc" antes de selecionar a coluna a ser ordenada.
# Com isso, eu pedi que a ordem fosse "decrescente", e não "crescente", que é o padrão.

# Bom, até agora nosso código não diferiu muito do que poderíamos ter feito no Excel,
# usando a Tabela Dinâmica pra montar manualmente esse agrupamento por município.

# Mas agora vamos fazer algo que exigiria mais riscos no Excel, mas que no R
# fica mais seguro fazer, porque é o robô que verifica se deu tudo certo.
# Vamos juntar nosso dataframe "vacinas_aplicadas" com uma nova tabela:
# a tabela com a população de cada município brasileiro, segundo o IBGE.

# O comando de juntar tabelas se chama... "join"!
# E só existe uma condição indispensável pra conseguir juntar duas tabelas:
# As duas precisam ter uma COLUNA IGUAL, ou seja, com os mesmos valores.
# Elas vão funcionar como a "chave" pra gente poder criar essa intersecção.
# Não necessariamente precisam ter o mesmo número de linhas (há vários tipos de join!)

# Antes de mais nada, precisamos importar a tabela para um objeto do R.

municipios_populacao <- read.csv2("data-raw/municipios_populacao.csv", encoding = "UTF-8")

# Veja no View que a coluna "cod_ibge" chegou "estranha" por causa da codificação.
# Então vamos fazer o mesmo truque de limpeza.

glimpse(municipios_populacao)

municipios_populacao <- municipios_populacao %>%
  rename(
    cod_ibge = X.U.FEFF.cod_ibge
  )

# Pronto, agora temos nossa tabela de população com 5.570 linhas e 3 colunas.
# As três colunas são: cod_ibge, municipio e população.
# Isso quer dizer que temos duas colunas que podem ser "chave": cod_ibge e municipio.
# Mas quando mexemos com dados, especialmente o nome de municípios, vá pelo código!
# Motivo: será que as duas fontes escreveram os nomes das cidades da mesma forma?
# Resposta: provavelmente NÃO!
# Os nomes podem mudar, mas os códigos são os mesmos. Vamos lá para o join:

municipios <- left_join(
  x = vacinas_aplicadas, y = municipios_populacao, by = "cod_ibge"
)

# Vejam que o resultado dessa terceira tabela é a tabela de vacinas por município,
# com duas novas colunas: municipio.y e populacao.
# A coluna municipio.y veio repetida porque já tinha outra com o mesmo nome.
# Ela pode servir de conferência se quisermos, ou podemos exclui-la.
# A coluna cod_ibge não aparece repetida porque ela foi usada como "chave"
# Já a coluna "população" era a que a gente queria!
# Agora podemos calcular a cobertura vacinal de cada município brasileiro!
# Para isso, vamos usar um comando que se chama "mutate":

cobertura_vacinal <- municipios %>%
  select(-municipio.y) %>%
  mutate(
    cobertura_vacinal_dose_1 = ( total_dose_1 * 100 ) / populacao,
    cobertura_vacinal_dose_2 = ( total_dose_2 * 100 ) / populacao
  )

# Por enquanto, apliquei dois comandos ao nosso objeto "municipios":
# - Selecionei todas as colunas MENOS a "municipio.y", que estava repetida
# - Criei novas colunas que já calculam, pra cada município, a cobertura vacinal
# Vejam que foi simples, eu apenas escrevi a regra de três dentro do "mutate"
# Isso só foi possível porque as colunas "total_doses" e "populacao" são da CLASSE NUMÉRICA

# Pra finalizar, vou:
# - Incluir um argumento extra no "mutate" para arredondar a porcentagem
# - Arrumar a coluna "cobertura_vacinal" em ordem decrescente
# - Salvar o meu dataframe em um arquivo CSV!

cobertura_vacinal <- municipios %>%
  select(-municipio.y) %>%
  mutate(
    cobertura_vacinal_dose_1 = round((( total_dose_1 * 100 ) / populacao),1),
    cobertura_vacinal_dose_2 = round((( total_dose_2 * 100 ) / populacao),1),
  ) %>%
  arrange(desc(cobertura_vacinal_dose_2)) %>%
  write.csv2("data/cobertura_vacinal.csv", row.names = F)


# Aqui encerramos a parte da CIÊNCIA DE DADOS da nossa pauta.
# Ou seja, aplicamos técnicas de programação e análise estatística pra conseguir dados consolidados.
# PORÉM, ainda faltam outras etapas fundamentais, incluindo a ANÁLISE DOS DADOS.
# Por exemplo: o município de Pedro Avelino (RN) aparece no topo da lista.
# Consta que o total de primeiras doses aplicadas no município corresponde a 209% da população local.
# Por que isso aconteceu? O nosso código não é capaz de responder, precisamos investigar mais:
# - Ouvir o município (Houve algum estudo clínico? A população do IBGE está incorreta?)
# - Ouvir o Ministério da Saúde pra descobrir possíveis problemas nesse painel de vacinação.
