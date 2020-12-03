library(shiny)
library(shinyWidgets)

shinyUI(fluidPage(
    titlePanel("Pokedex in R"),
    
    setBackgroundImage(src = "https://images8.alphacoders.com/963/963319.png"),
    
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
                         selectizeInput('poke1', 'Pokemon 1', choices = NULL, selected=NULL, options = list(maxOptions = 5)),
                         selectizeInput('poke2', 'Pokemon 2', choices = NULL, selected=NULL, options = list(maxOptions = 5)),
                         br(),
                         br(), 
                         submitButton("Compare")
                     ),
                     mainPanel(
                         plotOutput("comparisonPlot")
                     )
                 )
                 
                 ),
        tabPanel("Choose the best pokemon set")
    ),
))
