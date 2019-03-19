N=1000; t <- 0:N; dt <- 1.0/N; nsim <- 50 # using Bernoulli samples
sigma=0.2
r=-0.5
a=(1+r*dt)*(1-sigma*sqrt(dt))-1
b=(1+r*dt)*(1+sigma*sqrt(dt))-1
X <- matrix(a+(b-a)*rbinom( nsim * N, 1, 0.5), nsim, N)
X <- cbind(rep(0, nsim), t(apply((1+X), 1, cumprod)))
X[,1]=1
H<-hist(X[,N]) 
layout(matrix(c(1,2), nrow =1, byrow = TRUE))
par(mar=c(2,2,2,0), oma = c(2, 2, 2, 2))
plot(t, X[1, ], xlab = "time", ylab = "", type = "l", ylim = c(0, 2), col = 0)
for (i in 1:nsim){lines(t, X[i, ], xlab = "time", type = "l", ylim = c(0, 2), col = i)}
lines((1+r*dt)^t, type="l", lty=1, col="black",lwd=3,xlab="",ylab="", main="")
for (i in 1:nsim){points(N, X[i,N], pch=1, lwd = 5, col = i)}
x <- seq(0.01,2, length=100)
px <- exp(-(-(r-sigma^2/2)+log(x))^2/2/sigma^2)/x/sigma/sqrt(2*pi)
par(mar = c(2,2,2,2))
plot(NULL , xlab="", ylab="", xlim = c(0, max(px,H$density)), ylim = c(0,2),axes=F)
rect(0, H$breaks[1:(length(H$breaks) - 1)], col=rainbow(20,start=0.08,end=0.6), H$density, H$breaks[2:length(H$breaks)])
lines(px,x, type="l", lty=1, col="black",lwd=2,xlab="",ylab="", main="")
