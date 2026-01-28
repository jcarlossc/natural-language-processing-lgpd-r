library(slam)
library(ggplot2)

term_freq <- col_sums(text_dtm)

df_terms <- data.frame(
  term = names(term_freq),
  freq = as.numeric(term_freq)
)

df_terms %>%
  dplyr::arrange(desc(freq)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(term, freq), y = freq)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "20 termos mais frequentes (DTM)",
    x = "Termo",
    y = "Frequência"
  ) +
  theme_minimal()
