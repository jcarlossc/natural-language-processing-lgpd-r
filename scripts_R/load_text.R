library(tibble)
library(readr)


loader_text <- function(file, encoding) {
  
  tryCatch({
    
    # Registra no log o processo iniciado.     
    log_message(paste(
      "Iniciando o pipeline de Processamento de Linguagem Natual:"))
    
    if (!file.exists(file)) {
      stop("Arquivo de texto não encontrado em: ", file)
    }
    
    log_message(paste("Carregando texto:", file))
    
    texto_bruto <- read_lines(
      file = file,
      locale = locale(encoding = encoding)
    )
    
    text_loaded <- tibble(
      id = seq_along(texto_bruto),
      texto = texto_bruto
    )
    
    log_message(paste("Texto carregado:", file))
    
    return(text_loaded)
    
  },
  error = function(e) {
    
    # Registra no log o erro ocorrido.
    log_message(paste("ERRO na função load_text:", e$message))
    
    # interrompe o pipeline de forma explícita.
    stop(e)  
    
  },
  warning = function(w) {
    
    # Registra no log o aviso ocorrido.
    log_message(paste("AVISO na função load_text:", w$message))
    
    # Silencia o warning após registrá-lo.
    invokeRestart("muffleWarning")
  })
}