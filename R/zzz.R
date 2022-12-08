# ensure branded fonts are available
.onLoad <- function(libname, pkgname) {
  if (.Platform$OS.type == "windows") {
    windowsFonts(Georgia = windowsFont("Georgia"),
                 Verdana = windowsFont("Verdana"))
  }
}
