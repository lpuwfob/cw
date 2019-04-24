N=10000; t <- 0:(N-1); dt <- 1.0/N; nsim <- 3
a=0.025; b=1; sigma=0.1; sd=sqrt(sigma^2/2/b)
X <- matrix(rnorm(n = nsim * N, sd = sqrt(dt)), nsim, N)
R <- matrix(0,nsim,N)
for (i in 1:nsim){R[i,1]=0.03}
for (i in 1:nsim){for (j in 2:N){R[i,j]=max(0,R[i,j-1]+(a-b*R[i,j-1])*dt+sigma*sqrt(R[i,j-1])*X[i,j])}}
plot(t, R[1, ], xlab = "time", ylab = "", type = "l", ylim = c(0,R[1,1]+sd/5), col = t,axes=FALSE)
axis(2, pos=0)
for (i in 2:nsim){lines(t, R[i, ], xlab = "time", type = "l", col = i+7)}
abline(h=a/b,col="blue",lwd=3)
abline(h=0) 

