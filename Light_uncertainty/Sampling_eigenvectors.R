
# Species
library(tidyverse)
library(cmdstanr)

# Args
arg <- commandArgs(trailingOnly = TRUE)
ID <- as.integer(arg[1])
# ID = 1
iter <- as.integer(arg[2])
# iter <- 500
Np <- 50 # number of predictions

# setwd("D:/Mes Donnees/PhD/R_codes/PhD_cluster/Light_uncertainty/")

# Species - Sample combinations
Combin <- read_csv("../Data/Combin_Sp_Sample.csv")

print(paste("ID:", ID))
s <- Combin[ID,]$Species
# s = "Tachigali_melinonii"

print(paste("run for sp", s, "Sample:", Combin[ID,]$Sample))

if(!file.exists("Chains"))
  dir.create("Chains")
if(!file.exists("Chains/Hybrid_eigenvectors"))
  dir.create("Chains/Hybrid_eigenvectors")
getwd()

# Presence data
# load real presence-absences data on 9ha 
load("../Data/Realsp_9ha_eigenvectors_incertitude.Rdata")
# View(datalist_eig[[1]])

x <- datalist_eig[names(datalist_eig) %in% s][[s]] %>% # only species in sp
  filter(Sample == Combin[ID,]$Sample) # for this sample (tree height estimation)
# View(datalist_eig[["Iryanthera_hostmannii"]])


# DataM
# les noms des var doivent etre les memes que dans le fichier stan
# x <- datalist[[1]]
K = length(grep("^V",colnames(x)))
Autocor = ifelse(K>0, 1,0)

dataM <- list(N = nrow(x), # 47 850
              Presence = x$Presence,
              Light = x$logTransmittance,
              Topography = x$logTWI,
              # spatial predictors (i.e Moran's eigenvectors)
              Autocor = Autocor,
              K = K, # Nbr of eigenvectors
              Spatial = as.matrix(x[,grep("^V",colnames(x))]) , # eigenvectors matrix
              # number of predictions
              N_L_p = Np, # light
              N_T_p = Np, # topography
              # environment of predictions
              Lightp = seq(min(x$logTransmittance), max(x$logTransmittance), length.out = Np),
              Topographyp = median(x[x$Presence==1,]$logTWI) # the topography the most represented
)

# apply(Spatial, 2, median)
# apply(x[x$Presence==1,grep("^MEM",colnames(x))], 2, median)

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
  if(!file.exists(chain_path)) dir.create(chain_path)

chain_path <- file.path("Chains", model_name, s, Combin[ID,]$Sample)
print(chain_path)

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

