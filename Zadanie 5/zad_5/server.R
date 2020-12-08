library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)
library(ggpubr)
library(readr)

shinyServer(function(input, output, session) {
    
    ## -------- Load data
    dataInput <- reactive({
        # observeEvent(input$poke_csv, {print(paste0(input$poke_csv$datapath))})
        if(is.null(input$poke_csv)){return(df)}
        read.csv(input$poke_csv$datapath)
    })
    output$import_pokemons <- renderDataTable({dataInput()}, options = list(pageLength = 5))
    
    ## -------- Select pokemons to compare
    
    output$pokes_to_compare <- renderUI({
        selectizeInput("pokes_to_compare", "Select Pokemons for comparison", choices = dataInput()[['name']], multiple = TRUE, selected = c("Charmander", "Bulbasaur", "Squirtle"),
            options = list(
                maxOptions = 5,
                maxItems = 3,
                'plugins' = list('remove_button'),
                'create' = TRUE,
                'persist' = FALSE))
    })
    
    output$select_stats <- renderUI({
        stats <- c("hp", "attack", 'defense', 'speed', 'sp_atk', "sp_def", "happiness", "exp")
        checkboxGroupInput("select_stats", "Select stats",
                           choices=stats,
                           inline=TRUE,
                           selected=stats
                           )
    })
    
    output$comparisonPlot <- renderPlotly({
        df_temp <- dataInput() %>%
            filter(name %in% input$pokes_to_compare) %>%
            select(c("name", "hp", "attack", 'defense', 'speed', 'sp_atk', "sp_def", "happiness", "exp"))
        df_temp <- melt(df_temp, id.vars=c("name"), measure.vars=input$select_stats)

        p <- ggplot(df_temp, aes(x=variable, y=value ,color=name, fill=name)) +
            geom_bar(position="dodge", stat="identity") +
            theme_bw()+
            theme(rect = element_rect(fill = "transparent")) +
            labs(
                title = NULL,
                fill = "Pokemon",
                x = "Stats",
                y = "Value"
            ) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
        
        ggplotly(p)
    })
    
    ## -------- Pokemon hand selection

    # output$pokemon_type <- renderUI({
    #     selectizeInput("pokemon_type", "Filter by Pokemon type", choices = c('ALL', sort(unique(dataInput()[['type']]))))
    # })
    
    output$select_poke <- renderUI({
        # if(input$pokemon_type == 'ALL'){
        #     df_temp <- dataInput()
        # }
        # else{
        #     df_temp <- dataInput() %>%
        #         filter(type == input$pokemon_type)   
        # }
        # selectizeInput("select_poke_2", "Second Pokemon", choices = dataInput()[['name']], options = list(maxOptions = 5))
        selectizeInput("select_poke", "Select Pokemons in set", choices = dataInput()[['name']], multiple = TRUE, selected = c("Charmander", "Bulbasaur", "Squirtle"),
            options = list(
                maxOptions = 5,
                minItens = 3,
                maxItems = 3,
                'plugins' = list('remove_button'),
                'create' = TRUE,
                'persist' = FALSE))
    })
    
    output$plot1 <- renderPlotly({
        df_temp <- dataInput() %>%
            filter(name %in% input$select_poke) %>%
            select(c("name", "hp", "attack", 'defense', 'speed', 'sp_atk', "sp_def", "happiness", "exp"))
        df_temp <- melt(df_temp, id.vars=c("name"))
        
        p <- ggplot(df_temp, aes(x=variable, y=value ,color=name, fill=name)) +
            geom_bar(stat="identity", position = position_stack()) +
            theme_bw()+
            theme(rect = element_rect(fill = "transparent")) +
            labs(
                title = NULL,
                fill = "Pokemon",
                x = "Stats",
                y = "Value"
            ) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
        
        ggplotly(p)
    })
    
    output$plot2 <- renderPlotly({
        df_temp <- dataInput() %>%
            filter(name %in% input$select_poke) %>%
            select(c("name", "hp", "attack", 'defense', 'speed', 'sp_atk', "sp_def", "happiness", "exp"))
        df_temp <- melt(df_temp, id.vars=c("name"))
        
        p <- plot_ly()
        
        df_temp1 <- df_temp %>% filter(name == input$select_poke[1]) %>% select(c("variable", "value"))
        p <- p %>% add_pie(df_temp1, name=input$select_poke[1], labels = df_temp1$variable, values = df_temp1$value, type = 'pie', domain = list(x = c(0, 0.4), y = c(0.4, 1)), textinfo = "text")
        df_temp2 <- df_temp %>% filter(name == input$select_poke[2]) %>% select(c("variable", "value"))
        p <- p %>% add_pie(df_temp2, name=input$select_poke[2], labels = df_temp2$variable, values = df_temp2$value, type = 'pie', domain = list(x = c(0.6, 1), y = c(0.4, 1)), textinfo = "text")
        df_temp3 <- df_temp %>% filter(name == input$select_poke[3]) %>% select(c("variable", "value"))
        p <- p %>% add_pie(df_temp3, name=input$select_poke[3], labels = df_temp3$variable, values = df_temp3$value, type = 'pie', domain = list(x = c(0.25, 0.75), y = c(0, 0.6)), textinfo = "text")

        
        p <- p %>% layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        p
    })
    
    output$stats1 <- renderText({
        df_temp <- dataInput() %>%
            filter(name %in% input$select_poke)
        paste(sort(unique(as.vector(df_temp[['type']]))), collapse=', ' )
    })
    
    output$stats2 <- renderText({
        df_temp <- dataInput() %>%
            filter(name %in% input$select_poke) %>%
            select(c('name', 'evolution'))
        
        paste(format_delim(x=df_temp, delim=">", col_names =FALSE))
    })
    
    output$stats3 <- renderText({
        df_temp <- dataInput() %>%
            filter(name %in% input$select_poke)
        types <- unique(as.vector(df_temp[['type']]))
        if(length(types) == 1){
            return(sprintf("Boost for same type pokemons in set --> %s", types[1]))
        }
        else{
            return(sprintf("Boost unavailable, too many pokemon types --> %i", length(types)))
        }
        
    })
})
