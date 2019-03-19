ds <- read.csv("~/Rscripts/MH4501_data_fish.csv")

#Q1 (a)
xbar <- colMeans(ds)[3:6]

ds.group <- split(ds[,3:6], ds$method)

ds.means <- sapply(ds.group, function(x) {
  apply(x, 2, mean)
}, simplify = 'data.frame')

# B
B <- 12*(ds.means[,1]-xbar)%*%t(ds.means[,1]-xbar) + 12*(ds.means[,2]-xbar)%*%t(ds.means[,2]-xbar) + 12*(ds.means[,3]-xbar)%*%t(ds.means[,3]-xbar)
# H
#H = matrix(data = 0, nrow = 4, ncol = 4)
#for (i in 1:dim(H)[1]) {
#  for (j in 1:i) {
#    H[i,j] <- 12 * sum((ds.means[i,] - xbar[i]) * (ds.means[j,] - xbar[j]))
#    H[j,i] <- 12 * sum((ds.means[j,] - xbar[j]) * (ds.means[i,] - xbar[i]))
#  }
#}



# W
W <- matrix(0,4,4)
for(g in 1:3){
  for(i in 1:12){
    xi <- as.matrix(ds[ds$method == g,][i,][3:6])
    W <- W + t(xi-ds.means[,g]) %*% (xi-ds.means[,g])
  }
}
# E
#E = matrix(data = 0, nrow = 4, ncol = 4)
#for (i in 1:dim(E)[1]) {
#  for (j in 1:i) {
#    b <- c() 
#    for (k in ds.group) {
#      a <- sum((k[,i] - mean(k[,i])) * (k[,j] - mean(k[,j])))
#      b <- append(b, a)
#    }
#    E[i,j] <- sum(b)
#    E[j,i] <- sum(b)
#  }
#}


#Q1 (b)
ds.manova <- manova(as.matrix(ds[,3:6]) ~ as.factor(ds$method))
ds.summary <- summary(ds.manova)
ds.summary

ds.summary$SS[1]
B
ds.summary$SS[2]
W

det(W)
det(B+W)
det(W)/det(B+W)
summary(ds.manova, 'Wilks')$stats[,2][1]

-32.5*log(det(W)/det(B+W))
qchisq(.95, df=4)

#Q2
standard.df <- scale(ds[,3:6])
pca <- prcomp(standard.df, scale=T)

sample.cov <- (t(standard.df)%*%standard.df)/35
sample.cov
cov(standard.df,standard.df)
ev <- eigen(sample.cov)

# check
pca
(ev$values)^(1/2)
ev$vectors

100*ev$values[1]/sum(ev$values)
100*ev$values[2]/sum(ev$values)
100*ev$values[3]/sum(ev$values)
100*ev$values[4]/sum(ev$values)

#Q3
X <- ds[3:6]
pc1 <- c(t(ev$vectors[,1])%*%t(X))
pc2 <- c(t(ev$vectors[,2])%*%t(X))

clusters <- hclust(dist(cbind(pc1,pc2),method = "euclidean"))
plot(clusters, cex=0.6)
rect.hclust(clusters, k=3, border=2:4)
clusterCut <- cutree(clusters, 3)
table(clusterCut, ds$method)

