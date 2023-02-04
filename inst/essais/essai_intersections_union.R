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
# intersection 1
plgList <- plg1$intersection(plg2)
plginter1 <- plgList[[1]]
# take two circles with a hole
plg3 <- cgalPolygonWithHoles$new(
  circle(0, -1, 1.5), holes = list(circle(0, -1, 0.8))
)
plg4 <- cgalPolygonWithHoles$new(
  circle(0, 1, 1.5), holes = list(circle(0, 1, 0.8))
)
# intersection 2
plgList <- plg3$intersection(plg4)
plginter2 <- plgList[[1]]
# union of the two intersections
plgList <- plginter1$union(plginter2)
plg <- plgList[[1]]
# plot
opar <- par(mar = c(0, 0, 0, 0))
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-2.6, 2.6), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plg1$plot(list(lwd = 2), lwd = 2, density = 10, new = FALSE)
plg2$plot(list(lwd = 2), lwd = 2, density = 10, new = FALSE)
plg3$plot(list(lwd = 2), lwd = 2, density = 10, new = FALSE)
plg4$plot(list(lwd = 2), lwd = 2, density = 10, new = FALSE)
plg$plot(lwd = 3, col = "red", new = FALSE)
par(opar)


# save plot
svglite::svglite("x.svg", width = 8, height = 8)
opar <- par(mar = c(0, 0, 0, 0))
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-2.6, 2.6), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plg1$plot(
  list(lwd = 2, border = "blue"), 
  lwd = 2, density = 20, angle = 0, border = "blue", 
  new = FALSE, outerfirst = FALSE
)
plg2$plot(
  list(lwd = 2, border = "blue"), 
  lwd = 2, density = 20, angle = 0, border = "blue", 
  new = FALSE, outerfirst = FALSE
)
plg3$plot(
  list(lwd = 2, border = "blue"), 
  lwd = 2, density = 20, angle = 90, border = "blue", 
  new = FALSE, outerfirst = FALSE
)
plg4$plot(
  list(lwd = 2, border = "blue"), 
  lwd = 2, density = 20, angle = 90, border = "blue", 
  new = FALSE, outerfirst = FALSE
)
plg$plot(lwd = 3, col = "red", border = "blue", new = FALSE)
par(opar)
dev.off()
png <- "boolop_withHoles.png"
rsvg::rsvg_png("x.svg", png, width = 512, height = 512)
file.remove("x.svg")


opar <- par(mar = c(0, 0, 0, 0), bg = "pink")
plot(
  NULL, xlim = c(-2.6, 2.6), ylim = c(-2.6, 2.6), asp = 1, 
  xlab = NA, ylab = NA, axes = FALSE
)
plg1$plot(
  list(lwd = 2, border = "blue", col = "green"), 
  lwd = 2, border = "blue", col = "pink",
  new = FALSE, outerfirst = TRUE
)
plg2$plot(
  list(lwd = 2, border = "blue", col = "green"), 
  lwd = 2, border = "blue", col = "pink", 
  new = FALSE, outerfirst = TRUE
)
plg3$plot(
  list(lwd = 2, border = "blue", col = "green"), 
  lwd = 2, border = "blue", col = "pink", 
  new = FALSE, outerfirst = TRUE
)
plg4$plot(
  list(lwd = 2, border = "blue", col = "green"), 
  lwd = 2, border = "blue", col = "pink", 
  new = FALSE, outerfirst = TRUE
)
plg$plot(lwd = 3, col = "red", border = "darkred", new = FALSE)
par(opar)
