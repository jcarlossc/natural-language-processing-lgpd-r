# ------------------------------------------------------------------------------
# Função: log_message
# Objetivo:
#   Registrar mensagens de log em arquivo de forma segura,
#   garantindo que falhas no sistema de logging não interrompam o pipeline.
#
# Parâmetros:
#   msg   -> mensagem textual a ser registrada
#   level -> nível de severidade do log (INFO, WARNING, ERROR)
# ------------------------------------------------------------------------------
log_message <- function(msg, level = "INFO") {
  
  # tryCatch garante tolerância a falhas no mecanismo de logging,
  # evitando que erros de I/O interrompam o processamento principal.
  tryCatch({
    
    # Verifica se o diretório de logs existe;
    # caso não exista, tenta criá-lo de forma recursiva.
    if (!dir.exists(PATH_LOGS)) {
      dir.create(PATH_LOGS, recursive = TRUE)
    }
    
    # Constrói o caminho completo do arquivo de log.
    log_file <- file.path(PATH_LOGS, "pipeline.log")
    
    # Escreve a mensagem formatada no arquivo de log,
    # adicionando novas entradas ao final do arquivo.
    cat(
      sprintf(
        "[%s] [%s] %s\n",
        Sys.time(),    # Data e hora da ocorrência do evento
        level,         # Nível de severidade do log
        msg            # Mensagem informativa do evento
      ),
      file = log_file,
      append = TRUE
    )
    
  },
  
  # Tratamento de ERROS no logging
  error = function(e) {
    
    # Em caso de falha no log em arquivo, a mensagem é enviada
    # para a saída padrão (console) como fallback,
    # garantindo visibilidade mínima do problema.
    message(
      sprintf(
        "[%s] [LOG_ERROR] Falha ao escrever log: %s",
        Sys.time(), e$message
      )
    )
    
    # Não interrompe o pipeline principal.
    invisible(NULL)
  })
}
