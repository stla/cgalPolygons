library(cgalPolygons)
square <- cgalPolygonWithHoles$new(
  squareWithHole[["outerSquare"]], list(squareWithHole[["innerSquare"]])
)

plg1 <- cgalPolygonWithHoles$new(decagram)
plg2 <- cgalPolygonWithHoles$new(star)
minko <- plg1$minkowskiSum(plg2)
minko$plot(lwd = 2, col = "limegreen")


library(cgalPolygons)

t_ <- seq(-pi, pi, length.out = 193L)[-1L]
r_ <- 0.1 + 5*sqrt(cos(6*t_)^2 + 0.7^2)
outer <- cbind(r_*cos(t_), r_*sin(t_))
m <- 10L  # inner number of sides
angles2 <- seq(0, 2*pi, length.out = m + 1L)[-1L]
inner <- 1 * cbind(cos(angles2), sin(angles2))

plg1 <- cgalPolygonWithHoles$new(outer/2, list(inner/2))
plg2 <- cgalPolygonWithHoles$new(star)
minko <- plg1$minkowskiSum(plg2)
minko$plot(lwd = 2, col = "yellowgreen")


#
svglite::svglite("x.svg", width = 8, height = 8)
par(mar = c(0, 0, 0, 0))
minko$plot(lwd = 2, col = "yellowgreen")
dev.off()

rsvg::rsvg_png("x.svg", "msum_star-funnyCurve.png", width = 512, height = 512)
