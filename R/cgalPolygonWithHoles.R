#' @title R6 class to represent a CGAL polygonWithHoles
#' @description R6 class to represent a CGAL polygonWithHoles.
#'
#' @importFrom R6 R6Class
#' @export
cgalPolygonWithHoles <- R6Class(
  "cgalPolygonWithHoles",
  
  lock_class = TRUE,
  
  cloneable = FALSE,
  
  private = list(
    ".CGALpolygonWithHoles" = NULL
  ),
  
  public = list(
    
    #' @description Creates a new \code{cgalpolygonWithHoles} object.
    #' @param outerVertices a numeric matrix with two columns, the vertices 
    #'   of the outer polygon
    #' @param holes a list of numeric matrices, each representing the vertices 
    #'   of a hole
    #' @return A \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' pwh
    "initialize" = function(outerVertices, holes) {
      stopifnot(is.matrix(outerVertices))
      stopifnot(nrow(outerVertices) >= 3L)
      stopifnot(ncol(outerVertices) == 2L)
      storage.mode(outerVertices) <- "double"
      stopifnot(noMissingValue(outerVertices))
      stopifnot(is.list(holes))
      for(h in seq_along(holes)) {
        hole <- holes[[h]]
        stopifnot(is.matrix(hole))
        stopifnot(nrow(hole) >= 3L)
        stopifnot(ncol(hole) == 2L)
        storage.mode(hole) <- "double"
        stopifnot(noMissingValue(hole))
      }
      holes <- lapply(holes, t)
      private[[".CGALpolygonWithHoles"]] <- 
        CGALpolygonWithHoles$new(t(outerVertices), holes)
      invisible(self)
    },
    
    
    #' @description Decomposition into convex parts. The polygon must be simple 
    #'   and counter-clockwise oriented.
    #' @param method the method used: \code{"approx"}, \code{"greene"}, 
    #'   or \code{"optimal"}
    #' @return A list of matrices; each matrix has two columns and represents 
    #'   a convex polygon.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' cxparts <- pwh$convexParts()
    "convexParts" = function(method = "triangle") {
      method <- match.arg(method, c("triangle", "vertical"))
      if(method == "triangle") {
        private[[".CGALpolygonWithHoles"]]$convexPartsT()
      } else {
        private[[".CGALpolygonWithHoles"]]$convexPartsV()
      }
    },
    
    
    #' @description Print the \code{cgalPolygonWithHoles} object.
    #' @param ... ignored
    #' @return No value, just prints some information about the polygonWithHoles.
    "print" = function(...) {
      private[[".CGALpolygonWithHoles"]]$print()
    }
    
  )
)