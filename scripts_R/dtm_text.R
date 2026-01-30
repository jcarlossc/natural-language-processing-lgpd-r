# O pacote tm (Text Mining) transforma dados textuais não estruturados 
# em uma matriz de documentos-termos (Document-Term Matrix), facilitando 
# a mineração de texto e análises de frequência. 
library(tm)

# Manipulação de dados tabulares (data.frame, tibble).
library(dplyr)

# ============================================================
# Script: create_dtm.R
# Objetivo: Criar uma Document-Term Matrix (DTM)
# Entrada : data.frame/tibble com texto limpo e stemizado
# Saída   : DocumentTermMatrix (tm)
# ============================================================

# ------------------------------------------------------------
# Função: create_dtm
# ------------------------------------------------------------
# data         -> tibble/data.frame contendo os textos
# text_col     -> nome da coluna com texto final (ex: "word_stem")
# doc_id_col   -> nome da coluna identificadora do documento
# min_term_freq-> frequência mínima de termos
# ------------------------------------------------------------
create_dtm <- function(
    data,
    text_col = "word_stem",
    doc_id_col = "id",
    min_term_freq = 2
) {
  
  tryCatch({
    
    # Registro de início do processo DTM.
    log_message("Iniciando processamento DTM.")
    
    # Validação de entrada
    if (!is.data.frame(data)) {
      stop("O objeto 'data' deve ser um data.frame ou tibble.")
    }
    
    if (!text_col %in% colnames(data)) {
      stop(paste("Coluna de texto não encontrada:", text_col))
    }
    
    if (!doc_id_col %in% colnames(data)) {
      stop(paste("Coluna de ID não encontrada:", doc_id_col))
    }
    
    if (nrow(data) == 0) {
      stop("O data.frame está vazio.")
    }
    

    # Preparação do corpus
    # A DTM trabalha com documentos em formato character
    texts <- data %>%
      arrange(.data[[doc_id_col]]) %>%
      pull(.data[[text_col]]) %>%
      as.character()
    
    # Criação do corpus
    corpus <- VCorpus(VectorSource(texts))
    

    # Criação da DTM
    dtm <- DocumentTermMatrix(
      corpus,
      control = list(
        wordLengths = c(2, Inf)
      )
    )
    

    # Filtro por frequência mínima
    if (min_term_freq > 1) {
      term_freq <- slam::col_sums(dtm)
      terms_keep <- names(term_freq[term_freq >= min_term_freq])
      dtm <- dtm[, terms_keep]
    }
    
    # Registro de término do processo DTM.
    log_message("Processamento DTM finalizado com sucesso.")
    
    # Retorno
    return(dtm)
    
  }, error = function(e) {
    
    # Registro de erro e interrupção explícita do pipeline
    message(
      paste(
        "[ERRO] Falha na criação da DTM:",
        e$message
      )
    )
    stop(e)
    
  }, warning = function(w) {
    
    # Registro e silenciamento controlado de warnings
    message(
      paste(
        "[AVISO] Problema durante a criação da DTM:",
        w$message
      )
    )
    invokeRestart("muffleWarning")
  })
}
