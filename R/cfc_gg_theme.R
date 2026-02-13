#'
#' @export ggplot
#' @export cfc_darkblue
#' @export cfc_orange
#' @export cfc_turquoise
#' @export cfc_babyblue
#' @export cfc_skyblue
#' @export cfc_colors
#' @export cfc_dark_green
#' @export cfc_orange
#' @export cfc_stone
#' @export cfc_teal
#' @export cfc_sector_cols


# Define Brand Colors
# These are old now

cfc_darkblue <- "#003349"
cfc_orange <- "#E57200"
cfc_turquoise <- "#69DBC8"
cfc_babyblue <- "#C7DBF4"
cfc_skyblue <- "#00A9E0"

# New Brand Colors

cfc_dark_green <- "#395549"
cfc_orange <- "#ed902d"
cfc_stone <- "#6998ab"
cfc_teal <- "#348789"

# Define sector colors

cfc_sector_cols <- c(
  cfc_dark_green,
  cfc_orange,
  cfc_stone,
  cfc_teal
)

# Define palette

cfc_colors <- c(cfc_darkblue,
                cfc_orange,
                cfc_turquoise,
                cfc_babyblue,
                cfc_skyblue)

# Set branded theme

ggplot <- function(...) {
  ggplot2::ggplot(...) +
    scale_fill_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    scale_color_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    theme_minimal() +
    theme(text = element_text(family = "Open Sans",
                              size = 16),
          plot.title.position = "plot",
          plot.title = element_text(family = "Montserrat",
                                    face = "bold",
                                    size = 24,
                                    margin = margin(b = 20)),
          plot.subtitle = element_text(color = "grey30",
                                       margin = margin(b = 20)),
          plot.caption.position = "plot",
          plot.caption = element_text(hjust = 0,
                                      lineheight = 1.2,
                                      color = "grey50"),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())
}
