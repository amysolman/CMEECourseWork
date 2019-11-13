
## 01_Alleles

# ~/Software/msdir/ms 40 1 -t 20 > ms1.txt
# read 40 haplotypes
ms <- readLines("ms1.txt")

# pos of SNPs
LEN <- 10000
pos <- as.numeric(strsplit(ms[6], split=" ")[[1]])
pos <- round(pos[-1]*LEN)

# read haplotypes
ms <- ms[7:length(ms)]
haplos <- matrix(0, nrow=length(ms), ncol=LEN)
for (i in 1:length(ms)) haplos[i,pos] <- as.numeric(strsplit(ms[i], split="")[[1]])

# fill in bases
for (i in 1:ncol(haplos)) {
	bases <- sample(c("A","C","G","T"), 2, repl=F)
	haplos[which(haplos[,i]==0),i] <- bases[1]
	haplos[which(haplos[,i]==1),i] <- bases[2]
}

# write csv file
write.table(haplos, file="../bears.csv", row.names=F, col.names=F, quote=F, sep=",")

###---------------------------------------##################

## 02_Divergence
#  ~/Software/msdir/ms 60 1 -t 20 -r 40 20000 -I 3 20 20 20 -ej 5 2 3 -ej 2 1 2 > ms2.txt

ms <- readLines("ms2.txt")

# pos of SNPs
LEN <- 20000
pos <- as.numeric(strsplit(ms[6], split=" ")[[1]])
pos <- round(pos[-1]*LEN)

# read haplotypes
ms <- ms[7:length(ms)]

haplos <- matrix(0, nrow=length(ms), ncol=LEN)
for (i in 1:length(ms)) haplos[i,pos] <- as.numeric(strsplit(ms[i], split="")[[1]])

for (i in 1:ncol(haplos)) {
        bases <- sample(c("A","C","G","T"), 2, repl=F)
        haplos[which(haplos[,i]==0),i] <- bases[1]
        haplos[which(haplos[,i]==1),i] <- bases[2]
}

# for each species
haplos1 <- haplos[1:20,]
haplos2 <- haplos[21:40,]
haplos3 <- haplos[41:60,]

# write csv file
write.table(haplos1, file="../western_banded_gecko.csv", row.names=F, col.names=F, quote=F, sep=",")
write.table(haplos2, file="../bent-toed_gecko.csv", row.names=F, col.names=F, quote=F, sep=",")
write.table(haplos3, file="../leopard_gecko.csv", row.names=F, col.names=F, quote=F, sep=",")


###------------------------------------------########

## 03_Coalescence
# L=50k
# theta=4N mu L = 4 * 10000 * 1e-8 * 50000 = 20
# ~/Software/msdir/ms 40 1 -t 20 -I 2 20 20 -g 1 44.36 -n 2 0.125 -eg 0.03125 1 0.0 -en 0.0625 2 0.02 -ej 0.09375 2 1 > ms3.txt

ms <- readLines("ms3.txt")

# pos of SNPs
LEN <- 50000
pos <- as.numeric(strsplit(ms[6], split=" ")[[1]])
pos <- round(pos[-1]*LEN)

# read haplotypes
ms <- ms[7:length(ms)]
# for each species
ms1 <- ms[1:20]
ms2 <- ms[21:40]

haplos1 <- matrix(0, nrow=length(ms1), ncol=LEN)
for (i in 1:length(ms1)) haplos1[i,pos] <- as.numeric(strsplit(ms1[i], split="")[[1]])

haplos2 <- matrix(0, nrow=length(ms2), ncol=LEN)
for (i in 1:length(ms2)) haplos2[i,pos] <- as.numeric(strsplit(ms2[i], split="")[[1]])

write.table(haplos1, file="../killer_whale_North.csv", row.names=F, col.names=F, quote=F, sep=",")
write.table(haplos2, file="../killer_whale_South.csv", row.names=F, col.names=F, quote=F, sep=",")


### ------------------------------------ ####

## 04_Demography
# model from https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1000695#s5
# 4 pops but with migration
# ~/Software/msdir/ms 80 1 -s 2000 -I 4 20 20 20 20 -n 1 1.682020 -n 2 2.424020 -n 3 4.185850 -n 4 7.942130 -es 0 4 0.522451 -ej 0 5 2 -eg 0 2 67.978337 -eg 0 3 109.406463 -eg 0 4 147.474095 -ema 0 5 x 0 0 0 x 0 x 3.960400 0 x 0 3.960400 x 0 x 0 0 0 x x x x x x x -ej 0.029475 4 3 -ema 0.029475 5 x 0.881098 0.561966 x x 0.881098 x 3.960400 x x 0.561966 3.960400 x x x x x x x x x x x x x -ej 0.036114 3 2 -en 0.036114 2 0.287184 -ema 0.036114 5 x 7.293140 x x x 7.293140 x x x x x x x x x x x x x x x x x x x -ej 0.197963 2 1 -en 0.303500 1 1 > ms4.txt

ms <- readLines("ms4.txt")

# pos of SNPs
nrsnps <- 2000
pos <- seq(1, nrsnps, 1)

# read haplotypes
ms <- ms[7:length(ms)]

haplos <- matrix(NA, nrow=length(ms), ncol=nrsnps)
for (i in 1:length(ms)) haplos[i,] <- as.numeric(strsplit(ms[i], split="")[[1]])

genos <- matrix(NA, nrow=(nrow(haplos)/2), ncol=nrsnps)

for (j in 1:ncol(haplos)) {
	for (i in 1:nrow(genos)) {
		j1 <- (i*2)-1
		j2 <- i*2
		genos[i,j] <- sum(haplos[c(j1,j2),j])
	}
}

# write csv file
write.table(haplos, file="../turtle.csv", row.names=F, col.names=F, quote=F, sep=",")

# write csv file
write.table(genos, file="../turtle.genotypes.csv", row.names=F, col.names=F, quote=F, sep=",")

# calculate population allele frequencies
markers <- which(apply(X=haplos, MAR=2, FUN=sum)/(nrow(haplos))>0.04)

freq1 <- (apply(X=haplos[1:20,markers], MAR=2, FUN=sum)/12)+rnorm(1,0,0.01)
freq1[which(freq1<0)] <- 0
freq1[which(freq1>1)] <- 1

freq2 <- (apply(X=haplos[21:30,markers], MAR=2, FUN=sum)/10)+rnorm(1,0,0.01)
freq2[which(freq2<0)] <- 0
freq2[which(freq2>1)] <- 1

freq3 <- (apply(X=haplos[31:40,markers], MAR=2, FUN=sum)/8)+rnorm(1,0,0.01)
freq3[which(freq3<0)] <- 0
freq3[which(freq3>1)] <- 1

freqs <- cbind(markers,round(freq1*100)/100,round(freq2*100)/100,round(freq3*100)/100)

write.table(freqs, file="../turtle_markers.csv", row.names=F, col.names=F, quote=F, sep=",")








