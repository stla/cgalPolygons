outer <- rbind(
  c(  80,    0),
  c( 100,   50),
  c(   0,  100),
  c(-100,   50),
  c( -80,    0),
  c(-100,  -50),
  c(   0, -100),
  c( 100,  -50)
)

mouth <- rbind(
  c(  0,  -90),
  c( 80,  -50),
  c(  0,  -10),
  c(-80,  -50)
)

eye1 <- rbind(
  c(-70,  50),
  c(-60,  30),
  c(-10,  55),
  c(-40,  55)
)

eye2 <- rbind(
  c(70,  50),
  c(60,  30),
  c(10,  55),
  c(40,  55)
)


monster <- list(
  "outer" = outer,
  "holes" = list(mouth, eye1, eye2)
)

