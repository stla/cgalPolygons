library(cgalPolygons)
square <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)

plg1 <- cgalPolygonWithHoles$new(decagram)
plg2 <- cgalPolygonWithHoles$new(star)
minko <- plg1$minkowskiSum(plg2)
minko$plot(lwd = 2, col = "limegreen")
