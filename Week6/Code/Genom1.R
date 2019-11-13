#Amy Solman amy.solman19@imperial.ac.uk
#Monday 4th November
#Genomics and Bioinformatics Day One


rm(list=ls())

data <- read.csv("/Users/amysolman/Documents/CMEECourseWork/Week6/Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/bears.csv", stringsAsFactors=FALSE, colClasses=rep("character", 1000), header=FALSE)

dim(data)

# install.packages("adegenet")
# install.packages("hierfstat")
# install.packages("pegas")
# library(adegenet)
# library(hierfstat)
# library(pegas)
# 
# locus <- data[, -c(1, 2, 3, 4, 17:3086)]    
# colnames(locus) <- gsub("\\.", "_", colnames(locus)) # locus names can't have "."
# ind <- as.character(Mydata$tree_id) # labels of the individuals
# population <- as.character(Mydata$state) # labels of the populations
# Mydata1 <- df2genind(locus, ploidy = 2, ind.names = ind, pop = population, sep = "")
# Mydata1

# Write a script in R that complete all the following tasks:
#   
#identify which positions are SNPs (polymorphic, meaning that they have more than one allele)

#This stores the indexes of the polymorphic alleles
snps <- c() #create empty vector
for (i in 1:ncol(data)) {
  if 
  (length(unique(data[,i]))==2)
    snps <- c(snps, i)
}

cat("\nNumber of SNPs is:", length(snps)) 

#reduce the data set to polymorphic alleles only
data <- data[,snps]
dim(data)

#calculate, print and visualise allele frequencies for each SNP

# install.packages("tidyverse")
# 
# library(tidyverse) 
# 
# data %>% 
#   as.tibble() %>% 
#   count(data[,1])

allele_frq <- c() #create empty vector
for (i in 1:ncol(data)) { #for each column in the data
  alleles <- sort(unique(data[,i])) # alleles = ordered uniqe data values in column

 cat("\nSNP", i, "with alleles", alleles)

 freq <- length(which(data[,i]==alleles[1])) / nrow(data)
 cat(" and allele frequency of the first allele", freq)
 
 allele_frq <- c(allele_frq, freq)
}

myData <- data.frame(first_allele=alleles, frequency_first_allele=allele_frq, frequency_second_allele=1-allele_frq)
print(myData)

hist(allele_frq)


#calculate and print genotype frequencies for each SNP
#How may times does each two rows have the same alleles 
#For each column, if the two rows match in a row = homozygote

nsamples <- 20 #we have 20 samples
for (i in 1:ncol(data)) { #for each column in our data
  
  ### alleles in this SNPs
  alleles <- sort(unique(data[,i])) #store our unique values in this list
  cat("\nSNP", i, "with alleles", alleles)
  
  ### as before, I can choose one allele as "reference"
  ### genotypes are Allele1/Allele1 Allele1/Allele2 Allele2/Allele2
  genotype_counts <- c(0, 0, 0) #make data frame to take three columns of data
  
  for (j in 1:nsamples) {
    ### indexes of genotypes for individual j
    genotype_index <- c( (j*2)-1, (j*2) ) #
    ### count the Allele2 instances
    genotype <- length(which(data[genotype_index, i]==alleles[2])) + 1
    ### increase the counter for the corresponding genotype 
    genotype_counts[genotype] <- genotype_counts[genotype] + 1
  }
  cat(" and genotype frequencies", genotype_counts)
}

#calculate (observed) homozygosity and heterozygosity for each SNP

nsamples <- 20
for (i in 1:ncol(data)) {
  
  ### alleles in this SNPs
  alleles <- sort(unique(data[,i]))
  cat("\nSNP", i, "with alleles", alleles)
  
  ### as before, I can choose one allele as "reference"
  ### genotypes are Allele1/Allele1 Allele1/Allele2 Allele2/Allele2
  genotype_counts <- c(0, 0, 0)
  
  for (j in 1:nsamples) {
    ### indexes of genotypes for individual j
    genotype_index <- c( (j*2)-1, (j*2) )
    ### count the Allele2 instances
    genotype <- length(which(data[genotype_index, i]==alleles[2])) + 1
    ### increase the counter for the corresponding genotype
    genotype_counts[genotype] <- genotype_counts[genotype] + 1
  }
  cat(" and heterozygosity", genotype_counts[2]/nsamples, "and homozygosity", 1-genotype_counts[2]/nsamples)
}

#calculate expected genotype counts for each SNP and test for HWE
# 

nonHWE <- c() #to store indexes (locations) of SNPs deviating from HWE
nsamples <- 20
for (i in 1:ncol(data)) {
  #alleles in this SNPs 
  alleles <- sort(unique(data[,1]))
  cat("\nSJNP", i)
  #as before I can choose on allele as "reference"
  #frequency (of the second allele)
  freq <- length(which(data[,i]==alleles[2]))/nrow(data)
  #from the frequency, I can calculate the expected genotype counts under HWE
  genotype_counts_expected <- c( (1-feq)^2, 2*freq*(1-freq), freq^2) * nsamples
  #genotypes are Allele1/Allele1, Allele1/Allele2, Allele2/Allele2
  genotype_counts <- c(0, 0 , 0)
  for (j in 1:nsamples) {
    #indexes of genotypes for individual j
    genotype_index <- c((j*2)-1, (j*2))
    #count the allele2 instances
    genotype_counts[genotype] + 1
  }
  #test for HWE: calculate chi^2 statistic
  chi <- sum((genotype_counts_expected - genotype_counts)^2 / genotype_counts_expected)
  #pvalue
  pv <- 1 - pchisq(chi, df=1)
  cat("with pvalue for test against HWE, pv")
  #retain SNPS with pvalue <0.05
  if (pv <-0.05) nonHWE <- c(nonHWE, i)
  
}

#calculate, print and visualise inbreeding coefficient for each SNP deviating from HWE

#assuming we ran the code for point 5, we already have the SNPs deviating 
F <- c()
nsamples <- 20
for (i in nonHWE) {
  #alleles in this SNPs
  alleles <- sort(unique(data[,i]))
  cat("\nSNP", i)
#as before, I can choose one allele as "reference"
#frequency of the second allele
  frq <- length(which(data[,i]==alleles[2]))/
    nrow(data)
  #from the frequency, I can calculate the expected genotype counts under HWE
  genotype_counts_expected <- c((1-freq)^2, 2*freq*(1-freq), freq^2) * nsamples
  #genotypes are Allele1/Allele1, Allele1/Allele2, Allele2/Allele2
  genotype_counts <- c(0, 0, 0)
  for (j in 1:nsmaples) {
    #indexes of genotypes for individual j
  genotype_index <- c((j*2)-1, (j*2))
  #count the Allele2 instances
  genotype <- length(which(data[genotype_index, i]==alleles[2])) + 1
  #increase the counter for the corresponding genotype
  genotype_counts[genotype] <- genotype_counts[genotype] + 1
  }
  #calculate inbreeding coefficient
  inbreeding <- (2*freq*(1-freq)-(genotype_counts[2]/nsamples)) / (2*freq*(1-freq))
  F <- c(F, inbreeding)
  cat(" with inbreeding coefficient", inbreeding)
  
}

#plot
hist(F)
plot(F, type="h")