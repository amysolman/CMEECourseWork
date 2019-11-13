#Amy Solman amy.solman19@imperial.ac.uk
#Monday 7th November
#Genomics and Bioinformatics Day Four

##########COALESCENCE##########
#A retrospective, stochastic model of population genetics that relates
#genetic diversity in a sample to demographic history of the population
#from which it was taken. It is a model of the effect of genetic drfit viewed
#backwards in time on the genealogy of a decedence.
#Coalescene involves tracking the ancestory of a sampel between two generations.
#If two individual gene copies have the same parent in the previous generation,
#we say that the ancestral lineage representing these two individual coalesced.
#It's important to remember that when talking about 'individuals'
#we are talking about a single gene/allele, as if from a haploid species
#So when genes are passed down they do so in one chromosome, with one complete 
#set of genes/alleles - not two (diploid)
#Anyway, the alleles we're looking at have a common ancestor and a coalescent
#event has occured.
#The ancestry of an individual gene copy is represented by a line (or edge).
#The time until two lineages find a most recent common ancestor (MRCA)
#is called coalescence time. How can we find coalescence time?

#COALESCENCE IN A SAMPLE OF TWO GENE COPIES
#As there are 2N potential parents 'chosen' with equal probability,
#the probability of two gene copies having the same parent in the 
#previous generation is 1/(2N).
#The probability that two gene copies did not have the same parent in the 
#previous generation is 1-1/(2N)

#T = time between each coalescence event


#Practical on coalescence theory
#You are interested in the size of two populations of Atlantic 
#killer whales, one migrating towards a Northern geogrpahical 
#location and one towards a Southern location. These two populations
#share a recent common ancestor but their current population size is 
#hypothesised to be different. To test this hypothesis, you collect 10 
#(diploid = 20 chromosone) samples from the Northern population and 10
#from the Southern population. For each sample, you obtained a genomic 
#sequence of 50kbp (50,000 base pairs). The data is stores in .csv files
#names killer_whale_North.csv and killer_whale_South. Each allele is 
#encoded as 0 or 1 for the ancestral and derived state, respectively.

#1) Estimate the effective population size for each population, using
#both the Watterson's and Tajima's estimator of "theta" assuming a 
#mutation rate of 1x10^{-8}. Discuss the difference between values of
#"theta" using different estimators.

rm(list=ls())
setwd("/Users/amysolman/Documents/CMEECourseWork/Week6/Data")

len <- 50000 #The number of basepairs 

#Since the data is encoded as 0 and 1 it is better to store as a matrix
North <- as.matrix(read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/killer_whale_North.csv",
                     stringsAsFactors = F, header = F, colClasses=rep("numeric", len)))
South <- as.matrix(read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/killer_whale_South.csv", 
                     stringsAsFactors=FALSE, header=FALSE, colClasses=rep("numeric", len)))

##########IT WAS NOT NECESSARY TO FIND THE POLYMORPHIC ALLELES BEFORE FINDING EFFECTIVE POPULATIONS SIZE##########
#Firstly, let's save the index's of polymorphic alleles to an empty vector
# snps1 <- c()
# for (i in 1:ncol(North)){
#   if
#   (length(unique(North[,i]))==2)
#     snps1 <- c(snps1, i)
# }
# 
# #reduce the data set to polymorphic alleles only
# North_SNPS <- North[,snps1]
# 
# #And again for our South population...
# snps2 <- c()
# for (i in 1:ncol(South)) {
#   if
#   (length(unique(South[,i]))==2)
#     snps2 <- c(snps2, i)
#   }
# 
# South_SNPS <- South[,snps2]

##########TAJIMA'S ESTIMATOR##########
#Perfect, now let's use Tajima's estimator of "theta" to estimate the effective population size 
#assuming a mutation rate of 1x10^{-8}.
#Firstly, what is "theta"? "Theta" is the expected number of mutations between two individuals 

#For the Northern Whale!
n <- nrow(North) #number of rows = number of chromosomes
pi_N <- 0 #set pairwise difference vector to zero
for (i in 1:(n-1)) { #for each row in row 1 to (row number -1)
  for (j in (i+1):n) { #for each next row going down to the end
    pi_N <- pi_N + #add to the pairwise difference vector
sum(abs(North[i,]-North[j,])) #the sum of the absolute value of one column from another
  }
}

#Finds the average of all the pairwide comparisons
pi_N <- pi_N / ((n*(n-1))/2) #total difference of each pairwise row divided by number of iterations
#number of iterations = number of rows multiplied by number of rows minus 1 divided by 2

#Let's do the same for the Southern Whale!

n <- nrow(South) 
pi_S <- 0 
for (i in 1:(n-1)) {
  for (j in (i+1):n) {
    pi_S <- pi_S +
      sum(abs(South[i,]-South[j]))
  }
}

pi_S <- pi_S /((n*(n-1))/2) 

#So, now we have the average pairwise differences for the Northern and Southern whale pos.
#Let's use these to find estimates of Ne (effective population size)

Ne_N_pi <- pi_N / (4 * 1e-8 * len) #Here we divide the average pairwise differences of the population by the 
#assumed mutation rate multiplied by number of base pairs
Ne_S_pi <- pi_S / (4 * 1e-8 * len)

##########WATTERSON'S ESTIMATOR##########
#Now we'll look at using Watterson's estimator for find the effective
#population sizes for Northern and Southern whales
#Wattersons differs from Tajima's as it requires a count of 
#segregation sites (a.k.a polymorphic allele indexes)

#For this we'll have to calculate the number of polymorphic alleles
#This is the same as we did earlier, just using the apply function
freqs <- apply(X=North, MAR=2, FUN=sum)/nrow(North) #Here we use the apply function
#this returns a vector of values (freqs) obtained by applying a function 
#to our matrix. Here our matrix is North, our MAR(GIN) tells us to look at the 
#columns (rows would be 2). FUN(CTION) tells us to sum the values. 
#So, all in all, this we have created an apply function that sums the values in
#the columns of our North matrix and stores the results in the vector freqs

snps_N <- length(which(freqs>0 & freqs<1)) # we then ask, how many (length)
#of the values in the vector (freqs) is it true the value is greater than 0 and less than 1
#The number of snps for N is then stored in a vector

#Next we'll calculate the Watterson's estimator
n <- nrow(North)
watt_N <- snps_N / sum(1/seq(1,n-1))
#The estimator is the number of polymorphic alleles divided by the sum of
#1 dividied by....'seq' generates a sequence of numbers, here from 1 to 1 less than the sample size
#which here is the number of rows (20 chromosomes for 10 individuals)

#Let's repeat again for South
freqs <- apply(X=South, MAR=2, FUN=sum)/nrow(South)
snps_S <- length(which(freqs>0 & freqs<1))

#And calculate Watterson's estimator
n <- nrow(South)
watt_S <- snps_S / sum(1/seq(1,n-1)) #So we divide 1 by 1, then 1 by 2, then 1 by 3 and so on until 19
#then add those together and divide the number of polymorphic alleles by them

#Estimates of effective population size from Watterson's estimator
Ne_N_watt <- watt_N / (4 * 1e-8 * len)
Ne_S_watt <- watt_S / (4 * 1e-8 * len)

cat("\nThe North population has estimates of effective population size of",
    Ne_N_pi, "and", Ne_N_watt)
cat("\nThe Southern population has estimates of effective population size of",
    Ne_S_pi, "and", Ne_S_watt)

#Discuss the differences between the values of "theta" using different estimators.
#'Theta' is the amount of mutations between individuals, the amount of genetic variation between
#individuals of a population
#The expected number of nucleotide differences between two sequences is the expected 
#number of mutations = 'Theta' = estimated number of pairwise differences
#Using Tajima's estimator the Northern whales had 9.27 average pairwise differences 
#and Southern whale had 5.44 average pairwise differences.
#Using Watterson's estimator

#TWO
#Calculate and plot the (unfolded) site frequency spectrum for each population
#and discuss it.

#Northern population
n <- nrow(North)
sfs_N <- rep(0, n-1)
#Allele frequencies
derived_freqs <- apply(X=North, MAR=2, FUN=sum)
#The easiest (but slowest) thing to do would be to loop over
#all possible allele frequencies and count the occurences
for (i in 1:length(sfs_N)) sfs_N[i] <- length(which(derived_freqs==i))

#Southern population
n <- nrow(South)
sfs_S <- rep(0, n-1)
#Allele frequencies
derived_freqs <- apply(X=South, MAR=2, FUN=sum)
for (i in 1:length(sfs_S)) sfs_S[i] <- length(which(derived_freqs==i))

#Plot
barplot(t(cbind(sfs_N, sfs_S)), beside=T, names.arg=seq(1,nrow(South)-1,1), legend=c("North", "South"))

barplot(t(cbind(sfs_N, sfs_S)), beside=T, names.arg=seq(1,nrow(South)-1,1), legend=c("North", "South"))

cat("\nThe population with the greater population size has
    a higher proportion of singletons, as expected.")

#Bonus Question
#Calculate the joint site frequency spectrum; in other words, for each site
#you need to calculate the joint allele frequency (in one population
#and in the other) and fill in a corresponding matrix of count which will 
#be the joint 2D site frequency spectrum

sfs <- matrix(0, nrow=nrow(North)+1, ncol=nrow(South)+1)
for (i in 1:ncol(North)) {
  freq_N <- sum(North[,i])
  freq_S <- sum(South[,i])
  
  sfs[freq_N+1, freq_S+1] <- sfs[freq_N+1, freq_S+1] + 1
}

sfs[1,1] <- NA

image(t(sfs))

