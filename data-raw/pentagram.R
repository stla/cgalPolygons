rho <- sqrt((5 - sqrt(5))/10)
vs1 <- vapply(0:4, function(i) {
  rho * c(cospi(2*i/5), sinpi(2*i/5))
}, numeric(2L))

R <- sqrt((25 - 11*sqrt(5))/10)
vs2 <- vapply(0:4, function(i){
  R * c(cospi(2*i/5 + 1/5), sinpi(2*i/5 + 1/5))
}, numeric(2L))

pentagram <- matrix(NA_real_, nrow = 10L, ncol = 2L)
pentagram[c(1L, 3L, 5L, 7L, 9L), ]  <- t(vs1)
pentagram[c(2L, 4L, 6L, 8L, 10L), ] <- t(vs2)
