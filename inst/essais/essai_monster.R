library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
pwh

pwh$plot(
  outerpars = list(lwd = 2), density = 18
)


library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
cxparts <- pwh$convexParts(method = "triangle")

svglite::svglite("monster.svg", width = 8, height = 8)
par(mar = c(0, 0, 0, 0))
pwh$plot(list(col = "indianred"), col = "yellow3")
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
dev.off()

rsvg::rsvg_png("monster.svg", "monster.png", width = 512, height = 512)