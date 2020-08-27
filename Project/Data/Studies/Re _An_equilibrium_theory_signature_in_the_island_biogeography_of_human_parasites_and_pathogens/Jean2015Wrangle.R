
Nation <- igeo$nat
Area <- igeo$area
Distance <- igeo$dist
Total_Species <- igeo$iRS
Bacteria <- igeo$iRSbact
Viruses <- igeo$iRSvirus
Fungi <- igeo$iRSfung
Parasites <- igeo$iRSpara
Protozoa <- igeo$iRSproto
Title <- "An equilibrium theory signature in the island biogeography of human parasites and pathogens"
Author <- "Jean et al"
Year <- "2015"

Data <- cbind(Year, Author, Title, Nation, Area, Distance, Total_Species, Bacteria, Viruses, Fungi, Parasites, Protozoa)


write.csv(Data, "../Data/Jean2015.csv")
