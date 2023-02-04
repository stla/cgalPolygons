library(cgalPolygons)
# function creating a circle
circle <- function(x, y, r) {
  t <- seq(0, 2, length.out = 100)[-1L]
  t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
}
# take two circles with a hole
plg1 <- cgalPolygonWithHoles$new(
  circle(-1, 0, 1.5), holes = list(circle(-1, 0, 0.8))
)
plg2 <- cgalPolygonWithHoles$new(
  circle(1, 0, 1.5), holes = list(circle(1, 0, 0.8))
)
# symmetric difference
plgList <- plg1$symdiff(plg2)
plg <- plgList[[1L]]
# plot
opar <- par(mar = c(0, 0, 0, 0))
plg$plot(list(lwd = 4, col = "red"), lwd = 4, col = "white")
par(opar)

