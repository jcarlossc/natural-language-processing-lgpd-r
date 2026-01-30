# Pacote  fornece estruturas de dados e algoritmos eficientes para 
# manipular matrizes e arrays esparsos (com muitos zeros)
library(slam)

# Pacote para construção de gráficos.
library(ggplot2)

# Manipulação de dados tabulares (data.frame, tibble).
library(dplyr)

# ============================================================
# Script: plot_top_terms_dtm.R
# Objetivo: Gerar um gráfico com os termos mais frequentes
#           a partir de uma DocumentTermMatrix (DTM)
# Entrada : text_dtm (tm::DocumentTermMatrix)
# Saída   : Objeto ggplot
# ============================================================
plot_top_terms_dtm <- function(text_dtm, top_n = 20) {
  
  # tryCatch garante tolerância a falhas no mecanismo de logging,
  # evitando que erros interrompam o processamento.
  tryCatch({
    
    # Registro de início da construção do gráfico de termos mais frequentes.
    log_message("Iniciando geração de gráfico de termos mais frequentes.")

    # Validações de entrada
    if (is.null(text_dtm)) {
      stop("O objeto text_dtm é NULL.")
    }
    
    if (!inherits(text_dtm, "DocumentTermMatrix")) {
      stop("O objeto fornecido não é uma DocumentTermMatrix.")
    }
    
    if (!is.numeric(top_n) || top_n <= 0) {
      stop("O parâmetro top_n deve ser um número positivo.")
    }
    
    message("[INFO] Calculando frequência total dos termos.")
    
    # Cálculo da frequência total por termo
    term_freq <- slam::col_sums(text_dtm)
    
    if (length(term_freq) == 0) {
      stop("A DTM não contém termos válidos.")
    }
    
    # Conversão para data.frame (formato compatível com ggplot)
    df_terms <- data.frame(
      term = names(term_freq),
      freq = as.numeric(term_freq),
      stringsAsFactors = FALSE
    )
    
    # Seleção dos termos mais frequentes
    df_top_terms <- df_terms %>%
      arrange(desc(freq)) %>%
      slice_head(n = top_n)
    
    if (nrow(df_top_terms) == 0) {
      stop("Nenhum termo disponível após o filtro.")
    }
    
    message("[INFO] Gerando gráfico de frequência dos termos.")
    
    # Criação do gráfico
    plot <- ggplot(
      df_top_terms,
      aes(
        x = reorder(term, freq),
        y = freq
      )
    ) +
      geom_col(fill = "#2C7FB8") +
      coord_flip() +
      labs(
        title = paste(top_n, "termos mais frequentes (DTM)"),
        x = "Termo",
        y = "Frequência"
      ) +
      theme_minimal()
    
    # Registro de término da construção do gráfico de termos mais frequentes.
    log_message("Término da geração de gráfico de termos mais frequentes.")
    
    # Retorna explicitamente o tibble estruturado,
    # garantindo previsibilidade no fluxo da função.
    return(plot)
    
  }, warning = function(w) {
    
    # Registro de início da construção do gráfico de termos mais frequentes.
    log_message("[WARNING] Aviso durante a geração do gráfico de termos.")
    
    # Menssagem de aviso do console.
    message(
      paste(
        "[WARNING] Aviso durante a geração do gráfico de termos:",
        w$message
      )
    )
    # Registro e silenciamento controlado de warnings.
    invokeRestart("muffleWarning")
    
  }, error = function(e) {
    
    # Registro de início da construção do gráfico de termos mais frequentes.
    log_message("[ERROR] Aviso durante a geração do gráfico de termos.")
    
    # Menssagem de erro do console.
    message(
      paste(
        "[ERROR] Falha ao gerar gráfico de termos da DTM:",
        e$message
      )
    )
    stop(e)
  })
}

