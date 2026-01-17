# ------------------------------------------------------------------------------
# Função: log_message
# Objetivo:
#   Registrar mensagens de log em arquivo, incluindo timestamp e nível de severidade,
#   permitindo auditoria, rastreabilidade e monitoramento do pipeline.
#
# Parâmetros:
#   msg   -> mensagem textual a ser registrada no log
#   level -> nível de severidade da mensagem
#            (ex: "INFO", "WARNING", "ERROR")
#
# Observações:
#   - As mensagens são adicionadas ao arquivo de log (append = TRUE)
#   - O formato do log segue o padrão:
#     [timestamp] [level] mensagem
# ------------------------------------------------------------------------------
log_message <- function(msg, level = "INFO") {
  
  # A função cat é utilizada para escrita direta em arquivo,
  # evitando buffers intermediários e garantindo desempenho em pipelines longos.
  cat(
    
    # sprintf formata a mensagem de log de forma padronizada,
    # garantindo consistência visual.
    sprintf(
      "[%s] [%s] %s\n",
      Sys.time(),        # Data e hora da ocorrência do evento
      level,             # Nível de severidade do log
      msg                # Mensagem informativa do evento
    ),
    
    # Caminho do arquivo de log onde as mensagens serão persistidas.
    # Em ambientes produtivos, recomenda-se versionar ou rotacionar este arquivo.
    file = "logs/pipeline.log", 
    
    # append = TRUE garante que novas mensagens sejam adicionadas ao final do arquivo,
    # preservando o histórico completo de execução do pipeline.
    append = TRUE
  )
} 
