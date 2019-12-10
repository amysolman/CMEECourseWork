# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  combined_results <- list() #create your list output here to return
  return(combined_results)
}

#Read in and process teh output files
#Read in all your ouput files
#Provide four bar graphs in a multi-panel graph (one for each simulation size) 
#each showing mean species abundance octave result from all simulation runs of that size
#Only use data of the abundance curves after the burn in time is up.
#The function should also return a list of four vectors corresponding to 
#the octave outputs that plot the four graphs.
#The vectors should appear in the list in increasing community size order (size=500, 1000, 2500, 5000)
#Hint: use load function on your .rda files and use sum_vec
#This is an extension of question 16