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
# difference
plgList <- plg1$subtract(plg2)
# plot
opar <- par(mar = c(0, 0, 0, 0))
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-1.6, 1.6), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plgList[[1]]$plot(lwd = 4, col = "red", new = FALSE)
plgList[[2]]$plot(lwd = 4, col = "red", new = FALSE)
par(opar)

