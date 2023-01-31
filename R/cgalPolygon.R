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
    #' @return No returned value, called for side-effect.
    #' @importFrom graphics plot polygon
    #' @examples 
    #' library(cgalPolygons)
    #' ptg <- cgalPolygon$new(pentagram)
    #' plot(ptg, lwd = 3, col = "red")
    "plot" = function(...) {
      bbox <- private[[".CGALpolygon"]]$boundingBox()
      plot(bbox, type = "n", asp = 1, xlab = NA, ylab = NA, axes = FALSE)
      polygon(private[[".vertices"]], ...)
      invisible(NULL)
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