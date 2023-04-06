# Big Data na Prática - Data Science no Varejo com Market Basket Analysis

# Projeto Paralelo Supermercado


# Configurando Diretório de Trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/5.Projeto-Data-Science-no-Varejo-com-Market-Basket-Analysis")
getwd()


# Carrega os pacotes

library(dplyr)         # pacote para processar dados
library(arules)        # pacote com algoritimo para Market Basket Analysis
library(arulesViz)     # pacote para visualização das regras de associações criados com pacote acima
library(htmlwidgets)   # pacote para gerar os graficos do arulesViz
library(writexl)       # pacote para gerar e gravar os arquivos em Excel
options(warn=-1)       # filtra tipos de warning (para não poluir o console)


dados_support <- read_excel("df_produto1.xlsx")
dados_confiden <- read_excel("df_produto2.xlsx")



# Criando os dados

dados_df <- data.frame(Item01 = c('laranja', 'laranja', 'laranja', 'laranja', 'laranja', 'limao', 'limao', 'limao', 'limao', 'limao', 'cenoura', 'cenoura', 'cenoura', 'cenoura' ,'cenoura', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite'),
                       Item02 = c('banana', 'limão', 'abacaxi', 'banana', '', 'carne', 'carne', 'alho', 'conhaque', 'carne', 'brócolis', 'brócolis', 'brócolis', 'brócolis', 'brócolis', 'manteiga', 'manteiga', 'manteiga', 'manteiga', 'alho', 'manteiga', 'manteiga', 'manteiga', 'fralda', 'fralda', 'fralda', 'fralda', 'fralda', 'lenço', 'fralda', 'fralda', 'fralda', 'fralda'),
                       Item03 = c('abacaxi', 'carne', 'banana', 'pão', '', 'laranja', 'uva', 'alface', 'couve-flor', 'alface', 'limão', 'laranja', 'arroz', 'feijão', 'ovo', 'sal', 'ovo', 'alho', 'requeijão', 'salame', 'requeijão', 'queijo', 'presunto',     'lenço', 'pão', 'pão', 'pão', 'arroz', 'lenço', 'lenço', 'lenço', 'lenço', 'lenço'),
                       Item04 = c('cenoura', 'banana', '', 'carne', '', 'carne', 'uva', '', '', '', 'laranja', 'macarrão', 'feijão', 'ovo', '', 'arroz', 'requeijão', 'alface', 'beterraba', 'salame', 'queijo', 'salame', 'salame', 'abacaxi', 'presunto', 'beterraba', '', '', 'café', 'café', 'café', 'café', 'café'),
                       Item05 = c('carne', '', 'ovo', '', '', 'alface', 'macarrão', '', '', '', 'couve-flor', 'carne', 'beterraba', 'beterraba', 'beterraba', 'ovo', 'couve-flo', 'requeijão', 'queijo', 'presunto', 'calabresa', 'cebola', 'alho', 'ovo', 'abacate', '', '', '', '', '', '', '', ''),
                       Item06 = c('ovo', 'arroz', 'feijão', '', '', 'carne', '', '', '', '', '', '', '', '', '', 'queijo', '', 'cenoura', 'beterraba', '', '', 'queijo', 'queijo', 'requeijão', 'ovo', 'café', 'café', 'café', '', '', '', '', ''),
                       Item07 = c('limão', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'queijo', 'presunto', '', 'salame', 'beterraba', '', '', '', '', '', '', '', ''),
                       Item08 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'salame', '', '',        '', '', '', '', '', '', '', '', '', ''),
                       Item09 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',        '', '', '', '', '', '', '', '', '', '')
)

dados2 <- data.frame(Item01 = c('café', 'café', 'café', 'café', 'café', 'café', 'café', 'café', 'café', 'café'),
                     Item02 = c('leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'leite', 'açúcar'),
                     Item03 = c('açúcar', 'açúcar', 'açúcar', 'açúcar', 'açúcar', 'adoçante', 'açúcar', 'açúcar', 'açúcar', 'adoçante'),
                     Item04 = c('filtro', 'filtro', 'filtro', 'filtro', 'filtro', 'filtro', 'biscoito', 'biscoito', 'biscoito', 'salame'),
                     Item05 = c('pão', 'pão', 'pão', 'pão', 'pão', 'biscoito', '', '', '', ''),
                     Item06 = c('biscoito', 'biscoito', 'biscoito', 'adoçante', 'adoçante', '', '', '', '', ''),
                     Item07 = c('', '', '', '', '', '', '', '', '', ''),
                     Item08 = c('', '', '', '', '', '', '', '', '', ''),
                     Item09 = c('', '', '', '', '', '', '', '', '', '')
)


dados3 <- data.frame(Item01 = c('macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão', 'macarrão'),
                     Item02 = c('queijo ralado', 'queijo ralado', 'queijo ralado', 'queijo ralado', 'queijo ralado', 'ketchup', 'ketchup', 'ketchup', 'ketchup', ''),
                     Item03 = c('ketchup', 'ketchup', 'alho', 'alho', 'alho', 'frango', 'frango', 'carne', '', ''),
                     Item04 = c('alho', 'alho', 'carne', '', '', '', '', '', '', ''),
                     Item05 = c('ovo', 'calabresa', '', '', '', '', '', '', '', ''),
                     Item06 = c('calabresa', 'salame', 'frango', '', '', '', '', '', '', ''),
                     Item07 = c('', '', '', '', '', '', '', '', '', ''),
                     Item08 = c('', '', '', '', '', '', '', '', '', ''),
                     Item09 = c('', '', '', '', '', '', '', '', '', '')
)


dados4 <- data.frame(Item01 = c('pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza'),
                     Item02 = c('ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'alho', 'alho', ''),
                     Item03 = c('queijo', 'alho', 'queijo', 'alho', 'quejo', 'alho', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', ''),
                     Item04 = c('refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'palito', 'palito', 'palito', 'palito', 'palito', 'guardanapo', 'guardanapo', '', ''),
                     Item05 = c('guardanapo', 'guardanapo', 'palito', 'guardanapo', 'palito', 'guardanapo', 'palito', 'guardanapo', 'guardanapo', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', '', '', '', '', ''),
                     Item06 = c('calabresa', 'calabresa', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'cebola', 'cebola', 'cebola', 'cebola', 'cebola', 'cebola', '', ''),
                     Item07 = c('salame', 'salame', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', '', '', '', '', '', '', '', '', '', ''),
                     Item08 = c('cebola', 'cebola', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item09 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')
)


dados5 <- data.frame(Item01 = c('cerveja', '', 'cerveja', '', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', 'cerveja', ''),
                     Item02 = c('gelo', '', 'gelo', '', 'gelo', 'gelo', 'gelo', 'gelo', 'gelo', 'gelo', 'calabresa', 'gelo', 'gelo', '', 'gelo', '', '', '', '', ''),
                     Item03 = c('calabresa', '', 'calabresa', '', 'calabresa', 'calabresa', 'calabresa', 'limão', 'limão', 'sal', 'limão', 'limão', '', '', '', '', '', '', '', ''),
                     Item04 = c('carvão', '', 'carvão', '', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', 'carvão', '', '', ''),
                     Item05 = c('pão', '', 'pão', '', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', 'pão', '', '', '', '', '', ''),
                     Item06 = c('refrigerante', '', 'refrigerante', '', 'refrigerante', 'refrigerante', 'refrigerante', 'salame', 'salame', 'refrigerante', 'salame', '', '', '', '', '', '', '', '', ''),
                     Item07 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item08 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item09 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')
)





dados_final <- rbind(dados_df, dados2, dados3, dados4, dados5)


# Salvando em disco
write_csv(dados_final, 'dados_compras_supermercado.csv')



# Carregando e explorando o dataset

dados <- read.csv("dados_compras_supermercado.csv", fileEncoding = "UTF-8")


dim(dados)   # 93 Linhas 9 Colunas
str(dados)   


# Nossa verificação é baseada na regra de negócio para aplicação do Masket Basket Analysis


# Verificando se possui linhas vazias de forma geral
any(apply(dados, 1, function(x) all(is.na(x) | x == "")))

# Verifica se cada linha tem todos os valores ausentes (NA) ou vazios ("")
todas_na <- apply(dados, 1, function(x) all(is.na(x) | x == ""))
todas_na

# Exibe as linhas que possuem todos os valores ausentes
dados[todas_na, ]

# Exclui todas as linhas com valores ausentes (NA) e vazios ("")
dados_final <- dados[-which(todas_na), ]


dim(dados_final) # 90 Linhas 9 Colunas


# Verifica se alguma coluna possui somente valores NA
col_com_todos_na <- colnames(dados_final)[which(colSums(is.na(dados_final)) == nrow(dados_final))]
col_com_todos_na




