N=1000; t <- 0:N; dt <- 1.0/N; nsim <- 50 # using Bernoulli samples
X <- matrix((dt)^0.5*(rbinom( nsim * N, 1, 0.5)-0.5)*2, nsim, N)
X <- cbind(rep(0, nsim), t(apply(X, 1, cumsum)))
H<-hist(X[,N]) 
layout(matrix(c(1,2), nrow =1, byrow = TRUE))
par(mar=c(2,2,2,0), oma = c(2, 2, 2, 2))
plot(t, X[1, ], xlab = "time", ylab = "", type = "l", ylim = c(-2, 2), col = 0)
for (i in 1:nsim){lines(t, X[i, ], xlab = "time", type = "l", ylim = c(-2, 2), col = i)}
for (i in 1:nsim){points(N, X[i,N], pch=1, lwd = 5, col = i)}
x <- seq(-2,2, length=100)
px <- dnorm(x)
par(mar = c(2,2,2,2))
plot(NULL , xlab="", ylab="", xlim = c(0, max(px,H$density)), ylim = c(-2,2),axes=F)
rect(0, H$breaks[1:(length(H$breaks) - 1)], col=rainbow(20,start=0.08,end=0.6), H$density, H$breaks[2:length(H$breaks)])
lines(px,x, type="l", lty=1, col="black",lwd=2,xlab="",ylab="", main="")
