library(shiny)
library(Seurat)
library(ggplot2)
library(dplyr)
library(markdown)
library(tidyr)
library(ggthemes)
library(plotly)

function(input, output, session){
  
  # update dataset based on selection from ui
  aggregate <- reactive({
    readRDS(paste("datasets/", input$dataset_double, sep=""))
    readRDS(paste("datasets/", input$dataset_single, sep=""))
    readRDS(paste("datasets/", input$dataset_markset, sep=""))
    readRDS(paste("datasets/", input$dataset_multifea, sep=""))
    readRDS(paste("datasets/", input$dataset_cluster, sep=""))
    readRDS(paste("datasets/", input$dataset_sepfea, sep=""))
    readRDS(paste("datasets/", input$dataset_sepcat, sep=""))
    readRDS(paste("datasets/", input$dataset_marktab, sep=""))
  })
  
  # update values based on input from ui
  outVar_single = reactive({
    if (input$subset_single == 'Genes'){mydata=rownames(genes)}
    else if (input$subset_single == 'Numeric Metadata') {mydata=meta_nums}
    else if (input$subset_single == 'PCs') {mydata=pcs}
    mydata
  })
  
  # update values based on input from ui
  outVar_double = reactive({
    if (input$subset_double == 'Genes'){mydata=rownames(genes)}
    else if (input$subset_double == 'Numeric Metadata') {mydata=meta_nums}
    else if (input$subset_double == 'PCs') {mydata=pcs}
    mydata
  })
  
  # update values based on input from ui
  outVar_seperated = reactive({
    if (input$subset_seperated == 'Genes'){mydata=rownames(genes)}
    else if (input$subset_seperated == 'Numeric Metadata') {mydata=meta_nums}
    else if (input$subset_seperated == 'PCs') {mydata=pcs}
    mydata
  })

  getResChoices = reactive({
    mydata = levels(eval(call("$", aggregate(), input$identity_table)))
    mydata
  })
  
  # Reduction Type for the Single Marker Plot
  observe({
    updateSelectInput(session, "reduction_single",
                      choices = reductions
    )})
  
  # Reduction Type for the Double Marker Plot
  observe({
    updateSelectInput(session, "reduction_double",
                      choices = reductions
    )})
  
  # Primary numeric value in the double marker plot
  observe({
    updateSelectInput(session, "numeric",
                      choices = outVar_double()
    )})
  
  # Secondary numeric value in the double marker plot
  observe({
    updateSelectInput(session, "numeric2",
                      choices = outVar_double()
    )})
  
  # Numeric input list for the marker set (multiple =TRUE)
  observe({
    updateSelectizeInput(session, "numeric_b",
                      choices = rownames(genes), server = TRUE
    )})
  
  # Only numeric input for the single marker plot
  observe({
    updateSelectInput(session, "numeric_single",
                      choices = outVar_single()
    )})
  
  # Cluster Tree identity
  observe({
    updateSelectInput(session, "identity_tree",
                      choices = meta_cats
    )})
  
  
  # Seperated Identity
  observe({
    updateSelectInput(session, "identity_seperated",
                      choices = meta_cats
    )})
  
  # Seperated Numeric
  observe({
    updateSelectInput(session, "numeric_seperated",
                      choices = outVar_seperated()
    )})
  
  # Seperated Reduction
  observe({
    updateSelectInput(session, "reduction_seperated",
                      choices = reductions
    )})

  
  
  # Seperated categroical Identity
  observe({
    updateSelectInput(session, "identity_seperated_cateogrical",
                      choices = meta_cats
    )})
  
  # Seperated categorical identity2
  observe({
    updateSelectInput(session, "identity2_seperated_categorical",
                      choices = meta_cats
    )})
  
  # Seperated categorical Reduction
  observe({
    updateSelectInput(session, "reduction_seperated_categorical",
                      choices = reductions
    )})
  
  
    
  # Multiple Feature Plot
  observe({
    updateSelectizeInput(session, "multiple_feature_list",
                      choices = rownames(genes), server = TRUE
    )})
  
  # Table Identity
  observe({
    updateSelectInput(session, "identity_table",
                      choices = meta_cats
    
    )})
  
  
  # Table Marker
  observe({
    updateSelectInput(session, "compare_table",
                      choices = getResChoices()
    )})
  
  # Table Compare
  observe({
    updateSelectInput(session, "markers_table",
                      choices = getResChoices()
    )})
  

  # Documentation
  output$markdown <- renderUI({
    includeMarkdown("README.md")
  }) 
  
  # Marker Plot Double
  output$MarkerGenePlot <- renderPlot({
    temp_aggregate <- aggregate()
    
    FeaturePlot(
      temp_aggregate,
      c(input$numeric, input$numeric2),
      reduction=input$reduction_double
    )
  })

  
  # Marker Plot Single
  output$MarkerGenePlotSingle <- renderPlot({
    temp_aggregate <- aggregate()
    
    FeaturePlot(
      temp_aggregate,
      c(input$numeric_single),
      reduction=input$reduction_single
    )
  })
  
  
  # Double Feature Categorical Feature Plot
  output$CategoricalPlot <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(object = temp_aggregate, pt.size=0.5, reduction = input$reduction_double, label = T)
  })
  
  
  # Single Feature Categorical Feature Plot
  output$CategoricalPlotSingle <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical_single
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(object = temp_aggregate, group.by=input$categorical_single, pt.size=0.5, reduction = input$reduction_single, label = T)
  })
  
  
  # Double Feature Violin Plot
  output$ViolinPlot <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    VlnPlot(object = temp_aggregate, features = c(input$numeric, input$numeric2), pt.size = 0.05)
  })
  
  
  # Single Feature Violin Plot
  output$ViolinPlotSingle <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical_single
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    VlnPlot(object = temp_aggregate, features = c(input$numeric_single), pt.size = 0.05)
  })
  
  
  # Cluster Tree Plot
  output$ClusterTree <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_tree
    temp_aggregate <- BuildClusterTree(
      temp_aggregate, dims = use.pcs)
    PlotClusterTree(temp_aggregate)
  })
  
  
  # Multiple Feature Plot
  output$MultipleFeaturePlot <- renderPlot({
    temp_aggregate <- aggregate()
    FeaturePlot(
      temp_aggregate,
      input$multiple_feature_list,
      blend=FALSE,
      reduction=input$multiple_feature_reduction,
      ncol=4
    )
  })
  
  
  # Multiple Feature Categorical Plot
  output$MultipleFeatureCategoricalPlot <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$multiple_feature_categorical_plot
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(object = temp_aggregate, group.by=input$multiple_feature_categorical_plot, pt.size=0.5, reduction = input$multiple_feature_reduction, label = T)
    })
  
  
  # Seperated Identity Categorical Plot
  output$SeperatedIdentityCategorical <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated_categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(temp_aggregate, reduction=input$reduction_seperated_categorical,
            split.by = mysplitbydefault, ncol=4
    )
  })
  
  
  # Seperated Identity 2 Categorical Plot
  output$SeperatedIdentity2Categorical <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity2_seperated_categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(temp_aggregate, reduction=input$reduction_seperated_categorical,
            split.by = mysplitbydefault, ncol=4
    )
  })
  
  
  # Seperated Categorical table
  output$SeperatedCountsCategorical <- renderPlot({
    temp_aggregate <- aggregate()
    length_data = as.data.frame(prop.table(table(eval(call('$', temp_aggregate[[]], input$identity_seperated_categorical)), 
                                                 eval(call('$', temp_aggregate[[]], input$identity2_seperated_categorical))),1))
    colnames(length_data) = c(input$identity_seperated_categorical, input$identity2_seperated_categorical, 'Freq')
    mycol <- c("navy", "blue", "cyan", "lightcyan", "yellow", "red", "red4")
    ggplot(length_data, aes_string(x=input$identity_seperated_categorical, y=input$identity2_seperated_categorical, fill='Freq')) + geom_tile() + scale_fill_gradientn(colours = mycol)
  })
  
  
  # Seperated Feature Plot
  output$SeperatedFeature <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    FeaturePlot(temp_aggregate, c(input$numeric_seperated), reduction=input$reduction_seperated,
      split.by = input$identity_seperated2, ncol=4
    )
  })
  
  # Seperated Dim Plot
  output$SeperatedDim <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    DimPlot(temp_aggregate, reduction=input$reduction_seperated,
                split.by = input$identity_seperated2, ncol=4
    )
  })
  # Seperated Violin Plot
  output$SeperatedViolin <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    VlnPlot(temp_aggregate, c(input$numeric_seperated), group.by = input$identity_seperated, split.by = input$identity_seperated2, ncol=4)
  })
  
  
  # Seperated Counts table
  output$SeperatedCounts <- renderTable({
    temp_aggregate <- aggregate()
    marker = c(input$numeric_seperated)
    Idents(temp_aggregate) <- input$identity_seperated
    
    if(input$subset_seperated == 'Numeric Metadata'){
      nm <- data.frame(matrix(unlist(eval(call('$', temp_aggregate, marker[1]))), nrow=length(eval(call('$', temp_aggregate, marker[1]))), byrow=T))
      colnames(nm) = marker
      rownames(nm) = labels(eval(call('$', temp_aggregate, marker[1])))
      widedat <- nm
    }
    else{widedat <- FetchData(temp_aggregate, marker)}
    
    widedat$Cluster <- Idents(temp_aggregate)
    widedat[[mysplitbydefault]] = eval(call("$", temp_aggregate, input$identity_seperated2))
    widedat$final = paste(widedat[[mysplitbydefault]], widedat$Cluster, sep="_")
    final_object = (temp_aggregate(widedat[, 1:2], list(widedat$final), mean)[1:2])
    lab_list = widedat[[mysplitbydefault]]
    identities = widedat$Cluster
    
    num_list = widedat[[marker]]
    
    # df needs to be fixed
    tmp_df = data.frame(identities, num_list, lab_list)
    df = as.data.frame(pivot_wider(temp_aggregate(tmp_df[2], list(tmp_df$identities, tmp_df$lab_list), mean), names_from = Group.2, values_from = num_list))
    df[is.na(df)] <- 0
    rownames(df) = df$Group.1
    drops <- c("Group.1")
    df = df[ , !(names(df) %in% drops)]
    
    df_p = as.data.frame.matrix(prop.table((table(eval(call("$", temp_aggregate, input$identity_seperated)), eval(call("$", temp_aggregate, input$identity_seperated2)))),2))
    df_p=df_p/colSums(df_p)

    merged_final = as.data.frame.matrix(merge(df, df_p, by.x = 'row.names', by.y = 'row.names', suffixes = c(".AvgExpression",".Proportion")))
    merged_final
  }, width = "100%", colnames=TRUE, rownames=TRUE, digits=4)
  
  
  # Marker Table
  output$markers <- renderTable({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_table
    if (as.logical(length(c(input$compare_table)))){FindMarkers(temp_aggregate, ident.1=input$markers_table, ident.2=input$compare_table)}
    else {FindMarkers(temp_aggregate, ident.1=input$markers_table)}
  }, rownames = TRUE, colnames = TRUE, width = "100%", digits=-5)
  
  # Marker Set Plot
  output$MarkerSet <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical_b
    markers = input$numeric_b
    expr.cutoff = 1
    widedat <- FetchData(temp_aggregate, markers)
    widedat$Cluster <- Idents(temp_aggregate)
    longdat <- gather(widedat, key = "Gene", value = "Expression", -Cluster)
    longdat$Is.Expressed <- ifelse(longdat$Expression > expr.cutoff, 1, 0)
    longdat$Cluster <- factor(longdat$Cluster)
    longdat$Gene <- factor(longdat$Gene, levels = markers)
    
    # Need to summarize into average expression, pct expressed (which is also an average)
    plotdat <- group_by(longdat, Gene, Cluster) %>% summarize(`Percentage of Expressed Cells` = mean(Is.Expressed), `Mean Expression` = mean(Expression))
    ggplot(plotdat, aes(x = Gene, y = Cluster)) +
      geom_point(aes(size = `Percentage of Expressed Cells`, col = `Mean Expression`)) +
      labs(size = "Percentage\nof Expressed\nCells", col = "Mean\nExpression", x = NULL) +
      scale_color_gradient(low = "grey", high = "slateblue4") + theme_grey(base_size = 15) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    # }, height = 1000, width = 900 )
  }, height = 1000)
  
  # Potential to do, add DimPlot or HeatMap
}