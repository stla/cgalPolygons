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
    #' @param vertices if \code{mesh} is missing, must be a numeric matrix with 
    #'   three columns
    #' @return A \code{cgalPolygon} object.
    #' @examples 
    #' library(cgalPolygon)
    #' mesh <- cgalMesh$new(meshFile)
    #' rglmesh <- mesh$getMesh()
    "initialize" = function(vertices) {
      # one can also initialize from an external pointer, but 
      # this is hidden to the user
      if(inherits(vertices, "externalptr")) {
        private[[".CGALpolygon"]] <- CGALpolygon$new(vertices, TRUE)
        return(invisible(self))
      }
      private[[".CGALpolygon"]] <- CGALpolygon$new(vertices)
      invisible(self)
    },
    
    #' @description Print a \code{cgalPolygon} object.
    #' @param ... ignored
    #' @return No value, just prints some information about the polygon.
    "print" = function(...) {
      private[[".CGALpolygon"]]$print()
    }
    
  )
)