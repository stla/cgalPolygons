#' @useDynLib cgalPolygons, .registration=TRUE
#' @importFrom Rcpp evalCpp setRcppClass
#' @importFrom methods new
NULL

CGALpolygon <- Rcpp::setRcppClass("CGALpolygon")
