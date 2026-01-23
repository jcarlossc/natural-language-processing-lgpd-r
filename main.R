source("config/config.R")
source(file.path(PATH_LOGS, "pipeline_logs.R"))
source(file.path(PATH_SCRIPTS, "loader_text.R"))
source(file.path(PATH_SCRIPTS, "clean_text.R"))

file <- "lgpd.txt"

text_loaded <- load_text(file.path(PATH_RAW, file), ENCODING, text_col)
text_loaded

text_clean <- clean_text(text_loaded, ENCODING, LANGUAGE, text_col)
text_clean

