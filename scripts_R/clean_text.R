source("config/config.R")

# Manipulação de dados tabulares (data.frame, tibble).
library(dplyr)      

# Manipulação de strings com funções padronizadas e seguras.
library(stringr)   

# Biblioteca de baixo nível para processamento de texto Unicode.
library(stringi)    

# Pacote da linguagem R projetado para facilitar a mineração e análise de texto. 
library(tidytext)   

# Pacote amplamente utilizado em tarefas de mineração de texto. 
library(SnowballC) 

# Leitura rápida e segura de arquivos.
library(readr)   

# O pacote tm (Text Mining) é uma estrutura abrangente para mineração de texto.
library(tm)        


# ----------------------------------------------------------------------------
# Função: clean_text
# Objetivo:
#   Realizar a limpeza, normalização, tokenização e stemização de textos
#   jurídicos para posterior análise NLP (TF-IDF, LDA, etc.).
#
# Parâmetros:
#   text     : data.frame ou tibble contendo a coluna 'texto'
#   encoding : encoding original do texto (ex: "UTF-8", "latin1")
#   language : idioma para stopwords (ex: "pt", "en")
#   text_col : nome da coluna 
#
# Retorno:
#   Tibble contendo tokens limpos e a coluna 'work_stem'
#
# Observações:
#   - Remove acentuação, números e pontuação
#   - Elimina stopwords gerais e jurídicas
#   - Aplica stemização (Porter)
#   - Salva o resultado em disco para reprodutibilidade
# ----------------------------------------------------------------------------

clean_text <- function(text, encoding, language, text_col) {
  
  tryCatch({
    
    # Registro de início do processo
    log_message("Iniciando limpeza do texto")
    
    # Validações de entrada (programação defensiva)
    if (!inherits(text, "data.frame")) {
      stop("O objeto 'text' deve ser um data.frame ou tibble.")
    }
    
    if (!"text_col" %in% colnames(text)) {
      stop("A coluna obrigatória 'texto' não foi encontrada.")
    }
    
    # Definição de stopwords específicas do domínio jurídico
    stopwords_juridicas <- c(
      "lei", "leis", "artigo", "artigos",
      "caput", "parágrafo", "paragrafo",
      "inciso", "incisos", "alínea", "alinea",
      "dados", "disposições", "disposicoes",
      "nos", "nº", "no", "nr", "§", "capítulo",
      "capítulos", "CAPITULO", "CAPITULOS"
    )
    
    # -------------------------------------------------------------------------
    # Limpeza textual e tokenização
    # -------------------------------------------------------------------------
    # Etapas:
    #   1. Normalização de encoding
    #   2. Conversão para minúsculas
    #   3. Remoção de números e pontuação
    #   4. Normalização de espaços
    #   5. Tokenização em palavras
    #   6. Remoção de tokens irrelevantes
    #   7. Stemização
    # -------------------------------------------------------------------------
    tokens <- text %>%
      mutate(
        text_col = iconv(text_col, from = encoding, to = "ASCII", sub = ""),
        text_col = str_to_lower(text_col),
        text_col = str_remove_all(text_col, "[0-9]+"),
        text_col = str_remove_all(text_col, "[[:punct:]]"),
        text_col = str_squish(text_col)
      ) %>%
      filter(!stringi::stri_isempty(stringi::stri_trim_both(text_col))) %>%
      unnest_tokens(work, text_col) %>%
      filter(
        nchar(work) > 3,
        !work %in% stopwords(language),
        !work %in% stopwords_juridicas
      ) %>%
      mutate(
        work_stem = SnowballC::wordStem(work, language = "porter")
      )
    
    # Persistência dos dados processados
    write_csv(tokens, file.path(PATH_PROCESSED, "text_processed.csv"))

    # Registro de fim do processo
    log_message("Texto limpo, tokenizado, stemizado e salvo com sucesso")
    
    # Retorna explicitamente o tibble estruturado,
    # garantindo previsibilidade no fluxo da função.
    return(tokens)
    
  },
  error = function(e) {
    
    # Registro de erro e interrupção explícita do pipeline
    log_message(paste("ERRO na função clean_text:", e$message))
    stop(e)
    
  },
  warning = function(w) {
    
    # Registro e silenciamento controlado de warnings
    log_message(paste("AVISO na função clean_text:", w$message))
    invokeRestart("muffleWarning")
  })
}


