library(topicmodels)
library(slam)

# ============================================================
# Script: create_lda.R
# Objetivo: Ajustar modelo LDA a partir de uma DTM
# Entrada : DocumentTermMatrix
# Saída   : Modelo LDA
# ============================================================

create_lda <- function(
    text_dtm,
    k = 5,
    seed = 1234
) {
  
  tryCatch({
    
    # Registro de início do processo
    log_message("Iniciando processamento LDA.")
    
    # Validação de entrada.
    if (!inherits(text_dtm, "DocumentTermMatrix")) {
      stop("O objeto fornecido não é uma DocumentTermMatrix.")
    }
    
    # Remoção de documentos vazios.
    row_totals <- row_sums(text_dtm)
    
    if (any(row_totals == 0)) {
      warning(
        paste(
          sum(row_totals == 0),
          "documento(s) vazio(s) removido(s) antes do LDA."
        )
      )
      
      text_dtm <- text_dtm[row_totals > 0, ]
    }
    
    if (nrow(text_dtm) == 0) {
      stop("Após a limpeza, não restaram documentos para o LDA.")
    }
    
    # Ajuste do LDA
    lda_model <- LDA(
      text_dtm,
      k = k,
      method = "Gibbs",
      control = list(seed = seed)
    )
    
    # Registro de início do processo
    log_message("Processamento LDA finalizado com sucesso.")
    
    return(lda_model)
    
  }, error = function(e) {
    
    message(
      paste(
        "[ERRO] Falha ao ajustar o modelo LDA:",
        e$message
      )
    )
    stop(e)
    
  }, warning = function(w) {
    
    message(
      paste(
        "[AVISO] LDA gerou aviso:",
        w$message
      )
    )
    invokeRestart("muffleWarning")
    
  })
}
