#'
#' @export ggplot
#' @export cfc_darkblue
#' @export cfc_orange
#' @export cfc_teal
#' @export cfc_babyblue
#' @export cfc_skyblue
#' @export cfc_colors
# Define Brand Colors

cfc_darkblue <- "#003349"
cfc_orange <- "#E57200"
cfc_teal <- "#69DBC8"
cfc_babyblue <- "#C7DBF4"
cfc_skyblue <- "#00A9E0"

# Define palette

cfc_colors <- c(cfc_darkblue,
                cfc_orange,
                cfc_teal,
                cfc_babyblue,
                cfc_skyblue)

# Set branded theme

ggplot <- function(...) {
  ggplot2::ggplot(...) +
    scale_fill_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    scale_color_manual(values = cfc_colors, labels = function(x) str_wrap(x, 20)) +
    theme_minimal(base_family = "serif") +
    theme(text = element_text(size = 14))
}
