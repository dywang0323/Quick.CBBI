# PCA
#finds the best linear combinations of the variables
#"best" means the variable that describes the largest variables
#can produce lower-dimentional summaries of the data
  # take 100 numbers per sample and summarize them with 2 numbers per sample
#useful for visualization, among other things

library(ava)
library(limma)
library(bladderbatch)
library(leukemiasEset)
library(dplyr)
library(biobroom)
library(ggplot2)
library(factoextra)
library(purrr)
setwd(".")

data(decathlon2)
decathlon2.active <- decathlon2(1:23, 1:10)
head(decathlon2.active[, 1:6])

res.pca <- prcomp(decathlon2.active, scale = TRUE)
pca.var.per = round(res.pca$sdev^2/sum(res.pca$sdev^2)*100,1)
fviz_eig(res.pca, addlabels=TRUE), ylim=c(0,100), geom = c("bar", "line"), barfill = "gold", barcolor="grey", linecolor="red", ncp=10 +
labs(title = "PCA Coverage", 
         x = "Principle Component", y = "% of variances")

ggplot_data <- data.frame(sample = rownames(res.pca$x), X = res.pca$x[,1], Y = res.pca$x[,2])
run<-c()
run[decathlon2.active$x100m<11]<-"slow"
run[decathlon2.active$x100m>=11]<-"fast"
names(run)<-rownames(decathlon2.active)
ggplot(data = ggplot_data, aes(x=X, y=Y, label = Sample, color=run))+
  geom_point
  xlab(paste("PC1-", pca.var.per[1], "%", sep=" "))+
  ylab(paste("PC2-", pca.var.per[2], "%", sep=" "))+
  theme_bw()+
  ggtitle("PCA graph of the first two component")
