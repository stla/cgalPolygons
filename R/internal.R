noMissingValue <- function(x) {
  !anyNA(x)
}

#' @importFrom R6 is.R6
#' @noRd
isCGALpolygonWithHoles <- function(x) {
  is.R6(x) && inherits(x, "cgalPolygonWithHoles")
}
