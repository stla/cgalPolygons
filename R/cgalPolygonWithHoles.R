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
    ".CGALpolygonWithHoles" = NULL,
    ".vs_outer"             = NULL,
    ".vs_holes"             = NULL
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
      private[[".vs_outer"]] <- outerVertices
      private[[".vs_holes"]] <- holes
      private[[".CGALpolygonWithHoles"]] <- 
        CGALpolygonWithHoles$new(t(outerVertices), lapply(holes, t))
      invisible(self)
    },
    
    
    #' @description Bounding box of the polygon with holes.
    #' @return A 2x2 matrix giving the lower corner of the bounding box in its 
    #'   first row and the upper corner in its second row.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' pwh$boundingBox()
    "boundingBox" = function() {
      private[[".CGALpolygonWithHoles"]]$boundingBox()
    },
    
    
    #' @description Decomposition into convex parts of the polygon with holes.
    #' @param method the method used: \code{"triangle"} or \code{"vertical"}
    #' @return A list of matrices; each matrix has two columns and represents 
    #'   a convex polygon.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' cxparts <- pwh$convexParts()
    #' pwh$plot(list(), density = 10)
    #' invisible(
    #'   lapply(cxparts, function(cxpart) {
    #'     polygon(cxpart, lwd = 2)
    #'   })
    #' )
    "convexParts" = function(method = "triangle") {
      method <- match.arg(method, c("triangle", "vertical"))
      if(method == "triangle") {
        private[[".CGALpolygonWithHoles"]]$convexPartsT()
      } else {
        private[[".CGALpolygonWithHoles"]]$convexPartsV()
      }
    },
    
    
    #' @description Plot the polygon with holes.
    #' @param outerpars named list of arguments passed to 
    #'   \code{\link[graphics]{polygon}} for the outer polygon
    #' @param ... arguments passed to \code{\link[graphics]{polygon}} for the 
    #'   holes
    #' @return No returned value, called for side-effect.
    #' @importFrom graphics plot polygon
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' pwh$plot(
    #'   outerpars = list(lwd = 2), density = 10
    #' )
    "plot" = function(outerpars, ...) {
      bbox <- private[[".CGALpolygonWithHoles"]]$boundingBox()
      plot(bbox, type = "n", asp = 1, xlab = NA, ylab = NA, axes = FALSE)
      do.call(function(...) {
        polygon(private[[".vs_outer"]], ...)
      }, outerpars)
      invisible(
        lapply(private[[".vs_holes"]], function(hole) {
          polygon(hole, ...) 
        })
      )
      invisible(NULL)
    },
    
    
    #' @description Print the \code{cgalPolygonWithHoles} object.
    #' @param ... ignored
    #' @return No value, just prints some information about the polygonWithHoles.
    "print" = function(...) {
      private[[".CGALpolygonWithHoles"]]$print()
    }
    
  )
)