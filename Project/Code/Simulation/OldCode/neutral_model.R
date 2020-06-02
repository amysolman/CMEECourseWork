rm(list=ls())
graphics.off()

# This code simulates a metacommunity in Hubbell's neutral model of biodiversity
# community size
J = 1024
# speciation rate
nu = 0.01
# create the community
A = rep(1,J)
# initial the species counter
S_curr = 1

# number of timesteps (birth-death events) to run the simulation for
t_max = 100000

# set this to "do_animation = F" if you don't want to see the animation
do_animation = T

# computer all the death indices, birth indices in advance to speed up the
# program
death_indices = sample(J,t_max,replace=T)
birth_indices = sample(J,t_max,replace=T)
# do the same with the indices that will determine whether speciation events
# occur
do_speciation = rbinom(t_max,1,nu)

for ( i in 1:t_max )
  {
  # see if this timestep involves a speciation event
  if ( do_speciation[i] )
    {
    # yes: create the new species
    A[death_indices[i]] = S_curr+1
    S_curr = S_curr+1
    }
  else
    {
    # no: do a regular birth-death event
    A[death_indices[i]] = A[birth_indices[i]]
    }

  if ( do_animation & i%%100 == 0 )
    {
    image(matrix(A,32,32),col=rainbow(length(unique(A))))
    dev.flush()
    }
  }

# collate the simulated data to get the rank-abundance distribution
sp_abund = table(A)
sp_rank = rank(-sp_abund,ties.method='first')
iii = order(sp_rank)
plot(sp_rank[iii],sp_abund[iii],log='y',type='l',xlab='Rank',ylab='Abundance')

# compute the exact theoretical abundance distribution
n = 1:J
theta = J*nu/(1-nu)
SAD_theory_exact = (theta/n)*exp(lgamma(J+1)+lgamma(J+theta-n)-lgamma(J+1-n)-lgamma(J+theta))
SAD_cum_theory_exact = cumsum(SAD_theory_exact)
S_tot_theory_exact = sum(SAD_theory_exact)

# compute the log-series abundance distribution (approximate)
SAD_theory_log_series = theta*(1-nu)^n/n
SAD_cum_theory_log_series = cumsum(SAD_theory_log_series)
S_tot_theory_log_series = sum(SAD_theory_log_series)

# draw the theoretical rank-abundance distributions
lines(c(S_tot_theory_exact,S_tot_theory_exact-SAD_cum_theory_exact),c(1,n),col='red',type='l')
lines(c(S_tot_theory_log_series,S_tot_theory_log_series-SAD_cum_theory_log_series),c(1,n),col='red',type='l',lty=2)

# print out the total species counts from the simulations and the theoretical
# formula
cat('S_sim = ',length(sp_abund),'; S_theory = ',sum(SAD_theory_exact),'\n',sep='')

