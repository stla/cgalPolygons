getXPtr2 <- function(cPWH){
  cPWH[[".__enclos_env__"]][["private"]][[".CGALpolygonWithHoles"]][["xptr"]]
}


#' @title R6 class to represent a CGAL polygon with holes
#' @description R6 class to represent a CGAL polygon with holes.
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
    #'   of a hole; an empty list is allowed
    #' @return A \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' pwh
    "initialize" = function(outerVertices, holes = list()) {
      # one can also initialize from an external pointer, but 
      # this is hidden to the user
      if(inherits(outerVertices, "externalptr")) {
        private[[".CGALpolygonWithHoles"]] <- 
          CGALpolygonWithHoles$new(outerVertices)
        return(invisible(self))
      }
      stopifnot(is.matrix(outerVertices))
      stopifnot(nrow(outerVertices) >= 3L)
      stopifnot(ncol(outerVertices) == 2L)
      storage.mode(outerVertices) <- "double"
      stopifnot(noMissingValue(outerVertices))
      if(anyDuplicated(outerVertices)) {
        stop("Found duplicated vertices in the outer polygon.")
      }
      #
      stopifnot(is.list(holes))
      for(h in seq_along(holes)) {
        hole <- holes[[h]]
        stopifnot(is.matrix(hole))
        stopifnot(nrow(hole) >= 3L)
        stopifnot(ncol(hole) == 2L)
        storage.mode(hole) <- "double"
        stopifnot(noMissingValue(hole))
        if(anyDuplicated(hole)) {
          stop(sprintf(
            "Found duplicated vertices in the hole %d.", h
          ))
        }
      }
      private[[".vs_outer"]] <- outerVertices
      private[[".vs_holes"]] <- holes
      private[[".CGALpolygonWithHoles"]] <- 
        CGALpolygonWithHoles$new(t(outerVertices), lapply(holes, t))
      invisible(self)
    },

    
    #' @description Area of the polygon with holes.
    #' @return A positive number, the area of the polygon.
    #' @examples 
    #' library(cgalPolygons)
    #' pwh <- cgalPolygonWithHoles$new(
    #'   squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
    #' )
    #' pwh$area() # should be 12
    "area" = function() {
      private[[".CGALpolygonWithHoles"]]$area()
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
    #'   The outer polygon as well as the holes must be simple.
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
    
    #' @description Get the vertices of the polygon.
    #' @return A named list with two fields: \code{"outer"}, the vertices of 
    #'   the outer polygon in a matrix, and \code{"holes"}, the vertices of 
    #'   the holes in a list of matrices.
    "getVertices" = function() {
      list(
        "outer" = private[[".vs_outer"]],
        "holes" = private[[".vs_holes"]]
      )
    },
    
    #' @description Intersection of the polygon with another polygon.
    #' @param pwh2 a \code{cgalPolygonWithHoles} object
    #' @return A list whose each element is either a \code{cgalPolygon} object
    #'   or a \code{cgalPolygonWithHoles} object.
    "intersection" = function(pwh2) {
      stopifnot(isCGALpolygonWithHoles(pwh2))
      xptr2 <- getXPtr2(pwh2)
      plgs <- private[[".CGALpolygonWithHoles"]]$boolop_intersection(xptr2)
      # output
      out <- vector("list", length = length(plgs))
      for(i in seq_along(plgs)) {
        plg   <- plgs[[i]]
        holes <- plg[["holes"]]
        if(length(holes) == 0L) {
          out[[i]] <- cgalPolygon$new(vertices = plg[["outer"]])
        } else {
          out[[i]] <- cgalPolygonWithHoles$new(
            outerVertices = plg[["outer"]], holes = holes
          )
        }
      }
      out
    },
    
    
    #' @description Minkowski sum of the polygon and another polygon.
    #' @param pwh2 a \code{cgalPolygonWithHoles} object, the polygon to add 
    #'   to the reference polygon
    #' @param method the method used: \code{"convolution"}, \code{"triangle"}, 
    #'   \code{"vertical"} or \code{"optimal"} (the method should not change 
    #'   the result)
    #' @return Either a \code{cgalPolygonWithHoles} object, or, in the case if 
    #'   there is no hole in the Minkowski sum, a \code{cgalPolygon} object.
    #' @examples 
    #' library(cgalPolygons)
    #' plg1 <- cgalPolygonWithHoles$new(decagram)
    #' plg2 <- cgalPolygonWithHoles$new(star)
    #' minko <- plg1$minkowskiSum(plg2)
    #' minko$plot(lwd = 2, col = "limegreen")
    "minkowskiSum" = function(pwh2, method = "convolution") {
      stopifnot(isCGALpolygonWithHoles(pwh2))
      method <- match.arg(
        method, c("convolution", "triangle", "vertical", "optimal")
      )
      xptr <- getXPtr2(pwh2)
      if(method == "convolution") {
        msum <- private[[".CGALpolygonWithHoles"]]$minkowskiC(xptr)
      } else if(method == "triangle") {
        msum <- private[[".CGALpolygonWithHoles"]]$minkowskiT(xptr)
      } else if(method == "vertical") {
        msum <- private[[".CGALpolygonWithHoles"]]$minkowskiV(xptr)
      } else {
        msum <- private[[".CGALpolygonWithHoles"]]$minkowskiO(xptr)
      }
      holes <- msum[["holes"]]
      if(length(holes) == 0L) {
        message("No hole in the Minkowski sum.")
        cgalPolygon$new(vertices = msum[["outer"]])
      } else {
        cgalPolygonWithHoles$new(
          outerVertices = msum[["outer"]], holes = holes
        )
      }
    },

        
    #' @description Plot the polygon with holes.
    #' @param outerpars named list of arguments passed to 
    #'   \code{\link[graphics]{polygon}} for the outer polygon
    #' @param ... arguments passed to \code{\link[graphics]{polygon}} for the 
    #'   holes
    #' @param new Boolean, whether to create a new plot
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
    "plot" = function(outerpars = list(), ..., new = TRUE) {
      stopifnot(isBoolean(new))
      if(new) {
        bbox <- private[[".CGALpolygonWithHoles"]]$boundingBox()
        plot(bbox, type = "n", asp = 1, xlab = NA, ylab = NA, axes = FALSE)
      }
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
    #' @return No value, just prints some information about the polygon.
    "print" = function(...) {
      private[[".CGALpolygonWithHoles"]]$print()
    }
    
  )
)