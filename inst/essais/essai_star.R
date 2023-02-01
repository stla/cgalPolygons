library(cgalPolygons)

plg <- cgalPolygon$new(star)
#
cxparts <- plg$convexParts("approx")
plg$plot(col = "yellow", lwd = 3)
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
#
cxparts <- plg$convexParts("greene")
plg$plot(col = "orange", lwd = 3)
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
#
colors <- randomcoloR::distinctColorPalette(9)
cxparts <- plg$convexParts("optimal")

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
