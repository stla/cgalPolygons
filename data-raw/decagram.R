R <- (sqrt(5) - 1)/2 # circumradius
vs1 <- vapply(0:9, function(i) {
  R * c(cospi(2*i/10), sinpi(2*i/10))
}, numeric(2L))

r <- sqrt(5 - 2*sqrt(5))/2 # inradius
rho <- sqrt(r^2 + (5/2 - sqrt(5))^2)
vs2 <- vapply(0:9, function(i) {
  rho * c(cospi(2*i/10 + 1/10), sinpi(2*i/10 + 1/10))
}, numeric(2L))

decagram <- matrix(NA_real_, nrow = 20L, ncol = 2L)
decagram[seq(1L, 19L, by = 2L), ] <- t(vs1)
decagram[seq(2L, 20L, by = 2L), ] <- t(vs2)
