#Invocando a biblioteca para computar indicadores usando SQL
library(sqldf)

# Segmentando clientes de 2015

dados$Data_Compra <- as.Date(dados$Data_Compra, format = "%Y-%m-%d")
dados$dias_desde <- as.numeric(as.Date("2015-12-31") - dados$Data_Compra)  

clientes_2015 = sqldf("SELECT ID_cliente,
                       MIN(dias_desde)  AS 'recencia',
                       MAX(dias_desde) AS 'primeira_compra',
                       COUNT(*) AS 'frequencia',
                       AVG(Quantia_compra) AS 'quantia'
                       FROM dados GROUP BY 1")


# 4. Segmentação dos Clientes de 2015
clientes_2015

clientes_2015$segment = "NA"
clientes_2015$segment[which(clientes_2015$recencia >  365*3)] = "inativo"
clientes_2015$segment[which(clientes_2015$recencia <= 365*3 & clientes_2015$recencia > 365*2)] = "frio"
clientes_2015$segment[which(clientes_2015$recencia <= 365*2 & clientes_2015$recencia > 365*1)] = "quente"
clientes_2015$segment[which(clientes_2015$recencia <= 365)] = "ativo"
clientes_2015$segment[which(clientes_2015$segment == "quente" & clientes_2015$primeira_compra <= 365*2)] = "novo quente"
clientes_2015$segment[which(clientes_2015$segment == "quente" & clientes_2015$quantia < 100)] = "quente baixo valor"
clientes_2015$segment[which(clientes_2015$segment == "quente" & clientes_2015$quantia > 100)] = "quente alto valor"
clientes_2015$segment[which(clientes_2015$segment == "ativo" & clientes_2015$primeira_compra <= 365)] = "novo ativo"
clientes_2015$segment[which(clientes_2015$segment == "ativo" & clientes_2015$quantia < 100)] = "ativo baixo valor"
clientes_2015$segment[which(clientes_2015$segment == "ativo" & clientes_2015$quantia > 100)] = "ativo alto valor"
clientes_2015$segment = factor(x = clientes_2015$segment, levels = c("inativo", "frio", "quente baixo valor", "quente alto valor", "novo quente", "ativo baixo valor", "ativo alto valor", "novo ativo"))


# Segmentando clientes de 2014
clientes_2014 = sqldf("SELECT ID_cliente,
                       MIN(dias_desde) - 365 AS 'recencia',
                       MAX(dias_desde) - 365 AS 'primeira_compra',
                       COUNT(*) AS 'frequencia',
                       AVG(Quantia_Compra) AS 'quantia'
                       FROM dados
                       WHERE dias_desde > 365
                       GROUP BY 1")

clientes_2014$segment = "NA"
clientes_2014$segment[which(clientes_2014$recencia >  365*3)] = "inativo"
clientes_2014$segment[which(clientes_2014$recencia <= 365*3 & clientes_2014$recencia > 365*2)] = "frio"
clientes_2014$segment[which(clientes_2014$recencia <= 365*2 & clientes_2014$recencia > 365*1)] = "quente"
clientes_2014$segment[which(clientes_2014$recencia <= 365)] = "ativo"
clientes_2014$segment[which(clientes_2014$segment == "quente" & clientes_2014$primeira_compra <= 365*2)] = "novo quente"
clientes_2014$segment[which(clientes_2014$segment == "quente" & clientes_2014$quantia < 100)] = "quente baixo valor"
clientes_2014$segment[which(clientes_2014$segment == "quente" & clientes_2014$quantia > 100)] = "quente alto valor"
clientes_2014$segment[which(clientes_2014$segment == "ativo" & clientes_2014$primeira_compra <= 365)] = "novo ativo"
clientes_2014$segment[which(clientes_2014$segment == "ativo" & clientes_2014$quantia < 100)] = "ativo baixo valor"
clientes_2014$segment[which(clientes_2014$segment == "ativo" & clientes_2014$quantia > 100)] = "ativo alto valor"
clientes_2014$segment = factor(x = clientes_2014$segment, levels = c("inativo", "frio", 
                                                                     "quente baixo valor", "quente alto valor", "novo quente", 
                                                                     "ativo baixo valor", "ativo alto valor", "novo ativo"))


# computando a matriz de transição
novos_dados = merge(x = clientes_2014, y = clientes_2015, by = "ID_cliente", all.x = TRUE)
head(novos_dados)

transicao = table(novos_dados$segment.x, novos_dados$segment.y)
print(transicao)

# Dividindo cada linha por sua soma
transicao = transicao / rowSums(transicao)
print(transicao)

# usando a matriz de transição para previsão

#Iniciando a matriz com o número de clientes em cada segmento e depois de 10 ciclos
segments = matrix(nrow = 8, ncol = 11)
segments[, 1] = table(clientes_2015$segment)
colnames(segments) = 2015:2025
row.names(segments) = levels(clientes_2015$segment)
print(segments)

# Computando para cada  periodo
for (i in 2:11) {
  segments[, i] = segments[, i-1] %*% transicao
}

# plotando os clientes  inativos, ativos e ativos de alto valor
barplot(segments[1, ])
barplot(segments[2, ])

# mostrando como segmentos evoluem com o tempo
print(round(segments))

#Calculando o Costumer life time value / valor de tempo como cliente (CLV)

# Receita por segmento

# Aqui, tentaremos colocar o valor em dólares em nosso banco de dados atribuindo
# receita a alto valor ativo (US$ 323), baixo valor ativo (US$ 52) e
# novos clientes ativos (US$ 79), pois outros segmentos de clientes não contribuirão
# para a receita. Usaremos a receita média por segmento ativo de
# clientes para avaliar o banco de dados de clientes.

receita_anual = c(0, 0, 0, 0, 0, 323.57, 52.31, 79.17)

receita_anual

# Computando receita por ano
receita_segmento = receita_anual * segments
print(receita_segmento)

# Compute yearly revenue
receita_anual = colSums(receita_segmento)
print(round(receita_anual))

print(receita_anual)
barplot(receita_anual)

# Calculando a receita acumulada
receita_acumulada = cumsum(receita_anual)
print(round(receita_acumulada))

# Criando o fator de desconto anual de 10%
taxa_desconto = 0.10
desconto = 1 / ((1 + taxa_desconto) ^ ((1:11) - 1))
print(desconto)

# Computando a receita anual descontada
desc_receita_anual = receita_anual * desconto
print(round(desc_receita_anual))
barplot(desc_receita_anual)
lines(receita_anual)

print(round(14.7))
print(14.7)


# Computando a receita acumulada
disc_receita_acumulada = cumsum(desc_receita_anual)
print(round(disc_receita_acumulada))
barplot(disc_receita_acumulada)

# Quanto rende nossa base de clientes?
print(disc_receita_acumulada[11] - receita_anual[1])

print(disc_receita_acumulada[8])
