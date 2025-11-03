if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

#BiocManager::install("edgeR",repos='https://cloud.r-project.org/')
#BiocManager::install("DESeq2",repos='https://cloud.r-project.org/')

#install.packages("glmmTMB",repos='https://cloud.r-project.org/')
#install.packages("car",repos='https://cloud.r-project.org/')
#install.packages("emmeans",repos='https://cloud.r-project.org/')
#install.packages("tidyverse",repos='https://cloud.r-project.org/')

library(edgeR)
library(DESeq2)
library(glmmTMB)
library(car)
library(emmeans)
library(tidyverse)
