library(cgalPolygons)

ptg <- cgalPolygon$new(pentagram)
ptg$area() # should be 5 / sqrt(130 + 58*sqrt(5))
5 / sqrt(130 + 58*sqrt(5))

library(cgalPolygons)
ptg <- cgalPolygon$new(pentagram)
plot(ptg, lwd = 3, col = "red")

library(cgalPolygons)
ptg <- cgalPolygon$new(pentagram)
pt1 <- c(0, 0) # inside
pt2 <- c(4, 0) # outside
ptg$whereIs(rbind(pt1, pt2))
