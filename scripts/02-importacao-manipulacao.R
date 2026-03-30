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



























