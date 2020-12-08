library(shiny)
library(shinyBS)
library(plotly)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)

shinyUI(fluidPage(
    titlePanel("Pokedex in R"),
    
    setBackgroundImage(src = "https://images8.alphacoders.com/963/963319.png"),
    
    tags$style(type="text/css",
               ".shiny-output-error { visibility: hidden; }",
               ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    tabsetPanel(
        tabPanel("Load data",
                 
                 sidebarLayout(
                     sidebarPanel(
                         fileInput("poke_csv", "Upload another pokemon.csv file:",
                                   accept = c("text/csv", "text/comma-separated-values, text/plain", ".csv")),
                         tags$hr()
                     ),
                     mainPanel(
                         tabPanel("Data", dataTableOutput("import_pokemons"))
                     )
                 )
                 
                 ),
        tabPanel("Compare pokemons",
                 
                 sidebarLayout(
                     sidebarPanel(
                         uiOutput("pokes_to_compare"),
                         br(),
                         uiOutput("select_stats"),
                         br(),
                         submitButton("Compare")
                         
                     ),
                     mainPanel(
                         plotlyOutput("comparisonPlot")
                         # plotOutput("comparisonPlot")
                     )
                 )
                 
                 ),
        tabPanel("Choose the best pokemon set",
                 
                 sidebarLayout(
                     sidebarPanel(
                         # uiOutput("pokemon_type"),
                         # submitButton("Select type"),
                         width = 3,
                         uiOutput("select_poke"),
                         hr(),
                         # Boost by input
                         submitButton("Submit")
                     ),
                     mainPanel(
                         fluidRow(
                             column(8, "Plots",
                                    # bsCollapse("coll1", open = "Stat summary plot", plotlyOutput("plot1"))
                                    bsCollapse(id="coll1", open = "Stat summary plot",
                                               bsCollapsePanel("Summary plot", "", plotlyOutput("plot1"), style = "success"),
                                               bsCollapsePanel("Idividual pokemon stats arrangement", "", plotlyOutput("plot2"), style = "success")
                                               
                                               ),
                                          
                                    ),
                             column(4, "Additional stats",
                                    h4("Pokemon types"),
                                    textOutput("stats1"),
                                    h4("Next evolution"),
                                    textOutput("stats2"),
                                    h4("Same type boost"),
                                    textOutput("stats3"),
                                    
                             )
                         )
                     )
                 )
                 
                 
                 )
    ),
))
