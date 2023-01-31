library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
pwh

pwh$plot(
  outerpars = list(lwd = 2), density = 18
)


library(cgalPolygons)
pwh <- cgalPolygonWithHoles$new(monster[["outer"]], monster[["holes"]])
cxparts <- pwh$convexParts(method = "triangle")
pwh$plot(list(), density = 18)
invisible(
  lapply(cxparts, function(cxpart) {
    polygon(cxpart, lwd = 2)
  })
)
