library(cgalPolygons)

circle <- function(x, y, r) {
  t <- seq(0, 2, length.out = 100)[-1L]
  t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
}

plg1 <- cgalPolygonWithHoles$new(circle(-1, 0, 1.25))
plg2 <- cgalPolygonWithHoles$new(circle(1, 0, 1.25))

plgList <- pgnsIntersection(plg1, plg2)
plg <- cgalPolygonWithHoles$new(plgList[[1]]$outer)

plg$plot(list(lwd = 3, col = "red"))
