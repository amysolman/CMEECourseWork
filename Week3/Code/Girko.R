# Amy Solman amy.solman19@imperial.ac.uk
# 22nd October 2019
# Girko.R

#According the Girko's circular law, the eigenvalues of a matrix
#M of size N x N are approximately contained in a circle
#in the complex plane with radius sqr root N

#First build a function object that will calculate the ellipse
#(the predicted bounds of the eigenvalues)

require(ggplot2)

build_ellipse <- function(hradius, vradius){ #function that returns an ellipse
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints +1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)
  return(data.frame(x = x, y = y))
}

N <- 250 #Assign size of matrix

M <- matrix(rnorm(N*N), N, N) #Build the matrix

eigvals <- eigen(M)$values #Find the eigenvalues

eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) #Build a dataframe

my_radius <- sqrt(N) #The radius of the circle is sqrt(N)

ellDF <- build_ellipse(my_radius, my_radius) #Dataframe to plot the ellipse

names(ellDF) <- c("Real", "Imaginary") #Rename the columns

#Now the plotting...

p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <- p +
  geom_point(shape = I(3)) +
  theme(legend.position = "none")

#Now add the vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))

#Finally, add the ellipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))
p

#Save plot

pdf("../Results/Girko.pdf")
print(p)
dev.off()
