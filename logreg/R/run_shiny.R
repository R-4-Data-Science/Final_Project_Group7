#' @export
CI_shiny = function(){
  appDir = system.file("inst", package = "logreg")
  shiny::runApp(appDir, display.mode = "normal")
}