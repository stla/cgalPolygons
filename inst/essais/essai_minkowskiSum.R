library(cgalPolygons)
square <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)

plg1 <- cgalPolygonWithHoles$new(decagram)
plg2 <- cgalPolygonWithHoles$new(star)

msum <- plg1$minkowskiSum(plg2)
msum$plot(lwd = 2)
