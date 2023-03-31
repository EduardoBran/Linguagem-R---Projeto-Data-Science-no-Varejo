# Big Data na Prática 3 - Data Science no Varejo com Market Basket Analysis


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/5.Projeto-Data-Science-no-Varejo-com-Market-Basket-Analysis")
getwd()



# Market Basket Analysis (análise de cesta de compras) é o nome da técnica utilizada.
# Com isso criaremos uma espécie de loop onde iremos percorrer as transações buscando exatamente as combinasções/padrões
# e então realizaremos cálculos para extrair as métricas (medidas quantitativas utilizadas para avaliar e descrever características de um sistema, processo ou produto. )



# Carrega os pacotes

library(dplyr)         # pacote para processar dados
library(arules)        # pacote com algoritimo para Market Basket Analysis
library(arulesViz)     # pacote para visualização das regras de associações criados com pacote acima
library(htmlwidgets)   # pacote para gerar os graficos do arulesViz
library(writexl)       # pacote para gerar e gravar os arquivos em Excel
options(warn=-1)       # filtra tipos de warning (para não poluir o console)



# Definimos nossa problema de negócio: 

# - vamos mineirar / buscar padrões de compras em transações comerciais
# - definimos a técnica usada (Market Basket Analysis)
# - definimos o pacote com algoritmos necessários para aplicar a técnica


# Agora vamos aos dados


# Carrega e explora o dataset

dados <- read.csv("dataset_bd3.csv")

View(dados)

dim(dados) # 15002 linhas 20 colunas
str(dados)


# foi detectado diversas linhas com valores em branco (devem ser removidas)
# foi detectado um padrão dessas linhas em branco: 1 linha tem conteúdo, 1 linha está em branco, 1 linha tem conteúdo, 1 linha está em branco


# 1ª forma de remover as linhas com valores em branco

# por conta do padrão vamos separar as linhas pares das linhas ímpares

linhas_pares <- seq(2, nrow(dados), 2)      # No caso de linhas_pares, a sequência começa no número 2, que é a segunda linha do data frame, e termina no número de linhas do data frame (nrow(dados)), com incrementos de 2. Isso significa que a variável linhas_pares contém os números das linhas pares do data frame dados.
linhas_impares <- seq(1, nrow(dados), 2)

View(linhas_pares)

# separamos os dados e então usaremos o dataset df1 com as linhas pares (linhas onde tem dados válidos)

df1 <- dados[linhas_pares, ]
View(df1)
df2 <- dados[linhas_impares, ]
View(df2) 


# 2ª forma de remover as linhas com valores em branco
dados2 <- dados

# converter todas as células para caracteres e remover espaços em branco
dados2 <- as.data.frame(lapply(dados, as.character), stringsAsFactors = FALSE)
dados2 <- as.data.frame(lapply(dados2, trimws))

# remover linhas com valores em branco em todas as colunas
dados2 <- dados2[rowSums(dados2 != "") > 0, ]



