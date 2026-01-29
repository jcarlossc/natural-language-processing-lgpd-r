source("config/config.R")
source(file.path(PATH_LOGS, "pipeline_logs.R"))
source(file.path(PATH_SCRIPTS, "loader_text.R"))
source(file.path(PATH_SCRIPTS, "clean_text.R"))
source(file.path(PATH_SCRIPTS, "dtm_text.R"))
source(file.path(PATH_SCRIPTS, "lda_text.R"))
source(file.path(PATH_GRAPHICS, "graphic_lda.R"))

file_base <- "lgpd.txt"

text_loaded <- load_text(file.path(PATH_RAW, file_base), ENCODING)

text_clean <- clean_text(text_loaded, ENCODING, LANGUAGE)

text_dtm <- create_dtm(data = text_clean,
                       text_col = "word_stem",
                       doc_id_col = "id",
                       min_term_freq = 3)

# 3. Preparação específica para LDA  
dtm_lda <- text_dtm[slam::row_sums(text_dtm) > 0, ]

#stopifnot(nrow(dtm_lda) == 6355)

# 4. Ajuste do modelo LDA
lda_model <- create_lda(
  text_dtm = dtm_lda,
  k = 6
)

plot_lda_top_terms(
  lda_model = lda_model,
  top_n = 10
)



