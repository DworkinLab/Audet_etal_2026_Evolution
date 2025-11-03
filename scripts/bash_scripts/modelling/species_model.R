library(data.table)
library(DESeq2)
library(tidyverse)
library(emmeans)
library(car)
library(glmmTMB)


sp_counts <- read.table("../data/species_counts.txt")
sp_design <- read.table("../data/species_design.txt", header = T)
sp_formula <- model.matrix(~ species * sex * leg * stage + replicate , data = sp_design)

# This data has already been filtered by expression level

data.in <- DESeqDataSetFromMatrix(countData = sp_counts,
                                  colData = sp_design,
                                  design = sp_formula)
data.in <- DESeq2::estimateSizeFactors(data.in)
normFactors <- DESeq2::sizeFactors(data.in)

nt <- min(parallel::detectCores(), 32)

sp_design$species <- factor(sp_design$species, levels = c("pro","car","mel"))
sp_design$sex <- factor(sp_design$sex, levels = c("M","F"))


cpm.genes.check <- list()

temp <- sp_counts
Sys.time()

x <- 1
y <- 15

v <- 1
w <- 12

t <- 1
u <- 4

r <- 1
s <- 24

count <- 0
anova_list <- matrix(nrow = 160000, ncol = 4)
lost_genes <- list()
mf_contrast <- matrix(nrow = 250000, ncol = 11)
mf_separate <- matrix(nrow = 250000, ncol = 10)
stage_contrast <- matrix(nrow = 36000, ncol = 11)
leg_contrast <- matrix(nrow = 36000, ncol = 11)
targets <- row.names(sp_counts)



for (g in targets) {
  
  count <- count + 1
  if (count%%100 == 0){
    print(count)
    print(Sys.time())
  }
  
  the_counts <- sp_counts[g,]
  the_counts <- round(the_counts, 0)
  the_counts <- unlist(the_counts)
  
  model <- glmmTMB(the_counts ~ (species*sex+leg+stage)^4 +
                     diag(1 | stage:replicate),
                   offset = normFactors, # check to see if we need to log transform
                   family = nbinom2(),
                   data = sp_design,
                   control = glmmTMBControl(parallel = nt))
  
  if (anyNA(as.vector(summary(model)$coef$cond[,2:4])) == T|
      anyNA(logLik(model)) == T) {
    
    lost_genes <- append(lost_genes, g)
    next;
  }
  
  anova_test <- car::Anova(model)
  
  #anova_test <- cbind(anova_test,g)
  
  #anova_list <- rbind(anova_list,anova_test)
  
  anova_list[x:y,] <- as.matrix(cbind(gene=g, anova_test))
  
  x <- x+15
  y <- y+15
  #dimnames(m2)[[1]]
  
  if (anyNA(logLik(model)) == T) {
    
    lost_genes <- append(lost_genes, g)
    next;
  }
  
  emm <- confint(emmeans(model, pairwise ~ sex|leg+stage+species))
  emm2 <- emmeans(model, pairwise ~ sex|leg+stage+species)
  
  temp <- as.data.frame(emm$contrasts)
  p.temp <- as.data.frame(as.data.frame(emm2$contrasts))
  
  
  mf_contrast_temp <- as.matrix(cbind(temp,p.temp[,8]))
  
  #mf_contrast_temp <- cbind(g, mf_contrast_temp)
  
  mf_separate_temp <- as.matrix(as.data.frame(emm$emmeans))
  
  mf_separate[r:s,] <- as.matrix(cbind(g, mf_separate_temp))
  
  r <- r + 24
  s <- s + 24
  
  mf_contrast[v:w,] <- as.matrix(cbind(g, mf_contrast_temp))
  
  v <- v+12
  w <- w+12
  
  stage_contrast_temp1 <- contrast(emm2[[1]], 
                                   interaction = c(stage = "trt.vs.ctrl1", sex = "pairwise"),
                                   by = "leg")
  stage_contrast_temp <- as.data.frame(as.data.frame(stage_contrast_temp1))
  
  stage_contrast_temp2 <- as.data.frame(as.data.frame(confint(stage_contrast_temp1)))
  #stage_contrast_temp2 <- cbind(g, stage_contrast_temp2)
  stage_contrast[t:u,] <- as.matrix(cbind(g, stage_contrast_temp2, stage_contrast_temp[,8]))
  
  
  leg_contrast_temp1 <- contrast(emm2[[1]], 
                                 interaction = c(leg = "trt.vs.ctrl1", sex = "pairwise"),
                                 by = "stage")
  leg_contrast_temp <- as.data.frame(as.data.frame(leg_contrast_temp1))
  
  leg_contrast_temp2 <- as.data.frame(as.data.frame(confint(leg_contrast_temp1)))
  #leg_contrast_temp2 <- cbind(g, leg_contrast_temp2)
  leg_contrast[t:u,] <- as.matrix(cbind(g, leg_contrast_temp2, leg_contrast_temp[,8]))
  
  t <- t+4
  u <- u+4
  
  
  
  
  #print(g)
}

write.table(anova_list, "../sp_anova_list.txt", quote = FALSE)
write.table(lost_genes, "../sp_lost_genes.txt", quote = FALSE)
write.table(mf_contrast, "../sp_mf_contrast.txt", quote = FALSE)
write.table(stage_contrast, "../sp_stage_contrast.txt", quote = FALSE)
write.table(leg_contrast, "../sp_leg_contrast.txt", quote = FALSE)
write.table(mf_separate, "../sp_separate.txt", quote = FALSE)







