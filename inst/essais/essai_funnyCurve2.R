library(cgalPolygons)

t_ <- seq(-pi, pi, length.out = 193L)[-1L]
r_ <- 0.1 + 5*sqrt(cos(6*t_)^2 + 0.7^2)
outer <- cbind(r_*cos(t_), r_*sin(t_))
m <- 10L  # inner number of sides
angles2 <- seq(0, 2*pi, length.out = m + 1L)[-1L]
inner <- 1 * cbind(cos(angles2), sin(angles2))

plg <- cgalPolygonWithHoles$new(outer, list(inner))

cxparts <- plg$convexParts("triangle")

colors <- randomcoloR::distinctColorPalette(length(cxparts))

plg$plot(lwd = 3)
invisible(
  lapply(1L:length(cxparts), function(i) {
    polygon(cxparts[[i]], col = colors[i])
  })
)

#
svglite::svglite("funnyCurve.svg", width = 8, height = 8)
par(mar = c(0, 0, 0, 0))
plg$plot(lwd = 3)
invisible(
  lapply(1L:length(cxparts), function(i) {
    polygon(cxparts[[i]], col = colors[i])
  })
)
dev.off()

rsvg::rsvg_png("funnyCurve.svg", "funnyCurve.png", width = 512, height = 512)
