# Pacote da linguagem R projetado para facilitar a mineração e análise de texto. 
library(tidytext) 

# Manipulação de dados tabulares (data.frame, tibble).
library(dplyr)

# Pacote para construção de gráficos.
library(ggplot2)

# Pacote essencial para remodelar conjuntos de dados, convertendo-os 
# entre formatos "largos" (wide) e "longos" (long).
library(reshape2)  

# ============================================================
# Script: plot_lda_top_terms.R
# Objetivo: Visualizar os principais termos por tópico de um
#           modelo LDA utilizando tidytext e ggplot2
# Entrada : lda_model (classe LDA / LDA_VEM / LDA_Gibbs)
# Saída   : Gráfico ggplot
# ============================================================
plot_lda_top_terms <- function(lda_model, top_n = 10) {
  
  # tryCatch garante tolerância a falhas no mecanismo de logging,
  # evitando que erros interrompam o processamento.
  tryCatch({
    
    # Registro de início da construção do gráfico de termos LDA.
    log_message("Iniciando geração de gráfico de termos LDA.")
    
    # Validação de entrada
    if (is.null(lda_model)) {
      stop("O objeto lda_model é NULL.")
    }
    
    if (!inherits(lda_model, c("LDA", "LDA_VEM", "LDA_Gibbs"))) {
      stop("O objeto fornecido não é um modelo LDA válido.")
    }
    
    if (!is.numeric(top_n) || top_n <= 0) {
      stop("O parâmetro top_n deve ser um número positivo.")
    }
    
    message("[INFO] Extraindo termos do modelo LDA (matriz beta).")
    
    # Conversão do LDA para formato tidy
    lda_terms <- tidy(
      lda_model,
      matrix = "beta"
    )
    
    if (nrow(lda_terms) == 0) {
      stop("A extração tidy do LDA retornou um objeto vazio.")
    }
    
    # Seleção dos termos mais relevantes por tópico
    lda_top_terms <- lda_terms %>%
      group_by(topic) %>%
      slice_max(order_by = beta, n = top_n, with_ties = FALSE) %>%
      ungroup()
    
    message("[INFO] Gerando gráfico dos termos por tópico.")
    
    # Criação do gráfico
    plot <- ggplot(
      lda_top_terms,
      aes(
        x    = reorder_within(term, beta, topic),
        y    = beta,
        fill = factor(topic)
      )
    ) +
      geom_col(show.legend = FALSE) +
      facet_wrap(~ topic, scales = "free") +
      coord_flip() +
      scale_x_reordered() +
      labs(
        title = paste("Top", top_n, "termos por tópico (LDA)"),
        x     = "Termo",
        y     = "Probabilidade (beta)"
      ) +
      theme_minimal()
    
    # Registro de término da construção do gráfico de termos LDA.
    log_message("Gráfico de termos LDA construído com sucesso")
    
    # Retorna explicitamente o tibble estruturado,
    # garantindo previsibilidade no fluxo da função.
    return(plot)
    
  }, error = function(e) {
    
    # Registro de erro e interrupção explícita do pipeline
    log_message(paste("Falha ao gerar gráfico de termos do LDA", e$message))
    
    # Menssagem de erro do console.
    message(
      paste(
        "[ERRO] Falha ao gerar gráfico de termos do LDA:",
        e$message
      )
    )
    stop(e)  
    
  }, warning = function(w) {
    
    # Registro de erro e interrupção explícita do pipeline.
    log_message(paste("Aviso ao gerar gráfico de termos do LDA", e$message))
    
    # Menssagem de aviso do console.
    message(
      paste(
        "[AVISO] Aviso durante a geração do gráfico LDA:",
        w$message
      )
    )
    # Registro e silenciamento controlado de warnings.
    invokeRestart("muffleWarning")
    
  })
}

