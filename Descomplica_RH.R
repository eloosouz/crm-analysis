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
