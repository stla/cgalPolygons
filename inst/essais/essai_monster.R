library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
pwh

pwh$plot(
  outerpars = list(lwd = 2), density = 18
)


library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
cxparts <- pwh$convexParts(method = "triangle")

par(mar = c(0, 0, 0, 0))
pwh$plot(list(col = "pink"), col = "yellow")
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
