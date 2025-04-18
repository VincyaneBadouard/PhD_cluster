
# Species
library(tidyverse)
library(cmdstanr)

# Args
arg <- commandArgs(trailingOnly = TRUE)
s <- arg[1]
iter <- as.integer(arg[2])
Np <- 50 # number of predictions


print(paste("run for sp", s))


# Presence data
# load real presence-absences data on 25ha 
load("../../Data/Realsp_25ha.Rdata")
# View(datalist[[1]])

datalist <- datalist[names(datalist) %in% s] # only species in sp
# View(datalist[["Iryanthera_hostmannii"]])


# DataM
# les noms des var doivent etre les memes que dans le fichier stan
dataM <- lapply(datalist, function(x) list(N = nrow(x), # 47 850
                                           Presence = x$Presence,
                                           Environment = x$logTWI,
                                           # number of predictions
                                           Np = Np,
                                           # environment of predictions
                                           Environmentp = seq(min(x$logTWI), max(x$logTWI), length.out = Np))
)

# seq(min(datalist[[1]]$logTWI), max(datalist[[1]]$logTWI), length.out = Np)

names(dataM) <- names(datalist)


# Model
Sys.time()
model_name <- "Affine"
model <- cmdstan_model(
  file.path(
    "Model",
    paste0(model_name, ".stan")
  ))
Sys.time() # 1 min


# Sampling
Sys.time()
chain_path <- file.path("Chains", model_name, s)
if(!file.exists(chain_path)){
  # unlink(chain_path, recursive = TRUE)
  dir.create(chain_path)
  fit <- model$sample(data = dataM[[s]],
                      chains = 4,
                      parallel_chains = 4,
                      iter_warmup = iter,
                      iter_sampling = iter,
                      save_warmup = FALSE)
  fit$save_output_files(dir = chain_path)
}
Sys.time() # 2h


# Model
Sys.time()
model_name <- "Quadratic"
model <- cmdstan_model(
  file.path(
    "Model",
    paste0(model_name, ".stan")
  ))
Sys.time() # 30 sec


# Sampling
Sys.time()
chain_path <- file.path("Chains", model_name, s)
if(!file.exists(chain_path)){
  # unlink(chain_path, recursive = TRUE)
  dir.create(chain_path)
  fit <- model$sample(data = dataM[[s]],
                      chains = 4,
                      parallel_chains = 4,
                      iter_warmup = iter,
                      iter_sampling = iter,
                      save_warmup = FALSE)
  fit$save_output_files(dir = chain_path)
}
Sys.time() # 13h


