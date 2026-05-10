
### EDA ###

library(plyr)
#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 
HeartFailure.data <- data.frame(read.csv("/Users/user_name/Downloads/MedicalData.csv", stringsAsFactors= FALSE))
colnames(HeartFailure.data)
hist(HeartFailure.data$Age[HeartFailure.data$Readmission..Any. == 'Yes'], breaks = 50, main = 'Age of readmissions', xlab = 'age', col = rev(coul))
hist(HeartFailure.data$LOS[HeartFailure.data$Readmission..Any. == 'Yes'], breaks = 50, main = 'Length of Stay of readmitted patients', xlab = 'Length of Stay', col = rev(coul))


data.DRG <- count(HeartFailure.data, "MS.DRG.Desc")
data.DRGYes <- count(HeartFailure.data$MS.DRG.Desc[HeartFailure.data$Readmission..Any. == 'Yes'])
data.DRG$yes <- data.DRGYes$freq[match(data.DRG$MS.DRG.Desc,data.DRGYes$x)]
data.DRG$percent <- (data.DRG$yes/data.DRG$freq)*100
table.order <- data.DRG[data.DRG$freq > 100,]
table.order1 <- table.order[order(-table.order$percent),]
column.names <- table.order1$MS.DRG.Desc

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order1$percent, main = 'Percentage of readmissions by DRG', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=0.45)
#barplot(table.order1$percent, main = 'Percentage of readmission by DRG', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order1[order(-table.order1$yes),]$yes, main = 'Readmissions by DRG', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=0.45)
#barplot(table.order1[order(-table.order1$yes),]$yes)


data.DRG <- count(HeartFailure.data, "Enc...Primary.ICD10.Diagnosis.Desc")
data.DRGYes <- count(HeartFailure.data$Enc...Primary.ICD10.Diagnosis.Desc[HeartFailure.data$Readmission..Any. == 'Yes'])
data.DRG$yes <- data.DRGYes$freq[match(data.DRG$Enc...Primary.ICD10.Diagnosis.Desc,data.DRGYes$x)]
data.DRG$percent <- (data.DRG$yes/data.DRG$freq)*100
table.order <- data.DRG[data.DRG$freq > 100,]
table.order2 <- table.order[order(-table.order$percent),]
column.names <- table.order2$Enc...Primary.ICD10.Diagnosis.Desc


#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2$percent, main = 'Percentage of readmissions by Diagnosis', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=0.45)
#barplot(table.order1$percent, main = 'Percentage of readmission by DRG', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2[order(-table.order2$yes),]$yes, main = 'Readmissions by Diagnosis', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=0.45)
#barplot(table.order2$percent)
#barplot(table.order2[order(-table.order1$yes),]$yes)
#Table.DRG <- table(guns.data$Readmission..Any.,guns.data$MS.DRG.Desc)


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
par(mar=c(10,7,3,3))
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
a=barplot(table.order2$percent, main = 'Percentage of readmissions by Facility', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
#barplot(table.order1$percent, main = 'Percentage of readmission by Facility', names.arg = column.names)

#create color palette:
library(RColorBrewer)
coul = brewer.pal(9, "Reds") 

# plot
par(mar=c(10,7,3,3))
a=barplot(table.order2[order(-table.order2$yes),]$yes, main = 'Readmissions by Facility', names.arg = "", col = rev(coul))
text(a[,1], -3.7, srt = 45, adj= 1, xpd = TRUE, labels = column.names , cex=1)
par(mar=c(1,1,4,1))
pie(na.omit(table.order2[order(-table.order2$yes),]$yes), main = 'Readmissions by Facility'
    , col = rev(coul))#, labels = column.names)
#barplot(table.order1$percent)
#barplot(table.order1[order(-table.order1$yes),]$yes)
#tableF.order <- data.Facility[order(-data.Facility$freq),]




data.some_city <- HeartFailure.data[HeartFailure.data$Facility.Desc == "some_city ",]
data.ServiceLine <- count(data.some_city, "Service.Line")
data.ServiceLineYes <- count(data.some_city$Service.Line[data.cleveland$Readmission..Any. == 'Yes'])
data.ServiceLine$yes <- data.ServiceLineYes$freq[match(data.ServiceLine$Service.Line,data.ServiceLineYes$x)]
data.ServiceLine$percent <- (data.ServiceLine$yes/data.ServiceLine$freq)*100
table.order <- data.ServiceLine[data.ServiceLine$freq > 100,]
table.order1 <- table.order[order(-table.order$percent),]
barplot(table.order1$percent)
barplot(table.order1[order(-table.order1$yes),]$yes)

data.DRG <- count(data.some_city, "Enc...Primary.ICD10.Diagnosis.Desc")
data.DRGYes <- count(data.some_city$Enc...Primary.ICD10.Diagnosis.Desc[data.some_city$Readmission..Any. == 'Yes'])
data.DRG$yes <- data.DRGYes$freq[match(data.DRG$Enc...Primary.ICD10.Diagnosis.Desc,data.DRGYes$x)]
data.DRG$percent <- (data.DRG$yes/data.DRG$freq)*100
table.order <- data.DRG[data.DRG$freq > 100,]
table.order1 <- table.order[order(-table.order$percent),]
barplot(table.order1$percent)
barplot(table.order1[order(-table.order1$yes),]$yes)
