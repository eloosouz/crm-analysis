# CRM Analysis

Análise preditiva de clientes em R, utilizando SQL para calcular indicadores de recência, frequência e valor de compra (RFM).

## 📊 Sobre o Projeto

Este projeto tem como objetivo demonstrar o uso da biblioteca `sqldf` do R para realizar consultas SQL diretamente em dataframes, calculando métricas essenciais de CRM.

O projeto vai além da análise estática, aplicando um modelo de **Cadeia de Markov** para calcular a matriz de transição entre os segmentos de clientes. Com isso, é possível projetar quantos clientes existirão em cada segmento nos próximos 10 anos e calcular a receita descontada (VPL - Valor Presente Líquido) gerada por essa base de clientes.

## 🛠️ Tecnologias Utilizadas

- R
- RStudio
- Pacote `sqldf`
- Git e GitHub

## 📁 Arquivos

- `Descomplica_RH.R`: Script principal contendo toda a lógica de análise, incluindo:
  - Cálculo de indicadores RFM (Recência, Frequência e Valor).
  - Segmentação de clientes (2014 e 2015).
  - Matriz de transição de segmentos.
  - Projeção de receita anual por 10 anos.
  - Cálculo de Customer Lifetime Value (CLV) com fator de desconto.

- `vendas_amostra.txt`: Amostra dos dados utilizados para teste do código.

## 🚀 Como executar

1. Clone o repositório.
2. Abra o arquivo `Descomplica_RH.R` no RStudio.
3. Certifique-se de ter o pacote `sqldf` instalado (`install.packages("sqldf")`).
4. Execute o script.

## 📈 Resultados

- Evolução e projeção dos segmentos de clientes ao longo de 10 anos.
- Receita anual projetada e receita acumulada descontada.
- Valor total projetado da base de clientes.
