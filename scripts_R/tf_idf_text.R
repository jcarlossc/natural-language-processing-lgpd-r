# O pacote tm (Text Mining) é uma estrutura abrangente para mineração de texto.
library(tm)

# ============================================================
# Script: create_tfidf.R
# Objetivo: Aplicar ponderação TF-IDF a uma DTM
# Entrada : DocumentTermMatrix (tm)
# Saída   : DocumentTermMatrix (TF-IDF)
# ============================================================

create_tfidf <- function(text_dtm) {
  
  tryCatch({
    
    # Registro de início do processo
    log_message("Iniciando processamento TF-IDF.")
    
    # Validação de entrada
    if (!inherits(text_dtm, "DocumentTermMatrix")) {
      stop("O objeto fornecido não é uma DocumentTermMatrix.")
    }
    
    if (nrow(text_dtm) == 0 || ncol(text_dtm) == 0) {
      stop("DTM vazia: não é possível calcular TF-IDF.")
    }
    
    # Aplicação do TF-IDF
    dtm_tfidf <- weightTfIdf(
      text_dtm,
      normalize = TRUE
    )
    
    # Remoção de termos vazios
    dtm_tfidf <- dtm_tfidf[
      rowSums(as.matrix(dtm_tfidf)) > 0,
      colSums(as.matrix(dtm_tfidf)) > 0
    ]
    
    # Registro de início do processo
    log_message("Processamento TF-IDF finalizado com sucesso.")
    
    return(dtm_tfidf)
    
  }, error = function(e) {
    
    message(
      paste(
        "[ERRO] Falha ao calcular TF-IDF:",
        e$message
      )
    )
    stop(e)
    
  }, warning = function(w) {
    
    message(
      paste(
        "[AVISO] TF-IDF gerou aviso:",
        w$message
      )
    )
    invokeRestart("muffleWarning")
    
  })
}
