library(data.table)
library(prodlim)

orthos <- na.omit(fread("/home/audett/projects/def-idworkin/audett/prolongata/genome/melanogaster/fbgn_fbtr_fbpp_expanded_fb_2024_05_clean.tsv", h= T, select=c("gene_ID","gene_symbol")))
orthos <- unique(orthos)
# <- na.omit(fread("fbgn_fbtr_fbpp_expanded_fb_2024_05.tsv", h = T,fill=TRUE, skip = 4, select=c("transcript_ID","gene_symbol")))
args <- commandArgs(trailingOnly = TRUE)

counts <- na.omit(fread(args, h = F))
#counts <- na.omit(fread("mel_F_mid_late_6ReadsPerGene.out.tab", h = F))


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

counts_new$V1 <- gsub(",.*$","",counts_new$V1, perl = T)

for(i in counts_new$V1) {
  if (i %in% orthos$gene_ID) {
    index <- which(orthos$gene_ID == i)
    index_2 <- which(counts$V1 == i)
    counts_new$V1 <- gsub(paste0(counts_new$V1[index_2][1],"$"), orthos$gene_symbol[index], counts_new$V1, perl = TRUE)
    #[index_2]
    #print(head(counts_new))
  }
}

counts_new <- aggregate( counts_new[,2:4], counts_new[,1], FUN = sum )

write.table(counts_new, paste0(args), quote = F, row.names = F)
