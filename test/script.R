args <- commandArgs(trailingOnly = TRUE)
path <- args[1] # take the 1st argument of the job file
dir.create(path)

library(cmdstanr)
mod <- cmdstan_model("model.stan")
mod$print()
data_list <- list(N = 10, y = c(0,1,0,0,0,0,0,0,0,1))

fit <- mod$sample(
  data = data_list,
  chains = 4,
  parallel_chains = 4,
  threads_per_chain = 1,
  refresh = 500 # print update every 500 iters
)
fit$save_output_files(dir = path)
