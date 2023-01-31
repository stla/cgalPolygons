library(cgalPolygons)
ptg <- cgalPolygon$new(pentagram)
ptg$area() # should be 5 / sqrt(130 + 58*sqrt(5))
5 / sqrt(130 + 58*sqrt(5))