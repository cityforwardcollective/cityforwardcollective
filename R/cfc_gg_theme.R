#'
#' @export GeomPoint
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
    theme_minimal() +
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
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())
}

#' @export
GeomPoint <- ggplot2::ggproto("GeomPoint", ggplot2::Geom,
                     required_aes = c("x", "y"),
                     non_missing_aes = c("size", "shape", "colour"),
                     default_aes = ggplot2::aes(
                       shape = 19, colour = cfc_darkblue, size = 1.5, fill = NA,
                       alpha = NA, stroke = 0.5
                     ),

                     draw_panel = function(self, data, panel_params, coord, na.rm = FALSE) {
                       if (is.character(data$shape)) {
                         data$shape <- translate_shape_string(data$shape)
                       }

                       coords <- coord$transform(data, panel_params)
                       stroke_size <- coords$stroke
                       stroke_size[is.na(stroke_size)] <- 0
                       ggname("geom_point",
                              pointsGrob(
                                coords$x, coords$y,
                                pch = coords$shape,
                                gp = grid::gpar(
                                  col = alpha(coords$colour, coords$alpha),
                                  fill = alpha(coords$fill, coords$alpha),
                                  # Stroke is added around the outside of the point
                                  fontsize = coords$size * .pt + stroke_size * .stroke / 2,
                                  lwd = coords$stroke * .stroke / 2
                                )
                              )
                       )
                     },

                     draw_key = ggplot2::draw_key_point
)
