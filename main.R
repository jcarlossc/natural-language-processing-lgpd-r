source("config/config.R")
source(file.path(PATH_LOGS, "pipeline_logs.R"))
source(file.path(PATH_SCRIPTS, "loader_text.R"))
source(file.path(PATH_SCRIPTS, "clean_text.R"))
source(file.path(PATH_SCRIPTS, "dtm_text.R"))

file_base <- "lgpd.txt"

text_loaded <- load_text(file.path(PATH_RAW, file_base), ENCODING)

text_clean <- clean_text(text_loaded, ENCODING, LANGUAGE)

text_dtm <- create_dtm(data = text_clean,
                       text_col = "word_stem",
                       doc_id_col = "id",
                       min_term_freq = 3)


text_dtm

