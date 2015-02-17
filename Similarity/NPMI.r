

M = as.matrix( read.table( 'matrix_MPromDB_mm9_promoters.txt', header=TRUE, sep = "\t", row.names = 1, as.is=TRUE ) ) ;

MI = matrix( ,ncol(M), ncol(M) ) ;

for ( i in 1:ncol(M) ) {
   for ( j in 1:i ) {
   
      C = sum( M[,i]*M[,j] ) ;
      MI[i,j] = C*( log2(C) - log2(sum(M[,i])) -log2(sum(M[,j])) ) ;
      MI[j,i] = MI[i,j] ;

   }#endif
}#endif

MI[is.nan(MI)] = 0 ;
MI_norm = MI/sqrt( diag(MI)%*%t(diag(MI)) ) ;
MI_norm[is.nan(MI_norm)] = 0 ;
C = cor( MI_norm ) ;
C[is.nan(C)] = 0 ;

library(gplots)
library(cba)
library(RColorBrewer)

rownames(C) = colnames(C) = colnames( M )

c_mat <- data.matrix( C, rownames.force = NA )

d <- dist( c_mat, method = "euclidean")

hc <- hclust(d, method = "complete", members=NULL)

co <- order.optimal(d, hc$merge)

ho <- hc

ho$merge <- co$merge

ho$order <- co$order

pdf("heatmap.pdf")

heatmap.2(
c_mat,
Rowv = as.dendrogram(ho),
Colv = as.dendrogram(ho), trace=c("none"),
margins=c(14,14),
key = TRUE,
density.info=c("none"),
sepwidth=c(0.01, 0.01),
sepcolor="black",
colsep=1:ncol(c_mat),
rowsep=1:nrow(c_mat),
symkey=T,
symbreaks=T,
scale='none',
col = colorRampPalette(rev(brewer.pal(n = 11, name = "RdYlBu")))(100)
)

dev.off()
