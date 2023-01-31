#' @useDynLib cgalPolygons, .registration=TRUE
#' @importFrom Rcpp evalCpp setRcppClass
#' @importFrom methods new
NULL

CGALpolygon          <- setRcppClass("CGALpolygon")
CGALpolygonWithHoles <- setRcppClass("CGALpolygonWithHoles")
