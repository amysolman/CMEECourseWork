#Amy Solman amy.solman19@imperial.ac.uk
#Monday 5th November
#Genomics and Bioinformatics Day Two

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week6/Data")

#Load the three species genomic data files

WestBand <- read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/western_banded_gecko.csv", 
                 stringsAsFactors=FALSE, colClasses=rep("character", 1000), header=FALSE)
dim(WestBand)
BentToed <- read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/bent-toed_gecko.csv", 
                              stringsAsFactors=FALSE, colClasses=rep("character", 1000), header=FALSE)
dim(BentToed)
Leopard <- read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/leopard_gecko.csv", 
                     stringsAsFactors=FALSE, colClasses=rep("character", 1000), header=FALSE)
dim(Leopard)

#Firstly, calculate the genetic divergency of each pair of species to assign
#leaves to the proposed topology (which pair is most divered so we know which species
#diverged first)

#How genetically similar are WestBand and BentToed
#For each column of WestBand how similar is it to the same band in Bent Toed?

#start by creating two empty vectors, one for total data values (sits) and one for 
#total different data values (sites divergent). So, we can divide the number of divergent values by
#the number of total values

sites_total <- 0 #set the number of total sites (columns) to 0
sites_divergent <-  0 #set the numnber of divergent sites (columns) to 0

#We need to remove the SNPs within each species - what does this mean?
#SNPs are single nucleotide polymorphisms or 'snips'. These are where alleles in 
#diploid individuals are not the same, so instead of CC, AA, TT, having a pair of matching
#nucleotides, they have polymorphic nucleotides CA or TG etc. These are NOT fixed 
#within the population, they are individual mutations that will not help us
#understand how similar whole species are. We want to look exclusively at the genetic
#information that it fixed within each species to draw a useful comparison.
#So let's remove the columns of data that do not have matching alleles for that
#individual.


for (i in 1:ncol(WestBand)) { #for each column of values (alleles) in WestBand
  if 
  (length(unique(WestBand[,i]))==1 & #if the number (length) of unique values in the column of the first species equals 1 and
    length(unique(BentToed[,i]))==1) {#the number (length) of unique values in the column of the second species equals 1
sites_total <- sites_total + 1 # adds up the number of non-SNP sites for both species

#if different, then it's a divergent site
 if 
(WestBand[1,i] != BentToed[1,i]) # if the first row and any columns of species one and different from species two
   sites_divergent <- sites_divergent + 1 # adds up the number of sites that are different between the two species
}
}
#So if we have the locations of the non-SNP data for both species, and the places that they are different
#we can calculate the divergence rate

divergence_rate_WB_BT <- sites_divergent / sites_total
print(divergence_rate_WB_BT) #0.0037

#Now we'll repeat this for each pair - WestBand and Leopard

sites_total <- 0
sites_divergent <- 0

for (i in 1:ncol(WestBand)) {
  if
  (length(unique(WestBand[,i]))==1 &
   length(unique(Leopard[,i]))==1) {
    sites_total <- sites_total + 1 
      
  if
  (WestBand[1,i] != Leopard[1,i])
    sites_divergent <- sites_divergent + 1
    }
}

divergence_rate_WB_L <- sites_divergent / sites_total
print(divergence_rate_WB_L) # 0.0088

#Now repeat for BentToed and Leopard

sites_total <- 0
sites_divergent <- 0

for (i in 1:ncol(BentToed)) {
  if
  (length(unique(BentToed[,i]))==1 &
   length(unique(Leopard[,i]))==1) {
    sites_total <- sites_total + 1
    
    if (BentToed[1,i] != Leopard[1,i])
    sites_divergent <- sites_divergent + 1
  }
}

divergence_rate_BT_L <- sites_divergent / sites_total
print(divergence_rate_BT_L) # 0.0091

#We conclude that WestBanded and BentToed are most closely related, with Leopard as an outlier. 
#Leopard is most closely related to the WestBanded to we infer that the Leopard diverged fromt he WestBanded
#at 30mya, then BentToed diverged from WestBanded 15mya.

#estimate mutation rate per site (column) per year (30mya)
#mutation rate is the divergence rate of two species,
#divided by 2 x number of years since divergence

mutation_rate_WB_L_per_my <- divergence_rate_WB_L/(2*30)
print(mutation_rate_WB_L)

mutation_rate_BT_L_per_my <- divergence_rate_BT_L/(2*30)
print(mutation_rate_BT_L_per_my)

mean_mutation_rate <- (mutation_rate_WB_L_per_my+mutation_rate_BT_L_per_my) /2
print(mean_mutation_rate)

#now estimate divergence time = 
# genetic difference of two species / 2 times mutation rate

EDT_WB_L <- divergence_rate_WB_L/(2*mutation_rate_WB_L_per_my)
print(EDT_WB_L)

EDT_WB_BT <- divergence_rate_WB_BT/(2*mean_mutation_rate)
print(EDT_WB_BT) #we can estimate the divergence time for these
#species by using a mean mutation rate

EDT_BT_L <- divergence_rate_WB_L/(2*mutation_rate_BT_L_per_my)
print(EDT_BT_L)

cat("\nThe most likely species tree is L:(W:B).")








