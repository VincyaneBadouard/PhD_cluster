# Select eigenvectors per sp and environment

# Glmnet fits generalized linear and similar models via **penalized maximum likelihood**.
# It fits linear, **logistic** and multinomial, poisson, and Cox regression models.  
# 
# The function glmnet returns a sequence of models for the users to choose from. Cross-validation is perhaps the simplest and most widely used method for that task. **cv.glmnet** is the main function to do cross-validation here.  
# 
# lambda.min = λ that gives minimum mean cross-validated error.  

library(readr)
library(tidyverse)
library(glmnet)

# setwd("D:/Mes Donnees/PhD/R_codes/PhD_cluster/Light_uncertainty/")

# Args
arg <- commandArgs(trailingOnly = TRUE)
ID <- as.integer(arg[1])
# ID = 1

# Species - Sample combinations
Combin <- read_csv("../Data/Combin_Sp_Sample.csv")

print(paste("ID:", ID))
s <- Combin[ID,]$Species
# s = "Tachigali_melinonii"
sample <- Combin[ID,]$Sample
# sample = "TreeHeight_1"

print(paste("run for sp", s, "Sample:", Combin[ID,]$Sample))

# Load eigenvectors
eigenval <- read_csv("../Data/All_obs_Eigenvectors_9ha.csv")

# Load species data
load("../Data/Realsp_9ha_incertitude.Rdata")

# Selection by species and environment -----------------------------------------

DATA <- datalist[[s]] %>% # only species in sp
  filter(Sample == sample) %>% # for this sample (tree height estimation)
  select(Xutm, Yutm, Presence, logTransmittance,logTWI)

y <- DATA$Presence # response vector


# Bind
dataall <- DATA %>% 
  bind_cols(eigenval)

# Model with eigenvectors
# Formula
formula_full <- as.formula(paste("~ logTransmittance + I(logTransmittance^2) + logTWI",
                                 paste(paste0("V",1:200), collapse="+"), sep="+"))

# Matrix of dimension nobs x nvars
matrix_full <- model.matrix(formula_full, data=dataall)[,-1] 

# Cross-validation
Sys.time() 
cv_fit <- cv.glmnet(matrix_full, y, family = "binomial", type.measure = "auc") # according to ROC curve
Sys.time() # 6 min for 25ha

coef_glmnet <- coef(cv_fit, s = "lambda.min") #  model coefficients at that value of λ
coef_glmnet 


# Selection of max 5 eigenvectors
vars <- data.frame(Vars = c("Intercept","logTransmittance","I(logTransmittance^2)","logTWI", paste0("V",1:200))) %>%
  tibble::rownames_to_column("i") %>% 
  mutate(i=as.numeric(i))

selection <- as.data.frame(summary(coef_glmnet)) %>% 
  select(-j) %>% 
  left_join(vars, by="i") %>% 
  arrange(desc(abs(x))) %>% 
  filter(!Vars %in% c("Intercept","logTransmittance","I(logTransmittance^2)","logTWI")) %>% 
  select(-i) %>% 
  slice(1:5)

eigenval_select <- eigenval %>% 
  select(selection$Vars)

print("Computed")

write_csv(eigenval_select,
          paste0("Eigenvectors/", s, "/", s, "_", sample, ".csv"))


