overlapMatrix <-
function(datamatrixFile, nprocs=1, pvalue_cutoff, genome_name ){
    
    
    #  datamatrixFile=read.table("datatable.txt")
    colnames(datamatrixFile)=c("name", "file")
    
    # { Read files 
    registerDoParallel(nprocs)
    bf=foreach(i=1:nrow(datamatrixFile)) %dopar% {  
        x=import.bed(as.character(datamatrixFile[i,]$file), genome=genome_name)
        #    resize(x,extension_length, fix="center")
    }
    
    names(bf) <- datamatrixFile$name
    totalBedFiles=length(bf)
    exprNames=as.character(datamatrixFile$name)
    bedsizes=unlist(lapply(bf, length))
    
    # }
    
    # { Create a merged file 
    mergedBed=GRanges()
    for (i in 1:totalBedFiles){
        mergedBed=c(mergedBed, bf[[i]])
    }
    mergedBed=reduce(mergedBed)
    names(mergedBed)=paste("mbed", seq(1,length(mergedBed)), sep=".")
    # }
    
    # { Get overlap matrix
    norm.omat=omat=matrix(0,totalBedFiles, totalBedFiles)
    omat=foreach (i=1:totalBedFiles, .combine=rbind) %dopar% {
        message("Processing row ...", exprNames[i])
        row.omat=c()
        row.norm.omat=c()
        for(j in 1:totalBedFiles){
            row.omat[j]=sum(countOverlaps(bf[[i]], bf[[j]])>0)
        }
        row.omat
    }
    rownames(omat)=colnames(omat)=exprNames
    
    for(i in 1:totalBedFiles){
        message("Processing row ...", exprNames[i])
        for(j in 1:totalBedFiles){
            norm.omat[i,j]=omat[i,j]/bedsizes[i]
        }
    }
    
    # }
    rownames(norm.omat)=colnames(norm.omat)=exprNames
    # pheatmap(norm.omat, na.rm=TRUE, cluster_rows = F, cluster_cols = F,cellwidth=10,cellheight=10, border_color="black", filename="overlap.pdf")
    
    # { Hyper geometric testing
    hyper.omat=matrix(1,totalBedFiles, totalBedFiles)
    rownames(hyper.omat)=colnames(hyper.omat)=exprNames
	
    for(i in 1:totalBedFiles){
        for(j in 1:totalBedFiles){
            overlapval=omat[i,j]
            hyper.omat[i,j]=phyper(overlapval, bedsizes[i], length(mergedBed) - bedsizes[i], bedsizes[j], lower.tail=F)
        }
    }
    
    save(hyper.omat, omat, norm.omat, mergedBed, bedsizes, datamatrixFile, totalBedFiles, exprNames, file="from_peakOverlap.RData")
    
    # write.csv(omat, file="omat.csv")
    # write.csv(hyper.omat, file="hyper_omat.csv")
    temp = hyper.omat
    temp[temp>0.1] = 0.1 
    # pheatmap(temp, na.rm=TRUE, cluster_rows = F, cluster_cols = F,cellwidth=10,cellheight=10, border_color="black", filename="hyper_omat.pdf")
    
    #}
    
    temp = norm.omat
    temp[hyper.omat>pvalue_cutoff] = 0 
    x = cor(temp)
	pheatmap(x, na.rm=TRUE, cluster_rows = T, cluster_cols = T,cellwidth=10,cellheight=10, border_color="black", filename="heatmap_corr.pdf")

    rlist=list()
    rlist[["correlationMatrix"]]=x
    rlist[['finalOverlapMatrix']] = temp
    rlist[['pvalueMatrix']] = hyper.omat
    rlist[['overlapMatrix']] = omat
    rlist[["normalisedOverlapMatrix"]] = norm.omat
    rlist[["mergedBed"]] = mergedBed
    rlist[["bedsizes"]] = bedsizes
    rlist[["dataMatrixFile"]] = datamatrixFile
    return(rlist)
    
}
