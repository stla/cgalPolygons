library(cgalPolygons)
# function creating a circle
circle <- function(x, y, r) {
  t <- seq(0, 2, length.out = 100)[-1L]
  t(c(x, y) + r * rbind(cospi(t), sinpi(t)))
}
# take two circles
plg1 <- cgalPolygonWithHoles$new(circle(-1, 0, 1.25))
plg2 <- cgalPolygonWithHoles$new(circle(1, 0, 1.25))
# intersection
plgList <- plg1$union(plg2)
plg <- plgList[[1]]
# plot
opar <- par(mar = c(0, 0, 0, 0))
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plg1$plot(list(lwd = 2), new = FALSE)
plg2$plot(list(lwd = 2), new = FALSE)
plg$plot(lwd = 3, col = "red", new = FALSE)
par(opar)

# save plot
svglite::svglite("x.svg", width = 8, height = 4)
opar <- par(mar = c(0, 0, 0, 0))
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-1.3, 1.3), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plg1$plot(list(lwd = 2), new = FALSE)
plg2$plot(list(lwd = 2), new = FALSE)
plg$plot(lwd = 3, col = "red", new = FALSE)
par(opar)
dev.off()
png <- "boolop_union.png"
rsvg::rsvg_png("x.svg", png, width = 512, height = 256)
file.remove("x.svg")

