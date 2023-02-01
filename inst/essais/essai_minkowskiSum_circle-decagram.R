library(cgalPolygons)

circle <- function(r) {
  t <- seq(0, 2, length.out = 200)[-1]
  r * cbind(cospi(t), sinpi(t))
}

plg1 <- cgalPolygonWithHoles$new(decagram)
plg2 <- cgalPolygonWithHoles$new(circle(0.1))
minko <- plg1$minkowskiSum(plg2)
minko$plot(lwd = 2, col = "#00009988")
polygon(decagram, lwd = 4)

plg1 <- cgalPolygonWithHoles$new(decagram)
plg2 <- cgalPolygonWithHoles$new(circle(0.1))
minko <- plg1$minkowskiSum(plg2)
vs <- minko$getVertices()
plot(plg1$boundingBox()*1.5, type = "n", asp = 1, axes = FALSE, xlab = NA, ylab = NA)
polygon(vs, lwd = 2, col = "#00009988")
polygon(decagram, lwd = 4)



# animation ####
r_ <- seq(0.1, 0.3, length.out = 100)
plg1 <- cgalPolygonWithHoles$new(decagram)

for(i in seq_along(r_)) {
  plg2 <- cgalPolygonWithHoles$new(circle(r_[i]))
  minko <- plg1$minkowskiSum(plg2)
  vs <- minko$getVertices()
  svglite::svglite("x.svg", width = 8, height = 8)
  par(mar = c(0, 0, 0, 0))
  plot(
    plg1$boundingBox()*1.5, type = "n", asp = 1, 
    axes = FALSE, xlab = NA, ylab = NA
  )
  polygon(vs, lwd = 2, col = "#00009988")
  polygon(decagram, lwd = 4)
  dev.off()
  png <- sprintf("cc%03d.png", i)
  rsvg::rsvg_png("x.svg", png, width = 512, height = 512)
}

cmd <- 
  "convert -delay 1x13 -duplicate 1,-2-1 cc*.png minko_circle-decagram.gif"
system(cmd)


