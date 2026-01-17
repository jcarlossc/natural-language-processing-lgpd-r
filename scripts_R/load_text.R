library(tibble)
library(readr)

# ------------------------------------------------------------------------------
# Função: load_text
# Objetivo:
#   Carregar um arquivo de texto bruto a partir do diretório data/data_raw,
#   validando sua existência, respeitando a codificação informada,
#   estruturando os dados em formato tabular (tibble)
#   e registrando todas as etapas no log.
#
# Parâmetros:
#   file      -> caminho completo ou relativo do arquivo de texto
#   ENCODING  -> encoding do arquivo (ex: "UTF-8", "Latin1")
#
# Retorno:
#   tibble com:
#     - id    : identificador sequencial de cada linha
#     - texto : conteúdo textual do arquivo
# ------------------------------------------------------------------------------

loader_text <- function(file, encoding) {
  
  # tryCatch é utilizado para garantir controle de erros e avisos,
  # evitando falhas silenciosas e permitindo logging estruturado.
  tryCatch({
    
    # Registra no log o início do pipeline de Processamento de Linguagem Natural,
    # facilitando rastreabilidade e auditoria da execução.     
    log_message(paste(
      "Iniciando o pipeline de Processamento de Linguagem Natual:"))
    
    # Verifica se o arquivo informado realmente existe no caminho especificado.
    # Caso não exista, a execução é interrompida com erro explícito.
    if (!file.exists(file)) {
      stop("Arquivo de texto não encontrado em: ", file)
    }
    
    # Registra no log o início da etapa de carregamento do arquivo.
    log_message(paste("Carregando texto:", file))
    
    # Realiza a leitura do arquivo linha a linha,
    # respeitando explicitamente a codificação informada.
    # Isso evita problemas comuns com acentuação e caracteres especiais.
    text_raw <- read_lines(
      file = file,
      locale = locale(encoding = encoding)
    )
    
    # Constrói um tibble estruturado a partir do text_raw,
    # associando um identificador sequencial a cada linha do texto.
    # Esse ID facilita rastreamento, joins e análises posteriores.
    text_loaded <- tibble(
      id = seq_along(text_raw),
      texto = text_raw
    )
    
    # Registra no log o sucesso do carregamento do arquivo.
    log_message(paste("Texto carregado:", file))
    
    # Retorna explicitamente o tibble resultante,
    # garantindo clareza no fluxo de saída da função.
    return(text_loaded)
    
  },
  # --------------------------------------------------------------------------
  # Tratamento de ERROS
  # --------------------------------------------------------------------------
  error = function(e) {
    
    # Registra no log a mensagem de erro ocorrida,
    # preservando a mensagem original para diagnóstico.
    log_message(paste("ERRO na função loader_text:", e$message))
    
    # Interrompe o pipeline de forma explícita,
    # propagando o erro para camadas superiores.
    stop(e)  
    
  },
  # --------------------------------------------------------------------------
  # Tratamento de AVISOS (warnings)
  # --------------------------------------------------------------------------
  warning = function(w) {
    
    # Registra no log o aviso ocorrido,
    # garantindo que eventos não críticos sejam documentados.
    log_message(paste("AVISO na função loader_text:", w$message))
    
    # Suprime o warning após registrá-lo,
    # evitando poluição da saída padrão do pipeline.
    invokeRestart("muffleWarning")
  })
}