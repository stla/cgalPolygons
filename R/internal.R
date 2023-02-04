noMissingValue <- function(x) {
  !anyNA(x)
}

#' @importFrom R6 is.R6
#' @noRd
isCGALpolygonWithHoles <- function(x) {
  is.R6(x) && inherits(x, "cgalPolygonWithHoles")
}

isBoolean <- function(x) {
  is.logical(x) && length(x) == 1L && !is.na(x)
}
