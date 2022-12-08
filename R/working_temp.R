theme_cfc <- function() {
  theme_minimal() %+replace%
    theme(text = element_text(family = "Verdana",
                              size = 16),
          plot.title.position = "plot",
          plot.title = element_text(family = "Georgia",
                                    face = "bold",
                                    size = 24,
                                    margin = margin(b = 20)),
          plot.subtitle = element_text(color = "grey30",
                                       margin = margin(b = 20)),
          plot.caption.position = "plot",
          plot.caption = element_text(hjust = 0,
                                      lineheight = 1.2,
                                      color = "grey50"),
          panel.grid.minor = element_blank())
}

library(wisconsink12)

make_mke_rc() |>
  group_by(school_year) |>
  count() |>
  ggplot(aes(school_year, n)) +
  geom_col() +
  theme_cfc()



theme(panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      text = element_text(family = "Verdana", size = 16),
      plot.title = element_text(family = "Georgia", face = "bold", size = 24),
      plot.subtitle = element_textbox(lineheight = 1.2, color = "grey30",
                                      width = unit(9, "in"),
                                      margin = margin(t = 10, b = 20)),
      plot.caption = element_text(lineheight = 1.2, color = "grey50"),
      axis.title.x = element_text(margin = margin(t = 10, b = 10)),
      axis.text.x = element_text(size = 10)) +

ggplot <- function(...) {
  ggplot2::ggplot(...) +
    scale_fill_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    scale_color_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    theme_minimal(base_family = "serif") +
    theme(text = element_text(size = 14, family = "serif"),
          plot.title.position = "plot",
          plot.caption.position = "plot",
          plot.caption = element_text(hjust = 0))
}
