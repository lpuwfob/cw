BSCall <- function(S, K, r, T, sigma) {
d1 <- (log(S/K)+(r+sigma^2/2)*T)/(sigma*sqrt(T))
d2 <- d1 - sigma * sqrt(T)
BSCall = S*pnorm(d1) - K*exp(-r*T)*pnorm(d2)
BSCall
}

BSPut <- function(S, K, r, T, sigma) {
d1 = (log(S/K)+(r-sigma^2/2)*T)/(sigma*sqrt(T))
d2 = d1 - sigma * sqrt(T)
BSPut = K*exp(-r*T) * pnorm(-d2) - S*pnorm(-d1)
BSPut
}

K=36.08
r=0.02
T=46/365
sigma=0.2
curve(BSCall(x, K, r, T, sigma), from=0, to=100, lwd = 3, xlab="S", col="blue", ylab="price")
grid()

S=17.20
K=36.08
r=0.02
T=46/365
curve(BSCall(S, K, r, T, x), from=0.5, to=1.5, xlab="sigma", ylab="price", lwd = 3,col="red")
grid()


