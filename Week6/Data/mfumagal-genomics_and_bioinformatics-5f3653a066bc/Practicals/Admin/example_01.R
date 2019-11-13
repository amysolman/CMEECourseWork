
# brown bears

## 1) identify which positions are SNPs

### read data
data <- read.csv("../bears.csv", stringsAsFactors=F, header=F, colClasses=rep("character", 10000))
dim(data)

### SNPs are positions where you observed more than one allele
### the easiest thing is to loop over all sites and record the ones with two alleles
snps <- c()
for (i in 1:ncol(data)) {
	if (length(unique(data[,i]))==2) snps <- c(snps, i)
}
### this works to retain the indexes of SNPs; a smartest way would not involve doing a loop but using `apply` functions
cat("\nNumber of SNPs is", length(snps))

### reduce the data set
data <- data[,snps]
dim(data)


## 2) calculate, print and visualise allele frequencies

### again we can loop over each SNP and easily calculate allele frequencies
frequencies <- c()
for (i in 1:ncol(data)) {

        ### alleles in this SNPs
        alleles <- sort(unique(data[,i]))
        cat("\nSNP", i, "with alleles", alleles)

        ### we have to make a decision on which allele to consider to calculate its frequency; 
        ### for instance, after we sort them, we can pick the second one (but the choice at this stage is arbitrary)

        ### frequency (of the second allele)
        freq <- length(which(data[,i]==alleles[2])) / nrow(data)
        cat(" and allele frequency of the second allele", freq)

        frequencies <- c(frequencies, freq)
}
### we can plot is as a histogram
hist(frequencies)
### or simply the frequencies at each position
plot(frequencies, type="h")


## 3) calculate and print genotype frequencies

### again, we can loop over each SNPs and each individual and print the genotype frequencies
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
	cat(" and genotype frequencies", genotype_counts)
}


## 4) calculate and print homozygosity and heterozygosity

### we can reuse the previous code and easily calculate the heterozygosity
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


## 5) test for HWE, with calculating of expected genotype counts

nonHWE <- c() # to store indexes of SNPs deviating from HWE
nsamples <- 20
for (i in 1:ncol(data)) {

        ### alleles in this SNPs
        alleles <- sort(unique(data[,i]))
        cat("\nSNP", i)  

	### as before, I can choose one allele as "reference"
	### frequency (of the second allele)
        freq <- length(which(data[,i]==alleles[2])) / nrow(data)

	### from the frequency, I can calculate the expected genotype counts under HWE
	genotype_counts_expected <- c( (1-freq)^2, 2*freq*(1-freq), freq^2) * nsamples

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

	### test for HWE: calculate chi^2 statistic
	chi <- sum( (genotype_counts_expected - genotype_counts)^2 / genotype_counts_expected )

	## pvalue
	pv <- 1 - pchisq(chi, df=1)
        cat("with pvalue for test against HWE", pv)

	## retain SNPs with pvalue<0.05
	if (pv < 0.05) nonHWE <- c(nonHWE, i)

}


## 6) calculate, print  and visualise inbreeding coefficients for SNPs deviating from HWE

### assuming we ran the code for point 5, we already have the SNPs deviating
F <- c()
nsamples <- 20
for (i in nonHWE) {

        ### alleles in this SNPs
        alleles <- sort(unique(data[,i]))
        cat("\nSNP", i)

        ### as before, I can choose one allele as "reference"
        ### frequency (of the second allele)
        freq <- length(which(data[,i]==alleles[2])) / nrow(data)

        ### from the frequency, I can calculate the expected genotype counts under HWE
        genotype_counts_expected <- c( (1-freq)^2, 2*freq*(1-freq), freq^2) * nsamples

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

	### calculate inbreeding coefficient
	inbreeding <- ( 2*freq*(1-freq) - (genotype_counts[2]/nsamples) ) / ( 2*freq*(1-freq) )
	F <- c(F, inbreeding)
	cat(" with inbreeding coefficient", inbreeding)
}
### plot
hist(F)
plot(F, type="h")




