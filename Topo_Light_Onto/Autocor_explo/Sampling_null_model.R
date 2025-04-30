
# Environment
library(tidyverse)
library(cmdstanr)

# Species of interest
s <- "Dicorynia_guianensis"

setwd("D:/Mes Donnees/PhD/R_codes/PhD_cluster/Topo_Light_Onto/Autocor_explo/")
if(!file.exists("Chains"))
  dir.create("Chains")
if(!file.exists("Chains/Null"))
  dir.create("Chains/Null")

# Presence data
# load real presence-absences data on 25ha 
load("../../Data/Realsp_25ha.Rdata")
# View(datalist[[1]])

DATA <- datalist[names(datalist) %in% s][[s]] # only species in sp
# View(datalist[["Iryanthera_hostmannii"]])

# DataM
# les noms des var doivent etre les memes que dans le fichier stan
dataM <- list(N = nrow(DATA), # 47 850
              Presence = DATA$Presence)
getwd()

# Model
Sys.time()
model_name <- "Null"
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
  fit <- model$sample(data = dataM,
                      chains = 4,
                      parallel_chains = 4,
                      iter_warmup = floor(2000/2),
                      iter_sampling = 2000,
                      save_warmup = FALSE)
  fit$save_output_files(dir = chain_path)
}
Sys.time() # 40 min

print(paste(s, "DONE"))

