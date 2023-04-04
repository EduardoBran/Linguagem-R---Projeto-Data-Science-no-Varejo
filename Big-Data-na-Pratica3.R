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


# foi detectado diversas linhas com todos os valores de colunas em branco (devem ser removidas)
# foi detectado um padrão dessas linhas em branco: 1 linha tem algum conteúdo, 1 linha está toda em branco, 1 linha tem algum conteúdo, 1 linha está toda em branco


# 1ª forma de remover as linhas com todos os valores em branco (por conta do padrão vamos separar as linhas pares das linhas ímpares)

linhas_pares <- seq(2, nrow(dados), 2)      # No caso de linhas_pares, a sequência começa no número 2, que é a segunda linha do data frame, e termina no número de linhas do data frame (nrow(dados)), com incrementos de 2. Isso significa que a variável linhas_pares contém os números das linhas pares do data frame dados.
linhas_impares <- seq(1, nrow(dados), 2)

View(linhas_pares)

# separamos os dados e então criaremos o dataset df1 com as linhas pares (linhas onde tem dados válidos)

df1 <- dados[linhas_pares, ]
View(df1)
df2 <- dados[linhas_impares, ]
View(df2) 


# 2ª forma de remover as linhas com todos os valores em branco

dados2 <- dados

# converter todas as células para caracteres e remover espaços em branco

dados2 <- as.data.frame(lapply(dados2, as.character), stringsAsFactors = FALSE)
dados2 <- as.data.frame(lapply(dados2, trimws))

# remover linhas com valores em branco em todas as colunas

dados2 <- dados2[rowSums(dados2 != "") > 0, ]



# Verifica se tem valores NA (valores ausentes) especificamente para a primeira coluna 'Item01'
# Essa verificação é importante para a lógica do negócio, afinal não faz sentido ter algum tipo de valor NA na primeira coluna (seria o primeiro item da compra, sem isso não teria compra)


# 1ª forma
sum(is.na(df1$Item01))                    # retorna a quantidade de valores iguais a NA na coluna Item01 

# 2º forma
any(is.na(df1$Item01) | df1$Item01 == "") # retorna um valor lógico (aqui retorna FALSE) indicando se há pelo menos um valor NA ou em branco (com caracter espaço)



# Verifica se tem valores NA (valores ausentes) especificamente para a segunda coluna 'Item02'
# Neste caso, na 1ª forma ainda vai dar 0 pois ele verifica apenas ausencia de dados, e estar em branco significa que posso ter o caracter espaço, ou seja ainda temos dados.
# Na 2ª forma, tanto os valores NA quanto os valores em branco (com ou sem caracteres de espaço) serão detectados.


# 1ª forma
sum(is.na(df1$Item02))                    # retorna 0

# 2º forma
any(is.na(df1$Item02) | df1$Item02 == "") # retorna TRUE



# Verificando se termos valores ausentes representados por espaço em branco
# Como na 1º forma da coluna Item02 retornou 0, teremos que mudar a forma de checagem para detectar valores em branco (caracter espaço)

which(nchar(trimws(df1$Item01))==0)  # coluna Item01 (retorna 0) 
which(nchar(trimws(df1$Item02))==0)  # coluna Item02 (retorna a posição dos elementos do vetor onde o número de caracteres é igual a zero, a linha 10 do data frame "df1" contém uma string vazia na coluna "Item02", e é por isso que essa linha é retornada pelo código mencionado.)


# Verificando se termos valores ausentes representados por espaço em branco (usando expressão regular)
# Mesma coisa acima só que usando expressão regular (agora retorna TRUE ou FALSE)

grepl("^\\s*$", df1$Item01) # retorna tudo FALSE
grepl("^\\s*$", df1$Item02) # retorna TRUE quando tiver valores ausentes representados por espaço em branco



# Agora vamos interpretar nosso dataframe para tomarmos uma decisão.

# Observando a linha 6, podemos ver que foi comprado apenas 1 produto e todas as outras colunas desta linha estão vazias
# Faz sentido manter esta linha 6 sabendo que nosso objetivo é encontrar padrões (cliente que compra produto A também compra produto B) ?
# Se só temos 1 produto na transação, faria sentido manter esta transação ? Como buscaremos um relacionamento / padrão de compra?

# Neste caso então chegamos a conclusão que não faz sentido manter qualquer transação (linha) onde a coluna Item02 está vazia.
# Se não manteríamos transações com apenas 1 produto comprado, logo não conseguiríamos ver nenhum padrão.


# Verificando número de itens distintos (retorna um número inteiro que indica a quantidade total de valores distintos encontrados em todo o dataframe df1)
# Ee você tem um vetor com os valores 1, 2, 2, 3, 4, a função n_distinct() irá retornar o valor 4, pois existem 4 valores distintos nesse vetor.

n_distinct(df1)


# Vamos trabalhar somente com os registros onde o item 2 não for nulo


# criando um novo df a partir do df original "df1", removendo todas as linhas em que a coluna "Item02" contém valores ausentes representados por espaço em branco.

df1_two <- df1[!grepl("^\\s*$", df1$Item02), ]
df1_two <- subset(df1, !grepl("^\\s*$", Item02)) # 2ª forma



# Verificando novamente número de itens distintos

n_distinct(df1_two)



# Até aqui mantivemos no nosso dataframe 'df1_tow' transações somente onde houveram a compra de pelo menos 2 produtos
# Ou seja, somente onde as colunas Item01 e Item02 foram preenchidas. As outras colunas podem ficar em branco pois estamos considerando no mínimo 2 transações.



# Agora vamos novamente interpretar nosso dataframe para tomarmos outra decisão.

# Faz sentido manter todas as 20 colunas? 
# Não precisaremos. Um dos motivos é que observando o dataframe, são poucas as colunas totalmente preenchidas.
# Logo se usarmos as 20 colunas, teremos uma matriz muito esparsa com muitos valores em branco.
# Neste caso iremos diminuir nossa esparsidade e trabalharemos com apenas 6 colunas (escolha do professor).



# Preparando o pacote convertendo as variáveis (colunas) para o tipo fator

# - Estamos convertendo as colunas do dataframe para o tipo fator porque isso é necessário para realizar a análise de market basket (análise de cestas de compras).
# - A análise de market basket envolve a criação de uma matriz de cesta de compras, em que cada linha representa uma transação (ou venda)
#   e cada coluna representa um item (produto) que pode estar presente ou não na transação. Para criar essa matriz, precisamos que as
#   colunas sejam do tipo fator, para que o software possa identificar os diferentes níveis (valores) presentes em cada coluna.
# - Além disso, o tipo fator é mais eficiente do que o tipo caractere (ou string) para armazenar variáveis categóricas com um número
#   limitado de níveis, pois ocupa menos espaço em memória e permite que operações de comparação e ordenação sejam executadas mais
#   rapidamente.


pacote <- df1_two
str(pacote)

# convertendo as primeiras 6 colunas para o tipo factor

pacote$Item01 <- as.factor(pacote$Item01)
pacote$Item02 <- as.factor(pacote$Item02)
pacote$Item03 <- as.factor(pacote$Item03)
pacote$Item04 <- as.factor(pacote$Item04)
pacote$Item05 <- as.factor(pacote$Item05)
pacote$Item06 <- as.factor(pacote$Item06)

str(pacote)
summary(pacote)

# filtrando / fazendo um split somente nas colunas que nos interessam (cria uma lista)
# será necessário esta lista para a continuação do projeto

pacote_split <- split(pacote$Item01, 
                      pacote$Item02,
                      pacote$Item03, 
                      pacote$Item04,
                      pacote$Item05, 
                      pacote$Item06,
                      drop = FALSE)



# Até aqui fizemos a escolha de trabalharmos somente com transações com no mínimo 2 produtos até 6 produtos.


# Após a organização dos dados, podemos então extrair as regras de associação.


# Extraindo as regras de associação

# Para isso vamos usar o algoritimo/função apriori() que está no pacote 'arules'.
# Está função espera receber os dados no formato / na classe do tipo transações (na classe transactions)

# Forçando um objeto a pertencer a outra classe através da função as()

transacoes <- as(pacote_split, "transactions")

# Inspecionando as regras através da função inspect() (aqui ainda está no formato geral pois ainda não definimos as regras)

inspect(head(transacoes, 5))






