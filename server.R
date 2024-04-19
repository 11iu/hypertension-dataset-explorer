function(input, output, session){
  
  # update dataset based on selection from ui
  aggregate <- reactive({
    readRDS(paste("datasets/", datasets[[input$animal_multi]][[input$species_multi]][[input$tissue_multi]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_markerset]][[input$species_markerset]][[input$tissue_markerset]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_multifea]][[input$species_multifea]][[input$tissue_multifea]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_cluster]][[input$species_cluster]][[input$tissue_cluster]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_sepfea]][[input$species_sepfea]][[input$tissue_sepfea]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_sepcat]][[input$species_sepcat]][[input$tissue_sepcat]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_marktab]][[input$species_marktab]][[input$tissue_marktab]], sep=""))
    readRDS(paste("datasets/", datasets[[input$animal_download]][[input$species_download]][[input$tissue_download]], sep=""))
  })
  
  
  # update values based on input from ui
  outVar_double = reactive({
    mydata = switch(input$subset_multi, 
                    'Genes' = rownames(genes),
                    'Numeric Metadata' = meta_nums,
                    "PCs" = pcs
    )
    mydata
  })
  
  # update values based on input from ui
  outVar_seperated = reactive({
    mydata = switch(input$subset_seperated, 
                    'Genes' = rownames(genes),
                    'Numeric Metadata' = meta_nums,
                    "PCs" = pcs
    )
    mydata
  })

  getResChoices = reactive({
    mydata = levels(eval(call("$", aggregate(), input$identity_table)))
    mydata
  })
  
  species_multi_choices <- reactive({
    return(names(datasets[[input$animal_multi]]))
  })
  
  tissue_multi_choices <- reactive({
    return(names(datasets[[input$animal_multi]][[input$species_multi]]))
  })
  
  species_markerset_choices <- reactive({
    req(input$animal_markerset)
    return(names(datasets[[input$animal_markerset]]))
  })
  
  tissue_markerset_choices <- reactive({
    req(input$animal_markerset, input$species_markerset)
    return(names(datasets[[input$animal_markerset]][[input$species_markerset]]))
  })
  
  species_multifea_choices <- reactive({
    req(input$animal_multifea)
    return(names(datasets[[input$animal_multifea]]))
  })
  
  tissue_multifea_choices <- reactive({
    req(input$animal_multifea, input$species_multifea)
    return(names(datasets[[input$animal_multifea]][[input$species_multifea]]))
  })
  
  species_cluster_choices <- reactive({
    req(input$animal_cluster)
    return(names(datasets[[input$animal_cluster]]))
  })
  
  tissue_cluster_choices <- reactive({
    req(input$animal_cluster, input$species_cluster)
    return(names(datasets[[input$animal_cluster]][[input$species_cluster]]))
  })
  
  species_sepfea_choices <- reactive({
    req(input$animal_sepfea)
    return(names(datasets[[input$animal_sepfea]]))
  })
  
  tissue_sepfea_choices <- reactive({
    req(input$animal_sepfea, input$species_sepfea)
    return(names(datasets[[input$animal_sepfea]][[input$species_sepfea]]))
  })
  
  species_sepcat_choices <- reactive({
    req(input$animal_sepcat)
    return(names(datasets[[input$animal_sepcat]]))
  })
  
  tissue_sepcat_choices <- reactive({
    req(input$animal_sepcat, input$species_sepcat)
    return(names(datasets[[input$animal_sepcat]][[input$species_sepcat]]))
  })
  
  species_marktab_choices <- reactive({
    req(input$animal_marktab)
    return(names(datasets[[input$animal_marktab]]))
  })
  
  tissue_marktab_choices <- reactive({
    req(input$animal_marktab, input$species_marktab)
    return(names(datasets[[input$animal_marktab]][[input$species_marktab]]))
  })
  
  species_download_choices <- reactive({
    req(input$animal_download)
    return(names(datasets[[input$animal_download]]))
  })
  
  tissue_download_choices <- reactive({
    req(input$animal_download, input$species_download)
    return(names(datasets[[input$animal_download]][[input$species_download]]))
  })
  
  observe({
    updateSelectInput(session, "animal_multi", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_multi", choices = species_multi_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_multi", choices = tissue_multi_choices())
  })
  
  # Observe statements for 'markerset'
  observe({
    updateSelectInput(session, "animal_markerset", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_markerset", choices = species_markerset_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_markerset", choices = tissue_markerset_choices())
  })
  
  # Observe statements for 'multifea'
  observe({
    updateSelectInput(session, "animal_multifea", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_multifea", choices = species_multifea_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_multifea", choices = tissue_multifea_choices())
  })
  
  # Observe statements for 'cluster'
  observe({
    updateSelectInput(session, "animal_cluster", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_cluster", choices = species_cluster_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_cluster", choices = tissue_cluster_choices())
  })
  
  # Observe statements for 'sepfea'
  observe({
    updateSelectInput(session, "animal_sepfea", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_sepfea", choices = species_sepfea_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_sepfea", choices = tissue_sepfea_choices())
  })
  
  # Observe statements for 'sepcat'
  observe({
    updateSelectInput(session, "animal_sepcat", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_sepcat", choices = species_sepcat_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_sepcat", choices = tissue_sepcat_choices())
  })
  
  # Observe statements for 'marktab'
  observe({
    updateSelectInput(session, "animal_marktab", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_marktab", choices = species_marktab_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_marktab", choices = tissue_marktab_choices())
  })
  
  # Observe statements for 'download'
  observe({
    updateSelectInput(session, "animal_download", choices = names(datasets))
  })
  
  observe({
    updateSelectInput(session, "species_download", choices = species_download_choices())
  })
  
  observe({
    updateSelectInput(session, "tissue_download", choices = tissue_download_choices())
  })
  
  # Reduction Type for the Multiple Marker Plot
  observe({
    updateSelectInput(session, "reduction_multi", choices = reductions)
  })
  
  # Primary numeric value in the multiple marker plot
  observe({
    updateSelectizeInput(session, "multi_numeric", choices = outVar_double(), server = TRUE)
  })
  
  
  # Cluster Tree identity
  observe({
    updateSelectInput(session, "identity_tree", choices = meta_cats)
  })
  
  # Seperated Identity
  observe({
    updateSelectInput(session, "identity_seperated", choices = meta_cats)
  })
  
  # Seperated Numeric
  observe({
    updateSelectizeInput(session, "numeric_seperated", choices = outVar_seperated(), server = TRUE)
  })
  
  # Seperated Reduction
  observe({
    updateSelectInput(session, "reduction_seperated", choices = reductions, selected=default_reduction)
  })

  # Seperated categroical Identity
  observe({
    updateSelectInput(session, "identity_seperated_cateogrical", choices = meta_cats)
  })
  
  # Seperated categorical identity2
  observe({
    updateSelectInput(session, "identity2_seperated_categorical", choices = meta_cats)
  })
  
  # Seperated categorical Reduction
  observe({
    updateSelectInput(session, "reduction_seperated_categorical", choices = reductions, selected=default_reduction)
  })
  
  
  # Numeric input list for the marker set
  observe({
    updateSelectizeInput(session, "numeric_b", choices = rownames(genes), server = TRUE)
  })
  
  
  # Multiple Feature Plot
  observe({
    updateSelectizeInput(session, "multiple_feature_list", choices = rownames(genes), server = TRUE)
  })
  
  
  # Table Identity
  observe({
    updateSelectInput(session, "identity_table", choices = meta_cats)
  })
  
  
  # Table Marker
  observe({
    updateSelectInput(session, "compare_table", choices = getResChoices())
  })
  
  # Table Compare
  observe({
    updateSelectInput(session, "markers_table", choices = getResChoices())
  })
  

  # Documentation
  output$markdown <- renderUI({
    includeMarkdown("README.md")
  }) 
  
  multi_marker_gene_plot_list <- reactive({
    result <- list()
    for (i in seq_along(input$multi_numeric)) {
      temp_aggregate <- aggregate()
      result[[i]] = ggplotly(FeaturePlot(temp_aggregate, input$multi_numeric[[i]], blend=FALSE, reduction=input$reduction_multi) + 
                               theme_minimal())
    }
    result
  })
  
  # Marker Plot multiple
  output$MarkerGenePlotMulti <- renderUI({
    plot_output_list <- lapply(seq_along(multi_marker_gene_plot_list()), function(i) {
      div(style="display: inline-block; width: 49%", plotlyOutput(outputId = paste("multi_marker_gene_plot", i, sep = "_"))) # make placeholder name plot_i for each plot
    })
    do.call(tagList, plot_output_list) # combines plotlyOutputs
    
  })
  
  # Render each multi gene plot's graph
  observe({
    lapply(seq_along(multi_marker_gene_plot_list()), function(i) {
      output[[paste("multi_marker_gene_plot", i, sep = "_")]] <- renderPlotly({
        multi_marker_gene_plot_list()[[i]]
      })
    })
  })
  
  
  # Multi Feature Categorical Feature Plot
  output$CategoricalPlotMulti <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$categorical_multi
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- DimPlot(object = temp_aggregate, pt.size=0.5, reduction = input$reduction_multi, label = T, repel = TRUE) +
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Multiple marker violin plot
  multi_marker_vln_plot_list <- reactive({
    result <- list()
    for (i in seq_along(input$multi_numeric)) {
      temp_aggregate <- aggregate()
      Idents(temp_aggregate) <- input$categorical_multi
      order <- sort(levels(temp_aggregate))
      levels(temp_aggregate) <- order
      result[[i]] = ggplotly(VlnPlot(object = temp_aggregate, features = input$multi_numeric[[i]], pt.size = 0.05) + 
                               theme_minimal())
    }
    result
  })
  
  output$ViolinPlotMulti <- renderUI({
    plot_output_list <- lapply(seq_along(multi_marker_vln_plot_list()), function(i) {
      div(style="display: inline-block; width: 49%", plotlyOutput(outputId = paste("multi_marker_vln_plot", i, sep = "_"))) # make placeholder name plot_i for each plot
    })
    do.call(tagList, plot_output_list) # combines plotlyOutputs
    
  })
  
  # Render each feature's graph
  observe({
    lapply(seq_along(multi_marker_vln_plot_list()), function(i) {
      output[[paste("multi_marker_vln_plot", i, sep = "_")]] <- renderPlotly({
        multi_marker_vln_plot_list()[[i]]
      })
    })
  })
  
  
  # Cluster Tree Plot
  output$ClusterTree <- renderPlot({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_tree
    temp_aggregate <- BuildClusterTree(
      temp_aggregate, dims = use.pcs)
    PlotClusterTree(temp_aggregate) 
  })
  
  # create list of plotly plots for each feature in multifeaturelist
  multi_feature_plot_list <- reactive({
    result <- list()
    for (i in seq_along(input$multiple_feature_list)) {
      temp_aggregate <- aggregate()
      result[[i]] = ggplotly(FeaturePlot(temp_aggregate, input$multiple_feature_list[[i]], blend=FALSE, reduction=input$multiple_feature_reduction) + 
                                 theme_minimal())
    }
    result
  })
  
  # Multiple Feature Plot
  output$MultipleFeaturePlot <- renderUI({
    plot_output_list <- lapply(seq_along(multi_feature_plot_list()), function(i) {
      div(style="display: inline-block", plotlyOutput(outputId = paste("multi_feature_plot", i, sep = "_"))) # make placeholder name plot_i for each plot
    })
    do.call(tagList, plot_output_list) # combines plotlyOutputs
  })
  
  # Render each feature's graph
  observe({
    lapply(seq_along(multi_feature_plot_list()), function(i) {
      output[[paste("multi_feature_plot", i, sep = "_")]] <- renderPlotly({
        multi_feature_plot_list()[[i]]
      })
    })
  })
  
  # Multiple Feature Categorical Plot
  output$MultipleFeatureCategoricalPlot <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$multiple_feature_categorical_plot
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- DimPlot(object = temp_aggregate, group.by=input$multiple_feature_categorical_plot, pt.size=0.5, reduction = input$multiple_feature_reduction, label = T, repel = TRUE) + 
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Seperated Identity Categorical Plot
  output$SeperatedIdentityCategorical <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated_categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- DimPlot(temp_aggregate, reduction=input$reduction_seperated_categorical, split.by = mysplitbydefault, ncol=4) +
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Seperated Identity 2 Categorical Plot
  output$SeperatedIdentity2Categorical <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity2_seperated_categorical
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- DimPlot(temp_aggregate, reduction=input$reduction_seperated_categorical, split.by = mysplitbydefault, ncol=4) +
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Seperated Categorical table
  output$SeperatedCountsCategorical <- renderPlotly({
    temp_aggregate <- aggregate()
    length_data = as.data.frame(prop.table(table(eval(call('$', temp_aggregate[[]], input$identity_seperated_categorical)), 
                                                 eval(call('$', temp_aggregate[[]], input$identity2_seperated_categorical))),1))
    colnames(length_data) = c(input$identity_seperated_categorical, input$identity2_seperated_categorical, 'Freq')
    mycol <- c("navy", "blue", "cyan", "lightcyan", "yellow", "red", "red4")
    p <- ggplot(length_data, aes_string(x=input$identity_seperated_categorical, y=input$identity2_seperated_categorical, fill='Freq')) + 
      geom_tile() + 
      scale_fill_gradientn(colours = mycol) +
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Seperated Feature Plot
  output$SeperatedFeature <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- FeaturePlot(temp_aggregate, c(input$numeric_seperated), reduction = input$reduction_seperated, split.by = input$identity_seperated2, ncol=4) + 
      theme_minimal()
    ggplotly(p)
  })
  
  # Separated Dim Plot
  output$SeperatedDim <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- DimPlot(temp_aggregate, reduction=input$reduction_seperated, split.by = input$identity_seperated2, ncol=4) +
      theme_minimal()
    ggplotly(p)
  })
  
  # Separated Violin Plot
  output$SeperatedViolin <- renderPlotly({
    temp_aggregate <- aggregate()
    Idents(temp_aggregate) <- input$identity_seperated
    order <- sort(levels(temp_aggregate))
    levels(temp_aggregate) <- order
    p <- VlnPlot(temp_aggregate, c(input$numeric_seperated), group.by = input$identity_seperated, split.by = input$identity_seperated2, ncol=4) +
      theme_minimal()
    ggplotly(p)
  })
  
  
  # Separated Counts table
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
  
  observeEvent(input$download_link, {
    link <- links_mapping[input$dataset_download]
    shinyjs::runjs(paste0('window.open("', link, '", "_blank");'))
  })
  
  # descriptions
  
  output$multiMarkerDescription <- renderText({
    text <- "Multiple Marker Description"
  })
  
  output$markerSetDescription <- renderText({
    text <- "Marker set Description"
  })
  
  output$multiFeatureDescription <- renderText({
    text <- "Multiple Feature Description"
  })
  
  output$clusterTreeDescription <- renderText({
    text <- "Cluster Tree Description"
  })
  
  output$seperatedFeatureDescription <- renderText({
    text <- "Seperated Feature Description"
  })
  
  output$seperatedCatDescription <- renderText({
    text <- "Seperated Categorical Description"
  })
  
  output$markerTableDescription <- renderText({
    text <- "Marker Table Description"
  })
  
  
  # Potential to do, add DimPlot or HeatMap
}
