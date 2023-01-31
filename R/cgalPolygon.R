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
    ".CGALpolygon" = NULL
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
      stopifnot(noMissingValue(vertices))
      private[[".CGALpolygon"]] <- CGALpolygon$new(t(vertices))
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
    }
    
  )
)