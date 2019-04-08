BSCall <- function(S, K, r, T, sigma) {
d1 <- (log(S/K)+(r-sigma^2/2)*T)/(sigma*sqrt(T))
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
