# Some initial setup:
# this will not work if underscores are in the orig.ident (only for some views)
# take in the file, get list of genes, get metadata numbers and categories, get pcs 1-9, and factors..
aggregate <- readRDS('datasets/mouse.MCA.RNA.anno.v2.rds') # default one
datasets <- c('rat.ss.MSA.RNA.anno.v2.rds', 'rat.ss.LV.RNA.anno.v2.rds', 'rat.ss.HYP.RNA.anno.rds', 'rat.sp.MSA.RNA.anno.v2.rds', 'rat.sp.MCA.RNA.anno.v2.rds', 'rat.sp.LV.RNA.anno.v2.rds', 'rat.sp.LK.multiomics.anno.v2.rds', 'mouse.MCA.RNA.anno.v2.rds', 'mouse.LV.RNA.anno.v2.rds', 'mouse.LK.multiomics.anno.v2.rds', 'mouse.HYP.RNA.anno.rds')
download_links <- c('test1', 'test2', 'test3', 'test4', 'test5', 'test6', 'test7', 'test8', 'test9', 'test10', 'test11')
links_mapping <- setNames(download_links, datasets)

# default values
genes <- aggregate@assays$RNA
reductions <- attributes(aggregate@reductions)
meta_nums <- colnames(dplyr::select_if(aggregate@meta.data, is.numeric))
meta_cats <- c(colnames(dplyr::select_if(aggregate@meta.data, is.character)), 
               colnames(dplyr::select_if(aggregate@meta.data, is.factor)),
               colnames(dplyr::select_if(aggregate@meta.data, is.logical)))
meta_cats <- meta_cats[meta_cats != "orig.ident"]
mysplitbydefault <- "major_cluster"

#mysplitbydefault <- "CellType"
#pcs <- list('PC_1','PC_2','PC_3','PC_4','PC_5','PC_6','PC_7','PC_8','PC_9')
pcs <- c('PC_1','PC_2','PC_3','PC_4','PC_5','PC_6','PC_7','PC_8','PC_9')
use.pcs <- 1:50
#agg_cats <- colnames(dplyr::select_if(aggregate@meta.data, is.factor))
# TODO get reduction types as a list to choose from