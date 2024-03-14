fluidPage(
  titlePanel("scRNA data of Mouse and Rat for Hypertension"),
  sidebarLayout(
    sidebarPanel(width = 12,
                 tabsetPanel(
                   tabPanel("Documentation", value=1,
                            uiOutput('markdown')
                   ),
                   
                   tabPanel("Single Marker", value=2,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("dataset_single", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("subset_single", "Numeric Analysis Type:",
                                            c('Numeric Metadata', 'Genes','PCs'))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("reduction_single", "Reduction:",
                                            c(reductions))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("categorical_single", "Identity:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("numeric_single", "Primary Numeric:", "")),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      plotOutput("MarkerGenePlotSingle"),
                                      plotOutput("ViolinPlotSingle"),
                                      plotOutput("CategoricalPlotSingle")
                            )
                   ),
                   tabPanel("Double Marker", value=3,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("dataset_double", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("subset_double", "Numeric Analysis Type:",
                                            c('Numeric Metadata', 'Genes','PCs'))),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("reduction_double", "Reduction:",
                                            c(reductions))),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("categorical", "Identity:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("numeric", "Primary Numeric:", "")),
                            
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput('numeric2', 'Secondary Numeric', "")),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      plotOutput("MarkerGenePlot"),
                                      plotOutput("ViolinPlot"),
                                      plotOutput("CategoricalPlot")
                            )
                   ),
                   tabPanel("Marker Set (Grid)", value=4,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("dataset_markset", "Dataset",
                                            c(datasets))),
                            selectInput("categorical_b", "Identity:",
                                        c(meta_cats)),
                            selectizeInput("numeric_b", "Primary Numeric: csv format accepted", 
                                           choices = NULL, multiple = TRUE, options = list(
                                             maxItems=16,
                                             delimiter = ',',
                                             create = I("function(input, callback){
                                                               return {
                                                                 value: input,
                                                                 text: input
                                                                };
                                              }"))),
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      plotOutput("MarkerSet")
                            )
                   ),
                   tabPanel("Multiple Feature Plot", value=5,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 19%;",
                                selectInput("dataset_multifea", "Dataset",
                                            c(datasets))),
                            selectInput("multiple_feature_categorical_plot", "Identity:",
                                        c(meta_cats)),
                            selectInput("multiple_feature_reduction", "Reduction:",
                                        c(reductions)),
                            selectizeInput("multiple_feature_list", "Primary Numeric: csv format accepted, 5-16 features optimal",
                                           choices = NULL, multiple = TRUE, options = list(
                                                              maxItems=16,
                                                              delimiter = ',',
                                                              create = I("function(input, callback){
                                                               return {
                                                                 value: input,
                                                                 text: input
                                                                };
                                                             }"))),
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      plotOutput("MultipleFeatureCategoricalPlot"),
                                      plotOutput("MultipleFeaturePlot",  height = "1000px")
                            )
                   ),
                   tabPanel("Cluster Tree", value=6,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("dataset_cluster", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("identity_tree", "Identity:",
                                            c(meta_cats))),
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      plotOutput("ClusterTree"),
                            )
                   ),
                   tabPanel("Seperated Feature", value=7,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectInput("dataset_sepfea", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectInput("subset_seperated", "Numeric Analysis Type:",
                                            c('Genes', 'Numeric Metadata','PCs'))),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectInput("reduction_seperated", "Reduction:",
                                            c(reductions))),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectInput("identity_seperated", "Cell Type/Cluster:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectInput("identity_seperated2", "Identity:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 20%;",
                                selectizeInput("numeric_seperated", "Primary Numeric:", "")),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      plotOutput("SeperatedFeature", height = "500px"),
                                      plotOutput("SeperatedDim"),
                                      plotOutput("SeperatedViolin", width="2000px"),
                                      tableOutput("SeperatedCounts")
                                      
                            )
                   ),
                   tabPanel("Seperated Categorical", value=8,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("dataset_sepcat", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("reduction_seperated_categorical", "Reduction:",
                                            c(reductions))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("identity_seperated_categorical", "Identity:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("identity2_seperated_categorical", "Secondary Identity:", "")),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      plotOutput("SeperatedIdentityCategorical", height = "500px"),
                                      plotOutput("SeperatedIdentity2Categorical"),
                                      plotOutput("SeperatedCountsCategorical")
                                      
                            )
                   ),
                   tabPanel("Marker Table", value=9,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("dataset_marktab", "Dataset",
                                            c(datasets))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("identity_table", "Identity:",
                                            c(meta_cats))),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("markers_table", "Get markers for:", "", multiple = TRUE)),
                            
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("compare_table", "Compare to (blank is all other groups):", "", multiple = TRUE)),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      #h3(textOutput("caption")),
                                      tableOutput("markers")
                            )
                   ), 
                   tabPanel("Download", value=10,
                            br(),
                            div(style="display: inline-block;vertical-align:top; width: 24%;",
                                selectInput("dataset_download", "Dataset",
                                            c(datasets))),
                            
                            mainPanel(width = 12,
                                      br(),
                                      br(),
                                      h2("Dataset (.rds format)"),
                                      br(),
                                      textOutput("download_link")
                            )
                   )
                 )
    ),
    mainPanel(width = 12)
  )
)
