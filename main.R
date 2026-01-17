source("config/config.R")
# source(file.path(PATH_LOGS, "logs.R"))
source(file.path(PATH_SCRIPTS, "load_text.R"))


file_raw <- "lgpd.txt" 

data_raw <- loader_text(file.path(PATH_RAW, file_raw), ENCODING)
