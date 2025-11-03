library(edgeR)
library(DESeq2)
library(glmmTMB)
library(car)
library(emmeans)
library(tidyverse)

# Import all the file names
setwd("../../data/pro/")
in_dir = dir(, pattern="ReadsPerGene.out.tab")
system(paste("wc -l ",in_dir[[1]]))
# read in counts, sort and put together
counts_in <- lapply(in_dir, function(x) read.table(x, header=T, sep = "", nrows = 19444))
counts_sorted <- lapply(counts_in, function(x) x <- x[order(x[,1]),])
tot_count_matrix <- matrix(unlist(lapply(counts_sorted, function(x) x$V2)), 
                           nrow=19444, ncol=36)

colnames(tot_count_matrix) <- in_dir
rownames(tot_count_matrix) <- counts_sorted[[1]][,1]
notGenes <- grep('N_',rownames(tot_count_matrix))
#missingGenes <- grep('Missing',rownames(tot_count_matrix))
tot_count_matrix <- tot_count_matrix[-notGenes,]
#tot_count_matrix <- tot_count_matrix[-missingGenes,]

# writing out as a table so that I can run this on CC
write.table(tot_count_matrix, "../pro_counts.txt")

mel_counts <- tot_count_matrix

#mel_counts <- read.table("../data/mel_counts.txt", header = T)

#mel_counts <- read.table("~/Desktop/tester.txt", header = T)


# Need to make the experimental design matrix
# This can be taken just from the label I think
mel_names <- as.data.frame(names(as.data.frame(mel_counts)))
colnames(mel_names) <- "sample"

mel_design <- separate(mel_names, 
                       col = "sample", 
                       into = c("species","sex","leg","stage", "replicate"),
                       sep = "_", remove = FALSE)

mel_design$replicate <- sub('ReadsPerGene.out.tab', "", mel_design$replicate)


mel_design <- mel_design[,-c(1:2)]

#Need to make my formula for DeSeq

mel_formula <- model.matrix(~ sex * leg * stage + replicate , data = mel_design)

#Naming first column 'gene' and clearing up unnecessary column and first few rows of summary stats
#rownames(mel_counts) <- mel_counts$gene
# <- mel_counts[-c(1:4),-1]


# create a Dseq differentially expressed gene object
DGE_object <- DGEList(as.matrix(mel_counts))

#Determine which genes have sufficiently large counts to be retained in a statistical analysis.
#keep1 <- filterByExpr(DGE_object, mel_formula)
#DGE_object <- DGE_object[keep, ]

smallestGroupSize <- 4
keep <- rowSums(DGE_object$counts >= 10) >= smallestGroupSize
DGE_object <- DGE_object[keep,]

# I add one to every count to stop complete seperation issues
#DGE_object$counts <- DGE_object$counts + 1

# I want to filter my mel_counts by the DGE_object to get mel_counts down to the 11691 genes with sufficient counts
mel_counts <- mel_counts[row.names(DGE_object$counts),]
mel_counts <- mel_counts+1



# DESeqDataSet is a subclass of RangedSummarizedExperiment, used to store the input values, intermediate calculations and results of an analysis of differential expression
data.in <- DESeqDataSetFromMatrix(countData = mel_counts,
                                  colData = mel_design,
                                  design = mel_formula)

# A size factor relates to how many reads there are in each library. This is used to account for the fact that fold change may change due to the raw number of reads in a sample
data.in <- DESeq2::estimateSizeFactors(data.in)
normFactors <- DESeq2::sizeFactors(data.in)

#as.matrix(mel_design)

mel_design$sex <- factor(mel_design$sex, levels = c("M", "F"))
mel_design$leg <- factor(mel_design$leg, levels = c("for", "mid"))
mel_design$stage <- factor(mel_design$stage, levels = c("late", "early"))
mel_design$replicate <- as.factor(mel_design$replicate)

# For sum to zero, with only two levels does not matter, but with the 3 species final model, it does
options(contrasts=c("contr.sum", "contr.poly"))

#nt <- min(parallel::detectCores(), 32)

cpm.genes.check <- list()

temp <- mel_counts
Sys.time()

x <- 1
y <- 7

v <- 1
w <- 4

t <- 1
u <- 2

r <- 1
s <- 8

count <- 0
anova_list <- matrix(nrow = 11687*8, ncol = 4)
lost_genes <- list()
mf_contrast <- matrix(nrow = 11687*13, ncol = 10)
mf_separate <- matrix(nrow = 11687*13, ncol = 9)
stage_contrast <- matrix(nrow = 11687*3, ncol = 10)
leg_contrast <- matrix(nrow = 11687*3, ncol = 10)
targets <- row.names(mel_counts)

for (g in targets) {
  
  count <- count + 1
  if (count%%100 == 0){
    print(count)
    print(Sys.time())
  }
  
  the_counts <- mel_counts[g,]
  the_counts <- round(the_counts, 0)
  the_counts <- unlist(the_counts)

model <- glmmTMB(the_counts ~ (sex+leg+stage)^3 +
                         diag(1 | replicate:stage),
                       offset = normFactors, # check to see if we need to log transform
                       family = nbinom2(),
                       data = mel_design,
                 control = glmmTMBControl(parallel = 2))

if (anyNA(as.vector(summary(model)$coef$cond[,2:4])) == T|
    anyNA(logLik(model)) == T) {
  
  lost_genes <- append(lost_genes, g)
  next;
}

anova_test <- car::Anova(model)

#anova_test <- cbind(anova_test,g)

#anova_list <- rbind(anova_list,anova_test)

anova_list[x:y,] <- as.matrix(cbind(gene=g, anova_test))

x <- x+7
y <- y+7
#dimnames(m2)[[1]]

if (anyNA(logLik(model)) == T) {
  
  lost_genes <- append(lost_genes, g)
  next;
}

emm <- confint(emmeans(model, pairwise ~ sex|leg+stage))
emm2 <- emmeans(model, pairwise ~ sex|leg+stage)

temp <- as.data.frame(emm$contrasts)
p.temp <- as.data.frame(as.data.frame(emm2$contrasts))


mf_contrast_temp <- as.matrix(cbind(temp,p.temp[,8]))

#mf_contrast_temp <- cbind(g, mf_contrast_temp)

mf_separate_temp <- as.matrix(as.data.frame(emm$emmeans))

mf_separate[r:s,] <- as.matrix(cbind(g, mf_separate_temp))

r <- r + 8
s <- s + 8

mf_contrast[v:w,] <- as.matrix(cbind(g, mf_contrast_temp))

v <- v+4
w <- w+4

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

t <- t+2
u <- u+2




#print(g)
}

write.table(anova_list, "../pro_anova_list.txt", quote = FALSE)
write.table(lost_genes, "../pro_lost_genes.txt", quote = FALSE)
write.table(mf_contrast, "../pro_mf_contrast.txt", quote = FALSE)
write.table(stage_contrast, "../pro_stage_contrast.txt", quote = FALSE)
write.table(leg_contrast, "../pro_leg_contrast.txt", quote = FALSE)
write.table(mf_separate, "../pro_separate.txt", quote = FALSE)
sessionInfo()
