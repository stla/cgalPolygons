vs_outer <- rbind(
  c(-2, -2), 
  c( 2, -2),
  c( 2,  2),
  c(-2,  2)
)

vs_hole <- rbind(
  c(-1, -1), 
  c( 1, -1),
  c( 1,  1),
  c(-1,  1)
)

squareWithHole <- list(
  "outerSquare" = vs_outer,
  "innerSquare" = vs_hole
)
