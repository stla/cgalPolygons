#' Title
#'
#' @param pgn1 x
#' @param pgn2 x
#'
#' @return A list 
#' @export
#'
#' @examples
#' library
pgnsIntersection <- function(pgn1, pgn2) {
  stopifnot(isCGALpolygonWithHoles(pgn1))
  stopifnot(isCGALpolygonWithHoles(pgn2))
  xptr1 <- getXPtr2(pgn1)
  xptr2 <- getXPtr2(pgn2)
  Intersection(xptr1, xptr2)
}