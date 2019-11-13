#Amy Solman amy.solman19@imperial.ac.uk
#Monday 8th November
#Genomics and Bioinformatics Day Five

#Practical on population subdivision and demographic inferences

rm(list=ls())
len <- 2000
setwd("/Users/amysolman/Documents/CMEECourseWork/Week6/Code")

Haplotypes <- as.matrix(read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/turtle.csv",
                                 stringsAsFactors = F, header = F, colClasses=rep("numeric", len)))
Genotypes <- as.matrix(read.csv("../Data/mfumagal-genomics_and_bioinformatics-5f3653a066bc/Practicals/turtle.genotypes.csv",
                                stringsAsFactors = F, header = F, colClasses = rep("numeric", len)))
dim(Genotypes) #40 rows (individuals 0, 1 or 2) by 2000 polymorphic alleles



#You are interested in inferring the history of a population of 
#sea turtles
#You collected some DNA data from 40 (diploid) individuals from 4 different
#locations (A, B, C, D). You have 10 individuals for each
#location. For each sample, you have access to 2000 SNPs (not base pairs, only
#the polymorphic sites). The data on alleles/haplotypes is stored in turtle.csv
#(80 rows) while the data on genotypes (40 rows) is stored in
#turtle.genotypes.csv. Genotypes are encoded as 0/1/2 as homozygous for the 
#ancestral, heterozygous, homozygous for the derived allele, respectively.

#1. Test whether there is a population subdivision in this sample and, if so, 
#at which extent.

#So here we are asking, is there genetic subdivision within our sample and between the four populations?

#There are several ways of doing it. (A) You may want to infer a tree from
#genetic distances. In R you can use dist to calculate eucledian distances between 
#individuals based on their genotypes. From the resulting distance
#matrix you can infer a tree using tree <- hclust(distance_matrix) and then plot it 
#with plot(tree). (B) You can do a Principal Component Analysis. In R you can use
#pca <- prcomp(data...) to calculate principal components which will be stored in 
#pca$x. You can plot the first two/three components afterwards. For this analysis 
#is it better to consider only SNPs with an allele frequency of at least 0.05.
#(C) You can calculate everage FST across all SNPs for each pair of subpopulation and 
#see whether it is larger than zero, and whether it changes for each comparison.
#My suggestion would be to start with point (C) as discussed during the lecture.

#Assign a name for each location
locations <- rep(c("A","B","C","D"), each=10)
#we use rep here because we want to concantenate the character values A, B, C, D
#to the function 'location' 10 times each

#To test whether this a population subdivision we can do several things
#for instance, we can build a tree of all samples and check
#whether we observe some cluster
#we can do this by first building a distance matrix and then a tree

distance <- dist(Genotypes) #here we're passing the genotypes data
#through a distance matrix computation. What in the heck does that mean?
#The distance matrix is comprised of distance measures for each pair of
#cases in the data set. A distance measure is a measure of similarity 
#between two cases, based on a numeric set of values.
#Default distance measure is the Euclidean Distance (ordinary straight line distance
#in geometric space)

tree <- hclust(distance) #What does hclust do? hierarchical clustering
#Here we are preforming a hierarchical cluster analysis on a set of dissimilarities
#(our distance matrix). Basically, if we want to plot a dendrogram with our data
#that is a graph that shows hierarchical relationships between out data
#we need to create a distance matrix, and then apply hierarchical clustering

plot(tree, labels = locations)

#Or we can do a PCA
#We can filter out our low-frequency variants first

colors <- rep(c("blue", "red", "yellow", "green"), each=5)


index <- which(apply(FUN=sum, X=Genotypes, MAR=2)/(nrow(Genotypes)*2)>0.03)

pca <- prcomp(Genotypes[,index], center=T, scale=T)

summary(pca)

plot(pca$x[,1], pca$x[,2], col=colors, pch=1)
legend("right", legend=sort(unique(locations)), col=unique(colors), pch=1)

calcFST <- function(pop1, pop2) {
  #only for equal sample sizes
  fA1 <- as.numeric(apply(FUN=sum, X=pop1, MAR=2)/
nrow(pop1))
  fA2 <- as.numeric(apply(FUN=sum, X=pop2, MAR=2)/
nrow(pop2))
  FST <- rep(NA, length(fA1))
  
  for (i in 1:length(FST)) {
    
    HT <- 2 * ( ( fA1[i] + fA2[i]) / 2 ) * (1 -
((fA1[i] + fA2[i]) / 2) )
    HS <- fA1[i] * (1 - fA1[i]) + fA2[i] * (1 - 
fA2[i])
    FST[i] <- (HT - HS) /HT
  }
  FST
}

snps <- which(apply(FUN=sum, X=Haplotypes, MAR=2)/
  (nrow(Haplotypes))>0.03)

cat("\nFST value (average):",
"\nA vs B", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[21:40,snps]),na.rm=T),
"\nA vs C", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[41:60,snps]),na.rm=T),
"\nA vs D", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[61:80,snps]),na.rm=T),
"\nB vs C", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[41:60,snps]),na.rm=T),
"\nB vs D", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[61:80,snps]),na.rm=T),
"\nC vs D", mean(calcFST(Haplotypes[1:20,snps],
Haplotypes[61:80,snps]),na.rm=T),"\n")

#These values indicate a certain degree of population subdivision

#Or we can calculate FST between locations from haplotype

#2. Assess whether there has been isolation by distance in this species, 
#knowing that the geographical distance of each population
#from a putative origin is: A (5km), B (10km), C (12km), D (50km).

#You can test whether genetic distance correlated with geographic distance. 

#2) There is no evidence of isolation by distance, but instead of admixture

#Bonus question:
#assuming that we have access to reference information from 3 known subpopulations
#in the area, how would you perform an admixture analysis in this sample? Allele 
#frequency for a set of markers for 3 subpopulations are stored
#in turtle_markers.csv, with the first column indicating that the genomic position 
#of the marker and the other columns showing the derived allele frequency at each 
#subpopulation. How would you do that?



