# Amy Solman amy.solman19@imperial.ac.uk
# 24th October 2019
# Lecture 9

##########LECTURE FOUR##########

#Standard errors

# H0 = True mean is equal to mean of 2001
# H1 = True mean is not equal to mean of 2001

rm(list=ls())

setwd("/Users/amysolman/Documents/SparrowStats/HandOutsandData'18")
d <- read.table("SparrowSize.txt", header = TRUE)
str(d)

names(d)
head(d)

#SE of Tarsus total sample population
d1<- subset(d, d$Tarsus!="NA")
seTarsus<-sqrt(var(d1$Tarsus)/length(d1$Tarsus))
seTarsus

#SE of Tarsus 2001 only
#Larger sample size means smaller standard error and greater certainty
d12001<-subset(d1, d1$Year==2001)
seTarsus2001<-sqrt(var(d12001$Tarsus)/length(d12001$Tarsus))
seTarsus2001

#SE of wing total sampel population
d2<- subset(d, d$Wing!="NA")
seWing<-sqrt(var(d2$Wing)/length(d2$Wing))
seWing

#SE of wing 2001 only
d22001<-subset(d2, d2$Year==2001)
seWing2001<-sqrt(var(d22001$Wing)/length(d22001$Wing))
seWing2001

#SE of bill total sampel population
d3<- subset(d, d$Bill!="NA")
seBill<-sqrt(var(d3$Bill)/length(d3$Bill))
seBill

#SE of bill 2001 only
d32001<-subset(d3, d3$Year==2001)
seBill2001<-sqrt(var(d32001$Bill)/length(d32001$Bill))
seBill2001

#SE of mass total sampel population
d4<- subset(d, d$Mass!="NA")
seMass<-sqrt(var(d4$Mass)/length(d4$Mass))
seMass

#SE of mass 2001 only
d32001<-subset(d3, d3$Year==2001)
seBill2001<-sqrt(var(d32001$Bill)/length(d32001$Bill))
seBill2001

d42001<-subset(d4, d4$Year==2001)
seMass2001<-sqrt(var(d42001$Mass)/length(d42001$Mass))
seMass2001

TarsusSE <- data.frame(seTarsus, seTarsus2001)
TarsusSE

names(TarsusSE) <- c("Total", "2001")
TarsusSE

WingSE <- data.frame(seWing, seWing2001)
WingSE

names(WingSE) <- c("Total", "2001")
WingSE

BillSE <- data.frame(seBill, seBill2001)
BillSE

names(BillSE) <- c("Total", "2001")
BillSE

MassSE <- data.frame(seMass, seMass2001)
MassSE

names(MassSE) <- c("Total", "2001")
MassSE

TarsusSE
WingSE
BillSE
MassSE

Result <- rbind(TarsusSE, WingSE, BillSE, MassSE, row.names = TRUE)
Result

t.test(d1$Tarsus, mu=18.5, na.rm=TRUE)
