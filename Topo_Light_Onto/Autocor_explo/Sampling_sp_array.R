
# Species
library(tidyverse)
library(cmdstanr)

# Args
arg <- commandArgs(trailingOnly = TRUE)
ID <- as.integer(arg[1])
# ID = 1
iter <- as.integer(arg[2])
# iter = 2000

# Species of interest
# sp <- (read.csv("../../Data/InterestSpecies.csv")[,2]) # 75
sp <- c("Anaxagorea_dolichocarpa", "Tabernaemontana_macrocalyx", # 5 agreg sp
        "Eperua_falcata", "Dicorynia_guianensis", "Paypayrola_hulkiana")
print(paste("ID:", ID))
s <- sp[ID]

print(paste("run for sp", s))

# setwd("D:/Mes Donnees/PhD/R_codes/PhD_cluster/Topo_Light_Onto/Autocor_explo/")
if(!file.exists("Chains"))
  dir.create("Chains")
if(!file.exists("Chains/Hybrid_allpred"))
  dir.create("Chains/Hybrid_allpred")

# Presence data
# load real presence-absences data on 25ha 
load("../../Data/Realsp_25ha.Rdata")
# View(datalist[[1]])

DATA <- datalist[names(datalist) %in% s][[s]] # only species in sp
# View(datalist[["Iryanthera_hostmannii"]])

IDpres <- which(DATA$Presence==1) # all presence
IDabs <- sample(which(DATA$Presence==0), size = length(IDpres)) # the same nbr of absences
Id <- c(IDpres, IDabs)
# abs <- DATA[IDabs,]

# DataM
# les noms des var doivent etre les memes que dans le fichier stan
dataM <- list(N = nrow(DATA), # 47 850
              Presence = DATA$Presence,
              Light = DATA$logTransmittance,
              Topography = DATA$logTWI,
              DBH = DATA$logDBH,
              N_p = length(Id),
              preds = Id)
getwd()

if(!file.exists("PredID"))
  dir.create("PredID")
saveRDS(Id, paste("./PredID/PredID_",s, ".rds",sep=""))

# median(datalist[[1]][datalist[[1]]$Presence==1,]$TWI)
# hist(datalist[[1]][datalist[[1]]$Presence==1,]$TWI)
# median(datalist[[1]][datalist[[1]]$Presence==1,]$logTWI)
# seq(min(datalist[[1]]$logTWI), max(datalist[[1]]$logTWI), length.out = Np) # 1.358045 - 2.400176
# seq(min(datalist[[1]]$logTransmittance), max(datalist[[1]]$logTransmittance), length.out = Np) # -7.308724e+00 , 8.941571e-08

# names(dataM) <- names(datalist)


# Model
Sys.time()
model_name <- "Hybrid_allpred"
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
                      iter_warmup = floor(iter/2),
                      iter_sampling = iter,
                      save_warmup = FALSE)
  fit$save_output_files(dir = chain_path)
}
Sys.time() # 40 min

print(paste(s, "DONE"))

