library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)
pwh

pwh$plot(
  outerpars = list(lwd = 2), density = 10
)


library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)
cxparts <- pwh$convexParts(method = "vertical")
pwh$plot(list(), density = 10)
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
