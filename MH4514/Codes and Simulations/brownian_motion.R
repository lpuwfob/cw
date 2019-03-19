N=1000
t <- 0:N 
dt <- 1.0/N
x <- (dt)^0.5*(rbinom( N, 1, 0.5)-0.5)*2
x <- c(0, cumsum(x))
plot(t, x, type = "l")

nsim <- 10
X <- matrix((dt)^0.5*(rbinom( nsim * N, 1, 0.5)-0.5)*2, nsim, N)
X <- cbind(rep(0, nsim), t(apply(X, 1, cumsum)))
plot(t, X[1, ], xlab = "time", type = "l", ylim = c(-2, 2), col = t)
for (i in 2:nsim){
lines(t, X[i, ], xlab = "time", type = "l", ylim = c(-2, 2), col = i)
}

N=100
t <- 0:N 
dt <- 1.0/N
x <- rnorm(n = N, sd = (dt)^0.5)
x <- c(0, cumsum(x))
plot(t, x, type = "l")

nsim <- 10
X <- matrix(rnorm(n = nsim * N, sd = sqrt(dt)), nsim, N)
X <- cbind(rep(0, nsim), t(apply(X, 1, cumsum)))
plot(t, X[1, ], xlab = "time", type = "l", ylim = c(-2, 2), col = t)
for (i in 2:nsim){
lines(t, X[i, ], xlab = "time", type = "l", ylim = c(-2, 2), col = i)
}
