library(data.table)
library(prodlim)

orthos <- na.omit(fread("/home/audett/projects/def-idworkin/audett/prolongata/genome/prolongata/prolongata_gene_index.txt", h= F))
#orthos <- na.omit(fread("prolongata_gene_index.txt", h = F))
args <- commandArgs(trailingOnly = TRUE)

counts <- na.omit(fread(args, h = F))
#counts <- na.omit(fread("pro_F_mid_late_3ReadsPerGene.out.tab", h = F))


#print(head(orthos))
#print(args)
#print(head(counts))

#counts$V1 <- sub('pro_', '', counts$V1)

#test <- list()

# test
#for(i in counts$V1) {
  
#  if (i %in% orthos$V1) {
#    temp <- rbind(temp,i)
#  }
#  test <- rbind(test, i)
#}

counts_new <- counts

for(i in unique(counts$V1)) {
  if (i %in% orthos$V1) {
    index <- which(orthos$V1 == i)
    index_2 <- which(counts$V1 == i)
   counts_new$V1 <- gsub(paste0(counts$V1[index_2][1],"$"), orthos$V2[index], counts_new$V1, perl = TRUE)
#[index_2]
#print(head(counts_new))
  }
}

counts_new <- aggregate( counts_new[,2:4], counts_new[,1], FUN = sum )

write.table(counts_new, paste0(args), quote = F, row.names = F)
