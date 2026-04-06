# Arquivo: 02-importacao-manipulacao.R
# Autor(a): Washington S. Silva
# Data: 30/03/26
# Objetivos:
# 1. Importar um arquivo csv de dados
# 2. Preparar os dados para análise
# 3. Aprender as funções básicas de manipulação de dados do pacote dplyr


# Configurações globais ---------------------------------------------------

# Configura o número de dígitos a serem exibidos
options(digits = 5, scipen = 999)

# carrega os pacotes necessários
library(here) # para usar caminhos relativos
library(tidyverse) # carrega o dplyr, readr, ggplot2, etc.
library(janitor) # para limpar os nomes das colunas


# Aquisição dos dados ----------------------------------------------------

# define o caminho relativo do arquivo de dados
caminho_csv <- here("dados/brutos/dados_vendas.csv")

# importa o arquivo usando a função read_csv do pacote readr
dados_vendas <- read_csv(caminho_csv)


# Entendimento dos dados --------------------------------------------------

# exibe uma visão compacta do objeto
glimpse(dados_vendas)

# exibe as primeiras linhas
head(dados_vendas)

# exibe as últimas linhas
tail(dados_vendas)

# resumo estatístico das colunas
summary(dados_vendas)


# Preparação dos dados ----------------------------------------------------

# pipeline de preparação dos dados
dados_vendas_limpos <- dados_vendas |>
  # limpa os nomes das colunas/variáveis
  clean_names() |>
  # converte as variáveis para fatores nominais
  # e cria a variável receita
  mutate(
    cidade = as.factor(cidade),
    representante = as.factor(representante),
    produto = as.factor(produto),
    receita = unidades * preco_unitario
  )

# verifica a estrutura dos dados
glimpse(dados_vendas_limpos)

# salva os dados limpos em um arquivo rds para 
# análises futuras sem precisar repetir a preparação 
# dos dados

## 1. define o caminho relativo para salvar o arquivo rds
caminho_rds <- here("dados/limpos/dados_vendas_limpos.rds")

## 2. salva o objeto dados_vendas_limpos no formato rds
readr::write_rds(dados_vendas_limpos, caminho_rds)


# Lendo os dados limpos em uma seção futura

## 1. define o caminho relativo do arquivo rds
caminho_rds <- here("dados/limpos/dados_vendas_limpos.rds")

## 2. lê o arquivo rds e armazena em um objeto
dados_vendas_limpos <- readr::read_rds(caminho_rds)



# A função filter ---------------------------------------------------------

# filtra as vendas realizadas na cidade de "Formiga"
dados_vendas_limpos |>
  filter(cidade == "Formiga")


# filtra as vendas realizadas por um representante específico
dados_vendas_limpos |>
  filter(representante == "Representante 1")


# filtra as vendas realizadas em Formiga por um representante específico
dados_vendas_limpos |>
  filter(cidade == "Formiga" & representante == "Representante 1")


# filtra as vendas realizadas em Formiga ou em Arcos com o operador |
dados_vendas_limpos |>
  filter(cidade == "Formiga" | cidade == "Arcos")

# filtra as mesmas vendas usando %in%, uma forma mais compacta
# para múltiplas comparações da mesma variável
dados_vendas_limpos |>
  filter(cidade %in% c("Formiga", "Arcos"))


# salva o resultado em um novo objeto
dados_vendas_formiga_arcos <- dados_vendas_limpos |>
  filter(cidade %in% c("Formiga", "Arcos"))


# exibe o resultado
dados_vendas_formiga_arcos


# A função select ---------------------------------------------------------

# seleciona apenas as colunas cidade, produto e receita
dados_vendas_limpos |>
  select(cidade, produto, receita)

# remove as coluna representante e cidade
dados_vendas_limpos |>
  select(-representante, -cidade)

# salvando o resultado em um novo objeto
dados_vendas_selecionados <- dados_vendas_limpos |>
  select(cidade, produto, receita)

# exibe o resultado
dados_vendas_selecionados


# A função mutate ---------------------------------------------------------

# cria a variável preco_desconto (10% sobre o preço_unitario)
dados_vendas_limpos |>
  mutate(preco_desconto = preco_unitario * 0.9)


# cria a variável "receita_total" multiplicando unidades por preco_unitario
dados_vendas_limpos |>
  mutate(receita_total = unidades * preco_unitario)


# cria a variável receita total, agrupa por cidade e ordena por receita total
dados_vendas_limpos |>
  mutate(receita_total = unidades * preco_unitario) |>
  group_by(cidade) |>
  summarise(receita_total_cidade = sum(receita_total)) |>
  arrange(desc(receita_total_cidade))


# cria a variável "categoria_receita" com duas categorias
dados_vendas_limpos |>
  mutate(categoria_receita = ifelse(receita > 1000, "Alta", "Baixa")) |>
  select(cidade, produto, categoria_receita)


# cria a variável "categoria_receita" com múltiplas categorias
dados_vendas_limpos |>
  mutate(categoria_receita = case_when(
    receita > 1000 ~ "Alta",
    receita > 500 & receita <= 1000 ~ "Média",
    receita > 0 & receita <= 500 ~ "Baixa",
    TRUE ~ "Sem Receita"
  )) |>
  select(cidade, produto, categoria_receita)



























