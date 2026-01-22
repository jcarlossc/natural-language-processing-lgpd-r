# ------------------------------------------------------------------------------
# Definição de caminhos (paths) padrão do projeto
# Objetivo:
#   Centralizar a configuração de diretórios utilizados no pipeline,
#   facilitando manutenção, portabilidade e padronização do ambiente.
# ------------------------------------------------------------------------------

# Diretório contendo arquivos de configuração do projeto
PATH_CONFIG <- "config"

# Diretório destinado ao armazenamento dos dados brutos (raw data),
# exatamente como foram obtidos da fonte, sem qualquer tratamento.
PATH_RAW <- "data/data_raw"

# Diretório destinado aos dados processados,
# resultantes das etapas de limpeza, transformação e enriquecimento.
PATH_PROCESSED <- "dados/data_processed"

# Diretório que armazena os scripts R do projeto,
# incluindo funções de pipelines e módulos analíticos.
PATH_SCRIPTS <- "scripts_R"

# Diretório responsável pelo armazenamento dos arquivos de log,
# garantindo rastreabilidade, auditoria e monitoramento das execuções.
PATH_LOGS <- "logs"


# ------------------------------------------------------------------------------
# Definição de parâmetros globais de processamento
# Objetivo:
#   Padronizar codificação e idioma utilizados em todo o pipeline,
#   evitando inconsistências e problemas de interpretação de texto.
# ------------------------------------------------------------------------------

# Codificação padrão dos arquivos de texto utilizados no projeto,
# garantindo correta leitura de caracteres acentuados e símbolos especiais.
ENCODING <- "UTF-8"

# Idioma principal do corpus textual,
# utilizado em etapas de NLP como tokenização, stopwords e stemming.
LANGUAGE <- "pt"