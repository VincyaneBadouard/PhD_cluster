
# Species
library(tidyverse)
library(cmdstanr)

# Args
arg <- commandArgs(trailingOnly = TRUE)
ID <- as.integer(arg[1])
iter <- as.integer(arg[2])
# iter <- 2000
Np <- 50 # number of predictions

# setwd("D:/Mes Donnees/PhD/R_codes/PhD_cluster/Topo_Light/")


# Species of interest
sp <- (read.csv("../Data/InterestSpecies.csv")[,2]) # 75
print(paste("ID:", ID))
s <- sp[ID]
# s = "Dicorynia_guianensis"

print(paste("run for sp", s))

if(!file.exists("Chains"))
  dir.create("Chains")
if(!file.exists("Chains/Hybrid_eigenvectors"))
  dir.create("Chains/Hybrid_eigenvectors")
getwd()

# Presence data
# load real presence-absences data on 25ha 
load("../Data/Realsp_25ha_eigenvectors.Rdata")
# View(datalist_eig[[1]])

datalist <- datalist_eig[names(datalist_eig) %in% s] # only species in sp
# View(datalist[["Iryanthera_hostmannii"]])


# DataM
# les noms des var doivent etre les memes que dans le fichier stan
# x <- datalist[[1]]
dataM <- lapply(datalist, function(x) list(N = nrow(x), # 47 850
                                           Presence = x$Presence,
                                           Light = x$logTransmittance,
                                           Topography = x$logTWI,
                                           # spatial predictors (i.e moran's eigenvectors)
                                           K = length(grep("^V",colnames(x))), # Nbr of eigenvectors
                                           Spatial = as.matrix(x[,grep("^V",colnames(x))]), # eigenvectors matrix
                                           # number of predictions
                                           N_L_p = Np, # light
                                           N_T_p = Np, # topography
                                           # environment of predictions
                                           Lightp = seq(min(x$logTransmittance), max(x$logTransmittance), length.out = Np),
                                           Topographyp = median(x[x$Presence==1,]$logTWI), # the topography the most represented
                                           Spatialp = apply(x[x$Presence==1, grep("^V",colnames(x))], 2, median)
                                          )
)

# apply(Spatial, 2, median)
# apply(x[x$Presence==1,grep("^MEM",colnames(x))], 2, median)

# median(datalist[[1]][datalist[[1]]$Presence==1,]$TWI)
# hist(datalist[[1]][datalist[[1]]$Presence==1,]$TWI)
# median(datalist[[1]][datalist[[1]]$Presence==1,]$logTWI)
# seq(min(datalist[[1]]$logTWI), max(datalist[[1]]$logTWI), length.out = Np) # 1.358045 - 2.400176
# seq(min(datalist[[1]]$logTransmittance), max(datalist[[1]]$logTransmittance), length.out = Np) # -7.308724e+00 , 8.941571e-08


# Model
Sys.time()
model_name <- "Hybrid_eigenvectors"
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
                      iter_warmup = iter,
                      iter_sampling = iter,
                      save_warmup = FALSE)
  fit$save_output_files(dir = chain_path)
}
Sys.time() 

print(paste(s, "DONE"))

