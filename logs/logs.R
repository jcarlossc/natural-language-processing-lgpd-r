
log_mensagem <- function(msg, level = "INFO") {
  cat(
    sprintf(
      "[%s] [%s] %s\n",
      Sys.time(), level, msg
    ),
    file = "logs/pipeline.log", 
    append = TRUE
  )
} 