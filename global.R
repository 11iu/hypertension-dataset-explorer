library(shiny)
library(shinyjs)
library(Seurat)
library(ggplot2)
library(dplyr)
library(markdown)
library(tidyr)
library(ggthemes)
library(plotly)

imageMap <- function(inputId, imgsrc, opts, width) {
  scaled_opts <- lapply(names(opts), function(sublist) {
    lapply(sublist, function(x) {
      number_list <- as.numeric(unlist(strsplit(opts[[x]], split = ",")))
      number_list <- as.integer(number_list / 2.6) # TODO - fix the magic number
      result <- paste(number_list, collapse=",")
    })
  })
  
  names(scaled_opts) <- names(opts)
  
  areas <- lapply(names(scaled_opts), function(n) { 
    shiny::tags$area(title=n, coords=scaled_opts[[n]], 
                     href="#", shape="poly")
  })
  js <- paste0("$(document).on('click', 'map area', function(evt) {
  evt.preventDefault();
  console.log('Area clicked:', val); // Add this line for debugging
  var val = evt.target.title;
  Shiny.onInputChange('", inputId, "', val);})")
  list(
    shiny::tags$img(src=imgsrc, usemap=paste0("#", inputId), width=paste0(width, "%"), 
                    shiny::tags$head(tags$script(shiny::HTML(js)))),
    shiny::tags$map(name=inputId, areas))
}

# Some initial setup:
# this will not work if underscores are in the orig.ident (only for some views)
# take in the file, get list of genes, get metadata numbers and categories, get pcs 1-9, and factors..
aggregate_default <- readRDS("datasets/rat.sp.MSA.RNA.anno.v2.rds") # default one 
# datasets <- c('rat.ss.MSA.RNA.anno.v2.rds', 'rat.ss.LV.RNA.anno.v2.rds', 'rat.ss.LK.multiomics.anno.v2.rds', 'rat.ss.HYP.RNA.anno.rds', 'rat.sp.MSA.RNA.anno.v2.rds', 'rat.sp.MCA.RNA.anno.v2.rds', 'rat.sp.LV.RNA.anno.v2.rds', 'rat.sp.LK.multiomics.anno.v2.rds', 'rat.sp.HYP.RNA.anno.rds', 'mouse.MCA.RNA.anno.v2.rds', 'mouse.LV.RNA.anno.v2.rds', 'mouse.LK.multiomics.anno.v2.rds', 'mouse.HYP.RNA.anno.rds')
datasets <- list( 
  "Rat" = list(
    "SS" = list(
      "HYP" = "rat.ss.HYP.RNA.anno.v2.rds",
      "MCA" = "rat.ss.MCA.RNA.anno.v2.rds",
      "LV" = "rat.ss.LV.RNA.anno.v2.rds",
      "LK" = "rat.ss.LK.multiomics.anno.v2.rds",
      "MSA" = "rat.ss.MSA.RNA.anno.v2.rds"
    ),
    "SP" = list(
      "HYP" = "rat.sp.HYP.RNA.anno.v2.rds",
      "MCA" = "rat.sp.MCA.RNA.anno.v2.rds",
      "LV" = "rat.sp.LV.RNA.anno.v2.rds",
      "LK" = "rat.sp.LK.multiomics.anno.v2.rds",
      "MSA" = "rat.sp.MSA.RNA.anno.v2.rds"
    )
  ),
  "Mouse" = list(
    "Generic" = list(
      "HYP" = "mouse.HYP.RNA.anno.v2.rds",
      "MCA" = "mouse.MCA.RNA.anno.v2.rds",
      "LV" = "mouse.LV.RNA.anno.v2.rds",
      "LK" = "mouse.LK.multiomics.anno.v2.rds"
      # "MSA" = "mouse.MSA.RNA.anno.v2.rds"
    )
  )
)  
download_links <- c('https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Ess%2EMSA%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Ess%2ELV%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Ess%2ELK%2Emultiomics%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Ess%2EHYP%2ERNA%2Eanno%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Esp%2EMSA%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Esp%2EMCA%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Esp%2ELV%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Esp%2ELK%2Emultiomics%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Frat%2Esp%2EHYP%2ERNA%2Eanno%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Fmouse%2EMCA%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Fmouse%2ELV%2ERNA%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Fmouse%2ELK%2Emultiomics%2Eanno%2Ev2%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets', 'https://emailarizona-my.sharepoint.com/personal/vinodkumar1_arizona_edu/_layouts/15/onedrive.aspx?sortField=LinkFilename&isAscending=false&ct=1710442705495&or=Teams%2DHL&ga=1&download=1&id=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets%2Fmouse%2EHYP%2ERNA%2Eanno%2Erds&parent=%2Fpersonal%2Fvinodkumar1%5Farizona%5Fedu%2FDocuments%2FscRNAseq%5Fdata%2Fdatasets')
links_mapping <- setNames(download_links, datasets)

# default values
genes <- aggregate_default@assays$RNA
reductions <- attributes(aggregate_default@reductions)
meta_nums <- colnames(dplyr::select_if(aggregate_default@meta.data, is.numeric))
meta_cats <- c(colnames(dplyr::select_if(aggregate_default@meta.data, is.character)), 
               colnames(dplyr::select_if(aggregate_default@meta.data, is.factor)),
               colnames(dplyr::select_if(aggregate_default@meta.data, is.logical)))
meta_cats <- meta_cats[meta_cats != "orig.ident"]
mysplitbydefault <- "major_cluster"

default_reduction <- "umap"
default_animal <- "Rat"
default_strain <- "SP"
default_tissue <- "MSA"

aggregate <- reactiveVal()

#mysplitbydefault <- "CellType"
pcs <- c('PC_1','PC_2','PC_3','PC_4','PC_5','PC_6','PC_7','PC_8','PC_9')
use.pcs <- 1:50
#agg_cats <- colnames(dplyr::select_if(aggregate@meta.data, is.factor))

imgsrc <- "mouse_diagram.png"
mapopts <- list(HYP="439,138,404,161,389,186,391,202,416,206,442,206,469,202,484,197,490,178,474,151",
                MCA="391,211,386,234,381,260,383,275,421,279,500,277,504,204",
                LV="408,404,409,454,464,462,497,432,476,401",
                LK="497,445,476,465,489,509,527,498,522,456",
                MSA="406,470,393,531,396,579,499,567,467,470")