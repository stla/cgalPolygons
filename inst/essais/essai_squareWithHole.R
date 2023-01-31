library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)
pwh


library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)
cxparts <- pwh$convexParts()
plot(NULL, xlim = c(-3, 3), ylim = c(-3, 3))
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
