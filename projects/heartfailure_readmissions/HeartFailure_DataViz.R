#
#
# Author: Gustavo Oliveira
#
#


library(plyr)
#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 
fname<-file.choose()
HeartFailure.data <- data.frame(read.csv(fname, stringsAsFactors= FALSE))
colnames(HeartFailure.data)
par(mfrow = c(2,1), mar=c(2.5,6,1.5,6))

hist1 <- hist(HeartFailure.data$Age[HeartFailure.data$Readmission..Any. == 'Yes'], breaks = 50, main = 'Age', xlab = 'age', col = rev(coul))
hist2 <- hist(HeartFailure.data$LOS[HeartFailure.data$Readmission..Any. == 'Yes'], breaks = 50, main = 'Length of Stay', xlab = 'Length of Stay', col = rev(coul))
#boxplot(HeartFailure.data$Age[HeartFailure.data$Readmission..Any. == 'Yes'],  col = coul)
#boxplot(HeartFailure.data$Age[HeartFailure.data$Readmission..Any. == 'Yes'], horizontal = TRUE)
summary(HeartFailure.data$Age[HeartFailure.data$Readmission..Any. == 'Yes'])
summary(HeartFailure.data$LOS[HeartFailure.data$Readmission..Any. == 'Yes'])


#bar graphs by diagnosis



data.DRG <- count(HeartFailure.data, "Enc...Primary.ICD10.Diagnosis.Desc.Simp")
data.DRGYes <- count(HeartFailure.data$Enc...Primary.ICD10.Diagnosis.Desc.Simp[HeartFailure.data$Readmission..Any. == 'Yes'])
data.DRG$yes <- data.DRGYes$freq[match(data.DRG$Enc...Primary.ICD10.Diagnosis.Desc.Simp,data.DRGYes$x)]
data.DRG$percent <- (data.DRG$yes/data.DRG$freq)*100
table.order <- data.DRG[data.DRG$freq > 100,]
table.order2 <- table.order[order(-table.order$percent),]
column.names <- table.order2$Enc...Primary.ICD10.Diagnosis.Desc.Simp


#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mfrow = c(1,1), mar=c(10,7,3,3))
a=barplot(table.order2$percent, main = 'Percentage of readmissions by Diagnosis', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order1$percent, main = 'Percentage of readmission by DRG', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2[order(-table.order2$yes),]$yes, main = 'Readmissions by Diagnosis', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order2$percent)
#barplot(table.order2[order(-table.order1$yes),]$yes)
#Table.DRG <- table(guns.data$Readmission..Any.,guns.data$MS.DRG.Desc)


#bar graphs by service line

data.ServiceLine <- count(HeartFailure.data, "Service.Line")
data.ServiceLineYes <- count(HeartFailure.data$Service.Line[HeartFailure.data$Readmission..Any. == 'Yes'])
data.ServiceLine$yes <- data.ServiceLineYes$freq[match(data.ServiceLine$Service.Line,data.ServiceLineYes$x)]
data.ServiceLine$percent <- (data.ServiceLine$yes/data.ServiceLine$freq)*100
table.order <- data.ServiceLine[data.ServiceLine$freq > 100,]
table.order2 <- table.order[order(-table.order$percent),]
column.names <- table.order2$Service.Line


#create color palette:
library(RColorBrewer)
coul = brewer.pal(7, "Reds") 

# plot
par(mfrow = c(1,1), mar=c(2.5,6,1.5,6))
a=barplot(table.order2$percent, main = 'Percentage of readmissions by Service Line', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order1$percent, main = 'Percentage of readmission by DRG', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(7, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2[order(-table.order2$yes),]$yes, main = 'Readmissions by Service Line', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order1$percent)
#barplot(table.order1[order(-table.order1$yes),]$yes)
#tableSL.order <- data.ServiceLine[order(-data.ServiceLine$freq),]


#bar graphs by Facility.Desc

data.ServiceLine <- count(HeartFailure.data, "Facility.Desc")
data.ServiceLineYes <- count(HeartFailure.data$Facility.Desc[HeartFailure.data$Readmission..Any. == 'Yes'])
data.ServiceLine$yes <- data.ServiceLineYes$freq[match(data.ServiceLine$Facility.Desc,data.ServiceLineYes$x)]
data.ServiceLine$percent <- (data.ServiceLine$yes/data.ServiceLine$freq)*100
table.order <- data.ServiceLine[data.ServiceLine$freq > 100,]
table.order2 <- table.order[order(-table.order$percent),]
column.names <- table.order2$Facility.Desc


#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2$percent, main = 'Percentage of readmissions by Facility', names.arg = "", col = rev(coul), bty = 'n')
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order1$percent, main = 'Percentage of readmission by Facility', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 





#
#
#    TREEMAP
#
#
#

#Treemap for number of occurences by facility and Diagnosis



library(treemap)
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, c("Facility.Desc","Enc...Primary.ICD10.Diagnosis.Desc"))
#aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 10,]
treemap(aggregateFacDia, 
        index=c("Facility.Desc","Enc...Primary.ICD10.Diagnosis.Desc"), 
        vSize="freq",
        vColor="freq",
        type = "dens",
        palette = "Reds",
        title = "Readmission by Facility and Diagnosis",
        title.legend = "Number of Readmissions",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
        )

#treemap for facility
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, "Facility.Desc")
aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 20,]
treemap(aggregateFacDia, 
        index="Facility.Desc", 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title.legend = "Number of Readmissions",
        title = "Readmission by Facility > 20 occurences",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)

#treemap for diagnosis cleveland
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata[newdata$Facility.Desc == "Cleveland ",], "Enc...Primary.ICD10.Diagnosis.Desc.Simp")
aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 20,]
treemap(aggregateFacDia, 
        index="Enc...Primary.ICD10.Diagnosis.Desc.Simp", 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title.legend = "Number of Readmissions",
        title = "Readmission by Diagnosis > 20 occurences",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)

#treemap for diagnosis 
par(mar=c(2,2,2,2))
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, "Enc...Primary.ICD10.Diagnosis.Desc")
aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 20,]
treemap(aggregateFacDia, 
        index="Enc...Primary.ICD10.Diagnosis.Desc", 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title.legend = "Number of Readmissions",
        title = "Readmission by Diagnosis > 20 occurences",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)


#insurance
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, "Payor.Type")
#aggregateFacDia <- aggregateFacDia[-1,]

par(mfrow=c(1,1))
pie(aggregateFacDia$freq, labels = aggregateFacDia$Payor.Type, main = 'Readmissions by Payor', col = rev(coul))

treemap(aggregateFacDia, 
        index="Payor.Type", 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title.legend = "Number of Readmissions",
        title = "Readmission by Payor Type",
        fontsize.title = 20,
        mirror.y = TRUE,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)

#Treemap for number of occurences by facility and payor



library(treemap)
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, c("Facility.Desc","Payor.Type"))
aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 10,]
treemap(aggregateFacDia, 
        index=c("Facility.Desc","Payor.Type"), 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title = "Readmission by Facility and Payor Type",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)


#Treemap for number of occurences by facility and age
newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
aggregateFacDia <- count(newdata, c("Facility.Desc","Age"))
aggregateFacDia <- aggregateFacDia[-1,]
aggregateFacDia <- aggregateFacDia[aggregateFacDia$freq > 10,]
treemap(aggregateFacDia, 
        index=c("Facility.Desc","Age"), 
        vSize="freq",
        vColor="freq",
        palette = "Reds",
        type = "dens",
        title = "Readmission by Facility and Payor Type",
        fontsize.title = 20,
        align.labels = list(c("left", "top"), c("right", "bottom")),
        drop.unused.levels = TRUE,
        overlap.labels =0,
        bg.labels	= 0
)

#histogram by age and facility
par(mfrow = c(2,2), mar=c(2,2,2,2))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
histCleveland <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Cleveland "], breaks = 50, main = 'Cleveland', xlab = 'age', col = rev(coul))
histParma <- hist(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Parma "], breaks = 50, main = 'Parma', xlab = 'age', col = rev(coul))
histElyria <- hist(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Elyria "], breaks = 50, main = 'Elyria', xlab = 'age', col = rev(coul))
histElyria <- hist(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Geauga "], breaks = 50, main = 'Geauga', xlab = 'age', col = rev(coul))

par(mfrow = c(2,2), mar=c(2,2,2,2))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
histCleveland <- hist(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Cleveland "], breaks = 50, main = 'Cleveland', xlab = 'age', col = rev(coul))
histParma <- hist(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Parma "], breaks = 20, main = 'Parma', xlab = 'age', col = rev(coul))
histElyria <- hist(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Elyria "], breaks = 30, main = 'Elyria', xlab = 'age', col = rev(coul))
histElyria <- hist(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Geauga "], breaks = 20, main = 'Geauga', xlab = 'age', col = rev(coul))

#boxplots by city
par(mfrow = c(2,3), mar=c(2,2,2,2))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
histCleveland <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Cleveland "], breaks = 50, main = 'Cleveland', xlab = 'age', col = rev(coul))
histParma <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Parma "], breaks = 50, main = 'Parma', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Elyria "], breaks = 50, main = 'Elyria', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Geauga "], breaks = 50, main = 'Geauga', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Portage "], breaks = 50, main = 'Portage', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$Age[Data.readmitted$Facility.Desc == "Richmond "], breaks = 50, main = 'Richmond', xlab = 'age', col = rev(coul))

par(mfrow = c(2,2), mar=c(2,2,2,2))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
histCleveland <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Cleveland "], breaks = 50, main = 'Cleveland', xlab = 'age', col = rev(coul))
histParma <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Parma "], breaks = 20, main = 'Parma', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Elyria "], breaks = 30, main = 'Elyria', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Geauga "], breaks = 20, main = 'Geauga', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Portage "], breaks = 20, main = 'Portage', xlab = 'age', col = rev(coul))
histElyria <- boxplot(Data.readmitted$LOS[Data.readmitted$Facility.Desc == "Richmond "], breaks = 20, main = 'Richmond', xlab = 'age', col = rev(coul))


#Pie plots

library(plotrix)
par(mfrow = c(3,2), mar=c(2,2,2,2))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Cleveland ",], "Payor.Type")

piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Cleveland', col = rev(coul))
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Parma ",], "Payor.Type")
piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Parma', col = rev(coul))
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Elyria ",], "Payor.Type")
piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Elyria', col = rev(coul))
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Geauga ",], "Payor.Type")
piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Geauga', col = rev(coul))
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Portage ",], "Payor.Type")
piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Portage', col = rev(coul))
par(mfrow = c(1,1), mar=c(2,2,2,5))
aggregateFacDia <- count(Data.readmitted[Data.readmitted$Facility.Desc == "Richmond ",], "Payor.Type")

piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Richmond', col = rev(coul))
pie(aggregateFacDia$freq, labels = aggregateFacDia$Payor.Type, main = 'Richmond', col = rev(coul))

Data.readmitted <- HeartFailure.data[HeartFailure.data$Readmission..Any. == 'Yes',]
aggregateFacDia <- count(Data.readmitted, "Payor.Type")

piepercent<- round(100*aggregateFacDia$freq/sum(aggregateFacDia$freq), 1)
pie(aggregateFacDia$freq, labels = piepercent, main = 'Total', col = rev(coul))




#
#
#
#   Wordcloud
#
#

library(plotrix)
library(wordcloud)

all.tags <- HeartFailure.data$Enc...Primary.ICD10.Diagnosis.Desc.Simp
tag.tab <- table(all.tags)
tag.words <- names(tag.tab)
tag.freq <- as.numeric(tag.tab)
length(tag.freq)
plot(tag.freq)


wordcloud(tag.words, tag.freq, scale = c(4,.5))

par(mfrow = c(2,2))
plot(tag.freq)
plot(tag.freq^2)
plot(tag.freq^(1/2))
plot(log10(tag.freq))

size <- tag.freq^(1/2)
par(mfrow = c(1,1))
plot(size)
summary(size)

wordcloud(tag.words,size, scale = c(2,.2))

wordcloud(tag.words,size, scale = c(3,.3)
          , min.freq = 4
          , random.order = FALSE
          , rot.per = 0)
warnings()

myPalFun <- colorRampPalette(c("red","gray","white"))

tag.cols.vec <- myPalFun(max(size) + 1)
tag.col <- tag.cols.vec[round(size) + 1]

par(bg = "Black")
wordcloud(tag.words,size, scale = c(2,.2)
          , min.freq = 3
          , random.order = FALSE
          , rot.per = 0
          , random.color = FALSE
          , colors = tag.col
          , ordered.colors = TRUE)

#Tried wordcloud2 in to create a wordcloud in an image

library(wordcloud2)
freq <- as.data.frame(tag.words)
freq$tag.freq <- tag.freq
figPath = system.file("C:\\Users\\goliveir\\Heart.png",package = "wordcloud2")
wordcloud2(freq,figPath = "C:\\Users\\goliveir\\Heart.png", size = 0.5, color = "Reds")
letterCloud(freq, word ="H", wordSize = 1)


#
#
#     tentative REGRESSIONS to analyze relevance of variables - not used
#
#
#
#
#


#Naive Bayes regression
library(e1071)

fname<-file.choose()
HeartFailure.data <- data.frame(read.csv(fname, stringsAsFactors= TRUE))
colnames(HeartFailure.data)
HeartFailure.data <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "1",]

HeartFailure.data$Age = cut(HeartFailure.data$Age, breaks = 3)
HeartFailure.data$LOS = cut(HeartFailure.data$LOS, breaks = 3)
summary(HeartFailure.data$Age)
summary(HeartFailure.data$LOS)
sample <- sample.int(n = nrow(HeartFailure.data), size = floor(.75*nrow(HeartFailure.data)), replace = F)
train <- HeartFailure.data[sample, ]
test  <- HeartFailure.data[-sample, ]

model <- naiveBayes(Readmission..Any. ~ Medicare, train)
summary(model)
model$tables
model$tables$Payor.Type
model$tables$Enc...Primary.ICD10.Diagnosis.Desc.Simp
model$tables$Facility.Desc
model$tables$LOS
model$tables$Age

pred <- predict(model, test)
table(pred,test$Readmission..Any.)

newdata <- HeartFailure.data[HeartFailure.data$Readmission..Any. == "Yes",]
model <- glm(Readmission..Any. ~ ., train, family = binomial)
summary(model)

prediction <- predict(model, type = 'response')
#warnings()
table(prediction>0.5,test$Readmission..Any.)

#naive bayes using caret
install.packages("caret")
library(caret)

x <- HeartFailure.data[,-1]
y <- HeartFailure.data$Readmission..Any.

model <- train(x,y,'nb', trControl = trainControl(method='cv', number = 10))

model$results

#Linear Regression

fname<-file.choose()
HeartFailure.data <- data.frame(read.csv(fname, stringsAsFactors= TRUE))
colnames(HeartFailure.data)

sample <- sample.int(n = nrow(HeartFailure.data), size = floor(.75*nrow(HeartFailure.data)), replace = F)
train <- HeartFailure.data[sample, ]
test  <- HeartFailure.data[-sample, ]

model <- lm(Readmission..Any. ~ ., train)
model$coefficients
model$rank

pred <- predict(model, test)
warnings()
table(pred,test$Readmission..Any.)
