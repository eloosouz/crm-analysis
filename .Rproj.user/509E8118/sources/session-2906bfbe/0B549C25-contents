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


