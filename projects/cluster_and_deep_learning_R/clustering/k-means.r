set.seed(1013)


library(dplyr)
library(cluster)
library(Rtsne)
library(ggplot2)
library(gdata)
library(xlsx)


Data2 <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/INTRA CLUSTER DATA.xlsx", row.names=NULL,stringsAsFactors= FALSE))


glimpse(Data2)

Data2$PORTPAIR <- as.factor(Data2$PORTPAIR)
Data2$Key.Commodity<- as.factor(Data2$Key.Commodity)

#Data2$Package <- as.factor(Data2$Package)
#Data2$POD <- as.factor(Data2$POD)
#Data2$POL <- as.factor(Data2$POL)


gower.distance <- daisy(Data2, metric = "gower", weights = c(4,6,8))# type=list(logratio=3))
summary(gower.distance)

gower_mat <- as.matrix(gower.distance)


#outpost most similar clients

Data2[which(gower_mat == min(gower_mat[gower_mat != min(gower_mat)]), arr.ind = TRUE)[1,],]


#outpost most different clients

Data2[which(gower_mat == max(gower_mat[gower_mat != max(gower_mat)]), arr.ind = TRUE)[1,],]


# Calculate silhouette width for many k using PAM

sil_width <- c(NA)

for(i in 2:15){
  
  pam_fit <- pam(gower.distance,
                 diss = TRUE,
                 k = i)
  
  sil_width[i] <- pam_fit$silinfo$avg.width
  
}


# Plot sihouette width (higher is better)

plot(1:15, sil_width,
     xlab = "Number of clusters",
     ylab = "Silhouette Width")
lines(1:15, sil_width)



pam_fit <- pam(gower.distance, diss = TRUE, k = 10)
               
pam_results <- Data2 %>%
  mutate(cluster = pam_fit$clustering) %>%
  group_by(cluster) %>%
  do(the_summary = summary(.))

pam_results$the_summary



Data2[pam_fit$medoids, ]

tsne_obj <- Rtsne(gower.distance, is_distance = TRUE)

tsne_data <- tsne_obj$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(pam_fit$clustering),
         name = Data2$Key.Commodity)

ggplot(aes(x = X, y = Y), data = tsne_data) +
  geom_point(aes(color = cluster))

Data2$Cluster <- tsne_data$cluster
write.csv(Data2, file = "/Users/Oliveiralgm/Downloads/resultINTRA2.csv")
