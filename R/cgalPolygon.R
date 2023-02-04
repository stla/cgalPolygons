getXPtr <- function(cPolygon){
  cPolygon[[".__enclos_env__"]][["private"]][[".CGALpolygon"]][["xptr"]]
}

#' @title R6 class to represent a CGAL polygon
#' @description R6 class to represent a CGAL polygon.
#'
#' @importFrom R6 R6Class
#' @export
cgalPolygon <- R6Class(
  "cgalPolygon",
  
  lock_class = TRUE,
  
  cloneable = FALSE,
  
  private = list(
    ".CGALpolygon" = NULL,
    ".vertices"    = NULL
  ),
  
  public = list(
    
    #' @description Creates a new \code{cgalpolygon} object.
    #' @param vertices a numeric matrix with two columns
    #' @return A \code{cgalPolygon} object.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg
    "initialize" = function(vertices) {
      # one can also initialize from an external pointer, but 
      # this is hidden to the user
      if(inherits(vertices, "externalptr")) {
        private[[".CGALpolygon"]] <- CGALpolygon$new(vertices, TRUE)
        return(invisible(self))
      }
      stopifnot(is.matrix(vertices))
      stopifnot(ncol(vertices) == 2L)
      stopifnot(nrow(vertices) >= 3L)
      storage.mode(vertices) <- "double"
      stopifnot(noMissingValue(vertices))
      private[[".CGALpolygon"]] <- CGALpolygon$new(t(vertices))
      private[[".vertices"]]    <- vertices
      invisible(self)
    },
    
    #' @description Print the \code{cgalPolygon} object.
    #' @param ... ignored
    #' @return No value, just prints some information about the polygon.
    "print" = function(...) {
      private[[".CGALpolygon"]]$print()
    },

    
    #' @description Signed area of the polygon.
    #' @return A number, the signed area of the polygon; it is positive if the 
    #'   polygon is counter-clockwise oriented, negative otherwise.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$area() # should be 5 / sqrt(130 + 58*sqrt(5))
    #' 5 / sqrt(130 + 58*sqrt(5))
    "area" = function() {
      private[[".CGALpolygon"]]$area()
    },
    
    
    #' @description Bounding box of the polygon.
    #' @return A 2x2 matrix giving the lower corner of the bounding box in its 
    #'   first row and the upper corner in its second row.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' plot(ptg$boundingBox(), asp = 1)
    #' polygon(pentagram)
    "boundingBox" = function() {
      private[[".CGALpolygon"]]$boundingBox()
    },


    #' @description Decomposition into convex parts. The polygon must be simple 
    #'   and counter-clockwise oriented.
    #' @param method the method used: \code{"approx"}, \code{"greene"}, 
    #'   or \code{"optimal"}
    #' @return A list of matrices; each matrix has two columns and represents 
    #'   a convex polygon.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' cxparts <- ptg$convexParts()
    #' ptg$plot(col = "yellow", lwd = 3)
    #' invisible(
    #'   lapply(cxparts, function(cxpart) {
    #'     polygon(cxpart, lwd = 2)
    #'   })
    #' )
    "convexParts" = function(method = "optimal") {
      method <- match.arg(method, c("approx", "greene", "optimal"))
      if(method == "approx") {
        private[[".CGALpolygon"]]$approxConvexParts()
      } else if(method == "greene") {
        private[[".CGALpolygon"]]$greeneApproxConvexParts()
      } else {
        private[[".CGALpolygon"]]$optimalConvexParts()
      }
    },

        
    #' @description Vertices of the polygon.
    #' @return The vertices in a matrix with two columns.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$getVertices()
    "getVertices" = function() {
      private[[".vertices"]]
    },
    
    
    #' @description Intersection of the polygon with another polygon.
    #' @param plg2 a \code{cgalPolygon} object or a \code{cgalPolygonWithHoles} 
    #'   object
    #' @return A list whose each element is either a \code{cgalPolygon} object
    #'   or a \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' # function creating a circle
    #' circle <- function(x, y, r) {
    #'   t <- seq(0, 2, length.out = 100)[-1L]
    #'   t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
    #' }
    #' # take two circles
    #' plg1 <- cgalPolygon$new(circle(-1, 0, 1.25))
    #' plg2 <- cgalPolygon$new(circle(1, 0, 1.25))
    #' # intersection
    #' plgList <- plg1$intersection(plg2)
    #' plg <- plgList[[1L]]
    #' # plot
    #' opar <- par(mar = c(0, 0, 0, 0))
    #' plot(
    #'   NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
    #'   xlab = NA, ylab = NA, axes = FALSE
    #' )
    #' plg1$plot(lwd = 2, new = FALSE)
    #' plg2$plot(lwd = 2, new = FALSE)
    #' plg$plot(lwd = 3, col = "red", new = FALSE)
    #' par(opar)
    "intersection" = function(plg2) {
      stopifnot(isCGALpolygon(plg2) || isCGALpolygonWithHoles(plg2))
      if(isCGALpolygonWithHoles(plg2)) {
        return(plg2$intersection(self))
      }
      xptr2 <- getXPtr(plg2)
      plgs <- private[[".CGALpolygon"]]$boolop_intersection(xptr2)
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
    
    
    #' @description Checks whether the polygon is clockwise oriented.
    #' @return A Boolean value.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$isCWO()
    "isCWO" = function() {
      private[[".CGALpolygon"]]$isCWO()
    },

    
    #' @description Checks whether the polygon is counter-clockwise oriented.
    #' @return A Boolean value.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$isCCWO()
    "isCCWO" = function() {
      private[[".CGALpolygon"]]$isCCWO()
    },

    
    #' @description Checks whether the polygon is convex.
    #' @return A Boolean value.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$isConvex()
    "isConvex" = function() {
      private[[".CGALpolygon"]]$isConvex()
    },

    
    #' @description Checks whether the polygon is simple; that means its edges 
    #'   do not intersect (except two consecutive edges which intersect at 
    #'   their common vertex)
    #' @return A Boolean value.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$isSimple()
    "isSimple" = function() {
      private[[".CGALpolygon"]]$isSimple()
    },
    
    
    #' @description Plot the polygon.
    #' @param ... arguments passed to \code{\link[graphics]{polygon}}
    #' @param new Boolean, whether to create a new plot
    #' @return No returned value, called for side-effect.
    #' @importFrom graphics plot polygon
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$plot(lwd = 3, col = "red")
    "plot" = function(..., new = TRUE) {
      stopifnot(isBoolean(new))
      if(new) {
        bbox <- private[[".CGALpolygon"]]$boundingBox()
        plot(bbox, type = "n", asp = 1, xlab = NA, ylab = NA, axes = FALSE)
      }
      polygon(private[[".vertices"]], ...)
      invisible(NULL)
    },

    
    #' @description Reverse the orientation of the polygon.
    #' @return The \code{cgalPolygon} object, invisibly.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' ptg$isCCWO()
    #' ptg$reverseOrientation()
    #' ptg$isCCWO()
    "reverseOrientation" = function() {
      vertices <- private[[".CGALpolygon"]]$reverseOrientation()
      private[[".vertices"]] <- vertices
      invisible(self)
    },
    
    
    #' @description Difference between the polygon and another polygon.
    #' @param plg2 a \code{cgalPolygon} object or a \code{cgalPolygonWithHoles} 
    #'   object
    #' @return A list whose each element is either a \code{cgalPolygon} object
    #'   or a \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' # function creating a circle
    #' circle <- function(x, y, r) {
    #'   t <- seq(0, 2, length.out = 100)[-1L]
    #'   t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
    #' }
    #' # take two circles
    #' plg1 <- cgalPolygon$new(circle(-1, 0, 1.25))
    #' plg2 <- cgalPolygon$new(circle(1, 0, 1.25))
    #' # difference
    #' plgList <- plg1$subtract(plg2)
    #' plg <- plgList[[1L]]
    #' # plot
    #' opar <- par(mar = c(0, 0, 0, 0))
    #' plot(
    #'   NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
    #'   xlab = NA, ylab = NA, axes = FALSE
    #' )
    #' plg1$plot(lwd = 2, new = FALSE)
    #' plg2$plot(lwd = 2, new = FALSE)
    #' plg$plot(lwd = 3, col = "red", new = FALSE)
    #' par(opar)
    "subtract" = function(plg2) {
      stopifnot(isCGALpolygon(plg2) || isCGALpolygonWithHoles(plg2))
      if(isCGALpolygon(plg2)) {
        xptr2 <- getXPtr(plg2)
        plgs <- private[[".CGALpolygon"]]$boolop_subtract(xptr2)
      } else {
        xptr2 <- getXPtr2(plg2)
        plgs <- private[[".CGALpolygon"]]$boolop_subtract2(xptr2)
      }
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
    
    
    #' @description Symmetric difference of the polygon and another polygon.
    #' @param plg2 a \code{cgalPolygon} object or a \code{cgalPolygonWithHoles} 
    #'   object
    #' @return A list whose each element is either a \code{cgalPolygon} object
    #'   or a \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' # function creating a circle
    #' circle <- function(x, y, r) {
    #'   t <- seq(0, 2, length.out = 100)[-1L]
    #'   t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
    #' }
    #' # take two circles
    #' plg1 <- cgalPolygon$new(circle(-1, 0, 1.25))
    #' plg2 <- cgalPolygon$new(circle(1, 0, 1.25))
    #' # symmetric difference
    #' plgList <- plg1$symdiff(plg2)
    #' plg <- plgList[[1L]]
    #' # plot
    #' opar <- par(mar = c(0, 0, 0, 0))
    #' plot(
    #'   NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
    #'   xlab = NA, ylab = NA, axes = FALSE
    #' )
    #' plg1$plot(lwd = 2, new = FALSE)
    #' plg2$plot(lwd = 2, new = FALSE)
    #' plg$plot(list(lwd = 3, col = "red"), col = "white", new = FALSE)
    #' par(opar)
    "symdiff" = function(plg2) {
      stopifnot(isCGALpolygon(plg2) || isCGALpolygonWithHoles(plg2))
      if(isCGALpolygonWithHoles(plg2)) {
        return(plg2$symdiff(self))
      }
      xptr2 <- getXPtr(plg2)
      plgs <- private[[".CGALpolygon"]]$boolop_symdiff(xptr2)
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
    
    
    #' @description Union of the polygon with another polygon.
    #' @param plg2 a \code{cgalPolygon} object or a \code{cgalPolygonWithHoles} 
    #'   object
    #' @return A list whose each element is either a \code{cgalPolygon} object
    #'   or a \code{cgalPolygonWithHoles} object.
    #' @examples 
    #' library(cgalPolygons)
    #' # function creating a circle
    #' circle <- function(x, y, r) {
    #'   t <- seq(0, 2, length.out = 100)[-1L]
    #'   t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
    #' }
    #' # take two circles
    #' plg1 <- cgalPolygon$new(circle(-1, 0, 1.25))
    #' plg2 <- cgalPolygon$new(circle(1, 0, 1.25))
    #' # union
    #' plgList <- plg1$union(plg2)
    #' plg <- plgList[[1L]]
    #' # plot
    #' opar <- par(mar = c(0, 0, 0, 0))
    #' plot(
    #'   NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
    #'   xlab = NA, ylab = NA, axes = FALSE
    #' )
    #' plg1$plot(lwd = 2, new = FALSE)
    #' plg2$plot(lwd = 2, new = FALSE)
    #' plg$plot(lwd = 3, col = "red", new = FALSE)
    #' par(opar)
    "union" = function(plg2) {
      stopifnot(isCGALpolygon(plg2) || isCGALpolygonWithHoles(plg2))
      if(isCGALpolygonWithHoles(plg2)) {
        return(plg2$union(self))
      }
      xptr2 <- getXPtr(plg2)
      plgs <- private[[".CGALpolygon"]]$boolop_union(xptr2)
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
    
    
    #' @description Locate point(s) with respect to the polygon. The polygon 
    #'   must be simple.
    #' @param points a numeric matrix with two columns, or a numeric vector 
    #'   of length 2 (for a single point)
    #' @return An integer vector with possible values \code{-1}, \code{1}, or 
    #'   \code{0}: value \code{-1} for outside, \code{1} for inside, and 
    #'   \code{0} if the point is on the boundary of the polygon.
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' pt1 <- c(0, 0) # inside
    #' pt2 <- c(4, 0) # outside
    #' ptg$whereIs(rbind(pt1, pt2))
    "whereIs" = function(points) {
      if(!is.matrix(points)) {
        points <- rbind(points)
      }
      stopifnot(ncol(points) == 2L)
      storage.mode(points) <- "double"
      stopifnot(noMissingValue(points))
      private[[".CGALpolygon"]]$whereIs(t(points))
    }
    
  )
)