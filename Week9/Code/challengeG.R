t <- function(s, d, l)  {
  segments(s[1], s[2], (x <- l*cos(d) + s[1]), (y <- l*sin(d) + s[2]))
  return(c(x,y))
}

f <- function(s=c(1,1), d=1.58, l=2, c=1)  {
  if (l > 0.005) {
    f <- t(s, d, l) 
    a <-f(s = f, d = d + pi/4 * c, l = l*0.38, c)
    b <-f(s = f, d, l = l*0.87, c = c * -1) 
  } 
} 

  plot(1, xaxt='n', yaxt='n', ann=FALSE, xlim=c(-3, 5), ylim=c(0, 16))
  f()

rm(list=ls())
graphics.off()
