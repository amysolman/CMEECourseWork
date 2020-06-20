rm(list=ls())

library("ggplot2")

Area = seq(0,1000, 10)
Niches1 <- rep(1:5, each = 5)
Niches2 <- rep(6:10, each = 5)
Niches3 <- rep(11:15, each = 4)
Niches4 <- rep(16:25, each = 3)
Niches <- c(0, Niches1, Niches2, Niches3, Niches4)
Immigration1 <- rep(1:5, each = 5)
Immigration2 <- rep(6:10, each = 3)
Immigration3 <- rep(11:15, each = 2)
Immigration4 <- rep(16:65, each = 2)
Immigration <- c(0, Immigration1, Immigration2, Immigration3, Immigration4)
df <- data.frame(Area, Niches, Immigration)

p1 <- ggplot(df, aes(x = Area, y = Niches)) +
  geom_line(data = df, aes(x = Area, y = Niches, colour = "Niches")) +
  geom_line(data = df, aes(x = Area, y = Immigration, colour = "Immigration")) +
  theme_bw() +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  labs(colour = "Constraints")

pdf("../../Other/presentationplot.pdf")
print(p1)
dev.off()

