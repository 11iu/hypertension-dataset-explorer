fluidPage(
  useShinyjs(),
  titlePanel("scRNA data of Mouse and Rat for Hypertension"),
  sidebarLayout(
    sidebarPanel(width = 12,
                 tabsetPanel(
                   tabPanel("Documentation", value=1,
                            uiOutput('markdown')
                   ),
                   
                   tabPanel("Multiple Marker", value=2,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_multi", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_multi", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_multi", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("subset_multi", "Numeric Analysis Type:",
                                              c('Genes', 'Numeric Metadata', 'PCs'))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("reduction_multi", "Reduction:",
                                              c(reductions), selected = default_reduction)),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("categorical_multi", "Identity:",
                                              c(meta_cats)))
                            ),
                            div(
                              selectizeInput("multi_numeric", "Primary Numeric: csv format accepted, max 4", 
                                             choices = NULL, multiple = TRUE, options = list(
                                               maxItems=4,
                                               delimiter = ',',
                                               create = I("function(input, callback){
                                                               return {
                                                                 value: input,
                                                                 text: input
                                                                };
                                              }")))
                            ),
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin: 3rem;", h3(textOutput("multiMarkerDescription"))),
                                      div(style="margin: 4rem",
                                        uiOutput("MarkerGenePlotMulti"),
                                        uiOutput("ViolinPlotMulti"),
                                        plotlyOutput("CategoricalPlotMulti")
                                      )
                            )
                   ),
                   tabPanel("Marker Set (Grid)", value=3,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_markerset", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_markerset", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_markerset", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("categorical_b", "Identity:", c(meta_cats)))
                            ),
                            div(
                              selectizeInput("numeric_b", "Primary Numeric: csv format accepted", 
                                             choices = NULL, multiple = TRUE, options = list(
                                               maxItems=16,
                                               delimiter = ',',
                                               create = I("function(input, callback){
                                                                 return {
                                                                   value: input,
                                                                   text: input
                                                                  };
                                                }")))
                            ),
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin: 3rem", h3(textOutput("markerSetDescription"))),
                                      div(style="margin: 4rem",
                                        plotOutput("MarkerSet")
                                      )
                            )
                   ),
                   tabPanel("Multiple Feature Plot", value=4,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_multifea", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_multifea", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_multifea", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                selectInput("multiple_feature_categorical_plot", "Identity:",
                                            c(meta_cats))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                selectInput("multiple_feature_reduction", "Reduction:",
                                            c(reductions), selected = default_reduction)),
                            ),
                            div(
                              selectizeInput("multiple_feature_list", "Primary Numeric: csv format accepted, 5-16 features optimal",
                                             choices = NULL, multiple = TRUE, options = list(
                                                                maxItems=16,
                                                                delimiter = ',',
                                                                create = I("function(input, callback){
                                                                 return {
                                                                   value: input,
                                                                   text: input
                                                                  };
                                                               }")))
                            ),
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin: 3rem", h3(textOutput("multiFeatureDescription"))),
                                      div(style="margin: 4rem",
                                        plotlyOutput("MultipleFeatureCategoricalPlot"),
                                        uiOutput("MultipleFeaturePlot")
                                      )
                            )
                   ),
                   tabPanel("Cluster Tree", value=5,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_cluster", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_cluster", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_cluster", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity_tree", "Identity:",
                                              c(meta_cats)))
                              ),
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin: 3rem", h3(textOutput("clusterTreeDescription"))),
                                      div(style="margin: 4rem",
                                        plotOutput("ClusterTree")
                                      )
                            )
                   ),
                   tabPanel("Seperated Feature", value=6,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_sepfea", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_sepfea", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_sepfea", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("subset_seperated", "Numeric Analysis Type:",
                                              c('Genes', 'Numeric Metadata','PCs'))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("reduction_seperated", "Reduction:",
                                              c(reductions), selected = default_reduction)),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity_seperated", "Cell Type/Cluster:",
                                              c(meta_cats))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity_seperated2", "Identity:",
                                              c(meta_cats))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectizeInput("numeric_seperated", "Primary Numeric:", ""))
                              ),
                            
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin:3rem", h3(textOutput("seperatedFeatureDescription"))),
                                      div(style="margin: 4rem",
                                        plotlyOutput("SeperatedFeature", height = "500px"),
                                        plotlyOutput("SeperatedDim"),
                                        plotlyOutput("SeperatedViolin", width="2000px"),
                                        tableOutput("SeperatedCounts")
                                      )
                            )
                   ),
                   tabPanel("Seperated Categorical", value=7,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_sepcat", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_sepcat", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_sepcat", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("reduction_seperated_categorical", "Reduction:",
                                              c(reductions), selected = default_reduction)),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity_seperated_categorical", "Identity:",
                                              c(meta_cats))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity2_seperated_categorical", "Secondary Identity:", ""))
                              ),
                            
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin:3rem", h3(textOutput("seperatedCatDescription"))),
                                      div(style="margin: 4rem",
                                        plotlyOutput("SeperatedIdentityCategorical", height = "500px"),
                                        plotlyOutput("SeperatedIdentity2Categorical"),
                                        plotlyOutput("SeperatedCountsCategorical")
                                      )
                                      
                            )
                   ),
                   tabPanel("Marker Table", value=8,
                            br(),
                            div(style="display: flex; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_marktab", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_marktab", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_marktab", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("identity_table", "Identity:",
                                              c(meta_cats))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("markers_table", "Get markers for:", "", multiple = TRUE)),
                              
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("compare_table", "Compare to (blank is all other groups):", "", multiple = TRUE))
                              ),
                            
                            mainPanel(width = 12,
                                      br(),
                                      div(style="margin:3rem", h3(textOutput("markerTableDescription"))),
                                      div(style="margin: 4rem",
                                        tableOutput("markers")
                                      )
                            )
                   ), 
                   tabPanel("Download", value=9,
                            br(),
                            div(style="display: flex; flex-direction: column; justify-content: space-between; vertical-align:top;",
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("animal_download", "Animal",
                                              names(datasets))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("species_download", "Species",
                                              names(datasets[[default_animal]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  selectInput("tissue_download", "Tissue",
                                              names(datasets[[default_animal]][[default_species]]))),
                              div(style="flex: 1; margin: 0 0.4rem;",
                                  actionButton("download_link", " (.rds format, Seurat object)", icon("download"))
                              )

                              
                            ),
                            
                            mainPanel(width = 12,
                                      #TODO - display a short summary of the data being downloaded
                                      
                            )
                   )
                 )
    ),
    mainPanel(width = 12)
  )
)
