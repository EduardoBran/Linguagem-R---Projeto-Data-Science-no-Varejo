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


dados4 <- data.frame(Item01 = c('pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza', 'pizza'),
                     Item02 = c('ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'ketchup', 'alho', 'alho', '', 'alho', 'alho', 'alho', 'alho', 'ketchup', 'alho', 'ketchup', 'alho', 'alho'),
                     Item03 = c('queijo', 'alho', 'queijo', 'alho', 'quejo', 'alho', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', 'mostarda', '', '', '', '', 'ketchup', 'alho', 'ketchup', 'alho', '', ''),
                     Item04 = c('refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'refrigerante', 'palito', 'palito', 'palito', 'palito', 'palito', 'guardanapo', 'guardanapo', '', '', '', '', '', '', '', '', '', '', ''),
                     Item05 = c('guardanapo', 'guardanapo', 'palito', 'guardanapo', 'palito', 'guardanapo', 'palito', 'guardanapo', 'guardanapo', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item06 = c('calabresa', 'calabresa', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'calabresa', 'cerveja', 'cebola', 'cebola', 'cebola', 'cebola', 'cebola', 'cebola', '', '', '', '', '', '', '', '', '', '', ''),
                     Item07 = c('salame', 'salame', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', 'salame', 'milho', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item08 = c('cebola', 'cebola', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''),
                     Item09 = c('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')
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

# Verifica se cada linha possui somentes valores ausentes (NA) ou vazios ("")
todas_na <- apply(dados, 1, function(x) all(is.na(x) | x == ""))
todas_na

# Exibe as linhas que possuem todos os valores ausentes
dados[todas_na, ]

# Exclui todas as linhas com valores ausentes (NA) e vazios ("")
dados_final <- dados[-which(todas_na), ]


dim(dados_final) # 90 Linhas 9 Colunas


# Verifica se alguma coluna possui somente valores NA exibe o nome dessa coluna
col_com_todos_na <- colnames(dados_final)[which(colSums(is.na(dados_final)) == nrow(dados_final))]
col_com_todos_na

# Exclui a coluna Item09
dados_final <- dados_final[, -which(colnames(dados_final) == "Item09")]



# Verifica se tem valores NA (valores ausentes) especificamente para a primeira coluna 'Item01'

# 1ª forma
sum(is.na(dados_final$Item01))                            # retorna a quantidade de valores iguais a NA na coluna Item01 

# 2º forma
any(is.na(dados_final$Item01) | dados_final$Item01 == "") # retorna um valor lógico (aqui retorna FALSE) indicando se há pelo menos um valor NA ou em branco (com caracter espaço)


# Verifica se tem valores NA (valores ausentes) especificamente para a segunda coluna 'Item02'

# 1ª forma
sum(is.na(dados_final$Item02))                            # retorna a quantidade de valores iguais a NA na coluna Item02 (ainda vai retornar 0 pois não está verificando o "") 

# 2º forma
any(is.na(dados_final$Item02) | dados_final$Item02 == "") # retorna um valor lógico (aqui retorna TRUE) indicando se há pelo menos um valor NA ou em branco (com caracter espaço)


# Verificando se termos valores ausentes representados por espaço em branco
which(nchar(trimws(dados_final$Item01))==0)  # coluna Item01 (retorna 0) 
which(nchar(trimws(dados_final$Item02))==0)  # coluna Item02 (retorna a posição dos elementos do vetor onde o número de caracteres é igual a zero, a linha 10 do data frame "df1" contém uma string vazia na coluna "Item02", e é por isso que essa linha é retornada pelo código mencionado.)

# Verificando se termos valores ausentes representados por espaço em branco (usando expressão regular)
grepl("^\\s*$", dados_final$Item01) # retorna tudo FALSE
grepl("^\\s*$", dados_final$Item02) # retorna TRUE quando tiver valores ausentes representados por espaço em branco


# Vamos trabalhar somente com os registros onde o item 2 não for nulo


# Removendo todas as linhas em que a coluna "Item02" contém valores ausentes representados por espaço em branco.
dados <- dados_final[!grepl("^\\s*$", dados_final$Item02), ]



# Até aqui mantivemos no nosso dataframe 'dados' transações somente onde houveram a compra de pelo menos 2 produtos


# Iremos trabalhar com apenas 6 colunas


# Preparando o pacote convertendo as 6 variáveis (colunas) para o tipo fator (necessário para a análise MBA)

pacote <- dados
str(pacote)

View(pacote)

pacote$Item01 <- as.factor(pacote$Item01)
pacote$Item02 <- as.factor(pacote$Item02)
pacote$Item03 <- as.factor(pacote$Item03)
pacote$Item04 <- as.factor(pacote$Item04)
pacote$Item05 <- as.factor(pacote$Item05)
pacote$Item06 <- as.factor(pacote$Item06)

str(pacote)

# filtrando / fazendo um split somente nas colunas que nos interessam (cria uma lista)
# será necessário esta lista para criar o objeto de transações mais adiante (não funciona se toda uma coluna tiver somente valores NA)

pacote_split <- split(pacote$Item01, 
                      pacote$Item02,
                      pacote$Item03, 
                      pacote$Item04,
                      pacote$Item05, 
                      pacote$Item06,
                      drop = FALSE)

pacote_split



# Até aqui fizemos a escolha de trabalharmos somente com transações com no mínimo 2 produtos até 6 produtos.


# Extraindo as regras de associação

# Para isso vamos usar o algoritimo/função apriori() que está no pacote 'arules'.
# Está função espera receber os dados no formato / na classe do tipo transações (na classe transactions)


# Forçando um objeto a pertencer a outra classe através da função as()

transacoes <- as(pacote_split, "transactions")

# Inspecionando as regras através da função inspect() (aqui ainda está no formato geral pois ainda não definimos as regras)

inspect(head(transacoes, 5))


# Vamos definir as regras de modo mais refinado, com base em métricas através da funcao apriori()
# Será necessário a escolha de um dos produtos para ser usado como ponto de partida ("café")

regras_produto_limao <- apriori(transacoes,
                                parameter = list(conf = 0.5, minlen = 2, supp = 0.01),
                                appearance = list(default = 'lhs', rhs = 'limao'))

inspect(head(sort(regras_produto_limao, by = 'confidence'), 5))













