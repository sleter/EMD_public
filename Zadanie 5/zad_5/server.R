library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)

shinyServer(function(input, output, session) {
    
    # Load data
    dataInput <- reactive({
        # observeEvent(input$poke_csv, {print(paste0(input$poke_csv$datapath))})
        if(is.null(input$poke_csv)){return(df)}
        read.csv(input$poke_csv$datapath)
    })
    output$import_pokemons <- renderDataTable({dataInput()}, options = list(pageLength = 5))
    
    # Selectize input
    updateSelectizeInput(session, 'poke1', choices = df$name, server = TRUE)
    updateSelectizeInput(session, 'poke2', choices = df$name, server = TRUE)
    
    output$comparisonPlot <- renderPlot({
        df_temp <- df %>%
            filter(name == input$poke1 | name == input$poke2) %>%
            select(c("name", "hp", "attack", 'defense', 'speed', 'sp_atk', "sp_def", "happiness", "exp"))
        df_temp <- melt(df_temp, id.vars=c("name"))
        
        p <- ggplot(df_temp, aes(x=variable, y=value ,color=name, fill=name)) +
            geom_bar(position="dodge", stat="identity") +
            labs(
                title = NULL,
                x = "Statisctics",
                y = "Value"
            )
        p
    })

})
