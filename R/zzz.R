# ensure branded fonts are available
.onLoad <- function(libname, pkgname) {
  if (.Platform$OS.type == "windows") {
    windowsFonts(Georgia = windowsFont("Georgia"),
                 Verdana = windowsFont("Verdana"))
  }

  ggplot2::update_geom_defaults(ggplot2::GeomPoint, list(colour = cfc_darkblue))
  ggplot2::update_geom_defaults(ggplot2::GeomRect, list(fill = cfc_darkblue))
  ggplot2::update_geom_defaults(ggplot2::GeomPath, list(color = cfc_darkblue))
}
