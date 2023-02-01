library(cgalPolygons)
square <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)
epstar <- cgalPolygonWithHoles$new(star)

msum <- square$minkowskiSum(epstar)
msum$plot()
