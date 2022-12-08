# ensure branded fonts are available
.onload <- function(libname, pkgname) {
  if (.Platform$OS.type == "windows") {
    windowsFonts(Georgia = windowsFont("Georgia"),
                 Verdana = windowsFont("Verdana"))
  }

  rlang::run_on_load()
}
