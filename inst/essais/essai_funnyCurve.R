library(cgalPolygons)

t_ <- seq(-pi, pi, length.out = 193L)[-1L]
r_ <- 0.1 + 5*sqrt(cos(6*t_)^2 + 0.7^2)
xy <- cbind(r_*cos(t_), r_*sin(t_))

plg <- cgalPolygon$new(xy)

cxparts <- plg$convexParts("approx")

colors <- randomcoloR::distinctColorPalette(length(cxparts))

plg$plot(lwd = 3)
invisible(
  lapply(1L:length(cxparts), function(i) {
    polygon(cxparts[[i]], col = colors[i])
  })
)







svglite::svglite("star.svg", width = 8, height = 8)
par(mar = c(0, 0, 0, 0))
plg$plot(col = "cyan", lwd = 3)
invisible(
  lapply(1:9, function(i) {
    polygon(cxparts[[i]], lwd = 2, col = colors[i])
  })
)
dev.off()

rsvg::rsvg_png("star.svg", "star.png", width = 512, height = 512)
