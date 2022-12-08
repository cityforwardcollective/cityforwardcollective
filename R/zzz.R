# ensure branded fonts are available
.onLoad <- function(libname, pkgname) {
  if (.Platform$OS.type == "windows") {
    windowsFonts(Georgia = windowsFont("Georgia"),
                 Verdana = windowsFont("Verdana"))
  }

  update_geom_defaults(GeomPoint, list(colour = cfc_darkblue))
  update_geom_defaults(GeomRect, list(fill = cfc_darkblue))
  update_geom_defaults(GeomPath, list(color = cfc_darkblue))
}
