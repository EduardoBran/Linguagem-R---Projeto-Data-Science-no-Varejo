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


