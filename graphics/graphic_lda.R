library(tidytext)
library(reshape2)

lda_terms <- tidy(
  lda_model,
  matrix = "beta"
)

lda_terms %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  ggplot(aes(x = reorder_within(term, beta, topic),
             y = beta,
             fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered() +
  labs(
    title = "Top 10 termos por tópico (LDA)",
    x = "Termo",
    y = "Probabilidade (beta)"
  ) +
  theme_minimal()
