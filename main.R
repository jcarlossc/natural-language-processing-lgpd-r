source("config/config.R")
source(file.path(PATH_LOGS, "pipeline_logs.R"))
source(file.path(PATH_SCRIPTS, "loader_text.R"))

file <- "lgpd.txt"

text_loaded <- load_text(file.path(PATH_RAW, file), ENCODING)
text_loaded
