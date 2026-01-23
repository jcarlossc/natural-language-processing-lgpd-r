# Pacote responsável por estruturas de dados modernas (tibbles).
library(tibble)

# Pacote utilizado para leitura eficiente e segura de arquivos de texto.
library(readr)

# ------------------------------------------------------------------------------
# Função: load_text
# Objetivo:
#   Carregar um arquivo de texto bruto a partir do sistema de arquivos,
#   respeitando a codificação informada e estruturando os dados em um tibble
#   adequado para pipelines de NLP (ex.: LDA, TF-IDF).
#
# Parâmetros:
#   path     : caminho completo ou relativo para o arquivo de texto (.txt)
#   ENCODING : codificação de caracteres do arquivo (ex.: "UTF-8", "latin1")
#   text_col : nome da coluna 
#
# Retorno:
#   tibble com:
#     - id       : identificador sequencial de cada linha do texto
#     - text_law : conteúdo textual bruto (uma linha por registro)
#
# Tratamento de exceções:
#   - Erros críticos interrompem a execução e são registrados em log
#   - Avisos são registrados, mas não interrompem o pipeline
# ------------------------------------------------------------------------------

load_text <- function(path, ENCODING, text_col) {
  
  tryCatch({
    
    # Registra o início do carregamento do texto,
    # permitindo acompanhamento do processo.
    log_message("Início do carragamento do texto.")
    
    # Verifica previamente a existência do arquivo no caminho informado.
    # Essa validação evita falhas silenciosas e facilita a depuração.
    if (!file.exists(path)) {
      stop("Arquivo de texto não encontrado em: ", path)
    }
    
    # Realiza a leitura do arquivo de texto linha a linha,
    # aplicando explicitamente a codificação informada para
    # evitar problemas com caracteres especiais (acentuação, símbolos legais).
    text_raw <- read_lines(
      file = path,
      locale = locale(encoding = ENCODING)
    )
    
    # Estrutura o texto bruto em um tibble, atribuindo um identificador
    # sequencial a cada linha. Esse formato é ideal para transformações
    # posteriores em pipelines tidy (tokenização, limpeza, modelagem).
    tibble_text <- tibble(
      id = seq_along(text_raw),
      text_col = text_raw
    )
    
    # Registra o término do carregamento dos dados,
    # permitindo acompanhamento do processo.
    log_message("Carregamento do arquivo de texto bem sucedido.")
    
    # Persistência dos dados processados
    write_csv(tibble_text, file.path(PATH_PROCESSED, "text_loaded.csv"))
    
    # Retorna explicitamente o tibble estruturado,
    # garantindo previsibilidade no fluxo da função.
    return(tibble_text)
    
  }, error = function(e) {
    
    # Registra erro crítico ocorrido durante o carregamento dos dados,
    # permitindo auditoria e rastreabilidade do pipeline.
    log_message("Erro ao carregar dados: ", e$message)
    
    # Interrompe a execução, propagando o erro para camadas superiores
    # do pipeline analítico.
    stop(e)
    
  }, warning = function(w) {
    
    # Registra avisos não críticos (ex.: problemas pontuais de leitura),
    # sem interromper a execução do fluxo principal.
    log_message(paste("AVISO ao carregar dados:", w$message))
    
    # Suprime o aviso após o registro em log para evitar poluição
    # da saída padrão durante execuções automatizadas.
    invokeRestart("muffleWarning")
  })
}
