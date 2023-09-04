#load libraries
library(ggplot2)
library(pheatmap)
library(DESeq2)
library(dplyr)
library(RColorBrewer)
# ---------------------------------------------------------------------------------------------------------------------
#read the in files
countdata  <- read.csv("countsfile_1.csv",sep=",",header=T, row.names = 1)
metadata <- read.csv("metadata.csv", sep = ",", header=T, row.names = 1)

metadata$Sample_Id <- row.names(metadata)
metadata <- metadata[match(colnames(countdata), metadata$Sample_Id), ]

head(metadata)

#check coldata of metadata == rowdata of counts data
all(colnames(count) %in% rownames(metadata))
#check if the rownames and colnames are in same order
all(colnames(count) == rownames(metadata))

#----------------------------------------------------------------------------------------------------------------------
# construct deseq dataset
ddsMat <- DESeqDataSetFromMatrix(countData = countdata,
                                 colData = metadata,
                                 design = ~Groups)
#run deseq
ddsMat <- DESeq(ddsMat)

#results 
results <- results(ddsMat, pAdjustMethod = "fdr", alpha = 0.01)
summary(results)

mcols(results, use.names = T) 
ddsMat_rlog <- vst(ddsMat, blind = FALSE)
results_sig <- subset(results, padj < 0.05)
head(results_sig)

#plotPCA----------------------------------------------------------------------------------------------------------------------
plotPCA(ddsMat_rlog, intgroup = "Groups", ntop = 500) +
  theme_bw() + 
  geom_point(size = 5) + 
  scale_x_continuous(limits = c(-150, 150)) +
  scale_y_continuous(limits = c(-150, 100)) + 
  ggtitle(label = "Principal Component Analysis (PCA)",
          subtitle = "Gastric Samples distributed in 2D plane")

ddsMat_rlog <- rlog(ddsMat, blind = FALSE)
mat <- assay(ddsMat_rlog[row.names(results_sig)])[1:40, ]
mat

annotation_col = data.frame(
  Groups= factor(colData(ddsMat_rlog)$Groups),
  Replicates = factor(colData(ddsMat_rlog)$Replicates),
  row.names = colData(ddsMat_rlog)$Sampleid)

# Specify colors you want to annotate the columns by.

ann_colors = list(
  Groups = c(HEK ="red",GLI3C = "blue",GLI3T = "yellow"),
  Replicate= c(Rep1 = "darkred",Rep2="forestgreen",Rep3="grey"))

# Make Heatmap with pheatmap function.

pheatmap(mat = mat,
         color = colorRampPalette(brewer.pal(9, "YlOrBr"))(255),
         scale = "row", # Scale genes to Z-score (how many standard deviations)
         annotation_col = annotation_col, # Add multiple annotations to the samples
         annotation_colors = ann_colors,# Change the default colors of the annotations
         fontsize = 6, # Make fonts smaller
         cellwidth = , # Make the cells wider
)  
write.table(mat, file = 'topgenes_30.txt',  sep = '\t', col.names = NA)
dev.off()

# Gather Log-fold change and FDR-corrected pvalues from DESeq2 results
## - Change pvalues to -log10 (1.3 = 0.05)
data <- data.frame(gene = row.names(results),
                   pval = -log10(results$padj),
                   lfc = results$log2FoldChange)

# Remove any rows that have NA as an entry
data <- na.omit(data)

pvalue = results_sig[which(results_sig[,5]<0.05), ]

upregulated = pvalue[which(pvalue[,2]>0), ]
upregulated
write.csv(upregulated, file = "upregulated.csv")
downregulated = pvalue[which(pvalue[,2]<0), ]
downregulated
write.csv(downregulated, file = "downregulated.csv")

# Color the points which are up or down
## If fold-change > 0 and pvalue > 1.3 (Increased significant)
## If fold-change < 0 and pvalue > 1.3 (Decreased significant)

data <- mutate(data, color = case_when(data$lfc > 0 & data$pval > 1.3 ~ "Increased",
                                       data$lfc < 0 & data$pval > 1.3 ~ "Decreased",
                                       data$pval < 1.3 ~ "nonsignificant"))

# Make a basic ggplot2 object with x-y values
vol <- ggplot(data, aes(x = lfc, y = pval, color = color))

# Add ggplot2 layers
vol +  
  ggtitle(label = "Volcano Plot", subtitle = "Colored by fold-change direction") +
  geom_point(size = 2, alpha = 0.8, na.rm = T) +
  scale_color_manual(name = "Directionality",
                     values = c(Increased = "#008B00", Decreased = "#CD4F39", nonsignificant = "darkgray")) +
  theme_bw(base_size = 14) + # change overall theme
  theme(legend.position = "right") + # change the legend
  xlab(expression(log[2]("FoldChange value"))) + # Change X-Axis label
  ylab(expression(-log[10]("adjusted p-value"))) + # Change Y-Axis label
  geom_hline(yintercept = 1.3, colour = "darkgrey") + # Add p-adj value cutoff line
  scale_y_continuous(trans = "log1p") # Scale yaxis due to large p-values

plotMA(results, ylim = c(-5, 5))

plotDispEsts(ddsMat)  

results_sig <- subset(results, padj < 0.05)
write.csv(results_sig, "results_sig.csv")
