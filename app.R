library(shiny)
library(ggplot2)
library(cowplot)
library(dplyr)

# data <- allComponents
# data$production_date <- format(as.Date(data$production_date, format="%Y-%m-%d"),"%Y")
# 
# data <- data %>%
#   group_by(id, factory, production_date) %>%
#   summarise(abs_error = sum(faulty, na.rm = TRUE), rel_error = abs_error/length(id))


#define functions for plotting
pareto <- function(df, f, e){
    
    #filter year and factory
    #df <- filter(df, production_date == y)
    df <- filter(df, factory == f)
      
    if (e == "rel"){
        df$error_data <- df$rel_error
        ymax <- 1
        ylabel <- "Relative Error"
    }
    if (e == "abs"){
        df$error_data <- df$abs_error
        ymax <- 10000
        ylabel <- "Absolute Error"
    }
    
    if (length(df$factory != 0)){
        #descending order
        df <- df[order(df$error_data, decreasing=TRUE), ]
        
        #make factors
        df$id <- factor(df$id, levels= unique(df$id))
        
        #new column cumulative relative error
        df$cum_error <- cumsum(df$error_data)
        
        #generate the Pareto chart
        ggplot(df, aes(x=df$id, y=df$error_data)) +
            geom_bar(fill="blue", stat = "identity", width = 0.8) +
            #scale_y_continuous(limits = c(0, ymax)) +
            scale_y_continuous(limits = c(0,ymax), sec.axis = sec_axis(~./max(df$cum_error, name = "Cumulated"))) +
            geom_point(aes(y=df$cum_error), color = "green", size=2) +
            geom_path(aes(y=df$cum_error, group=1), colour="blue", size=0.5) +
            labs(title = df$factory, x = "Components", y = ylabel)
    }
}

############### UI ###############
ui <- fluidPage(
    
    # Application title
    headerPanel("Test"),
    
    selectInput("year", "Year:", 
                choices = 2008:2016),
    
    selectInput("error", "Relative/Absolute Error", choices = list("Relative", "Absolute")),
    
    # Show plots
    fluidRow(plotOutput("Pareto")),
    fluidRow(column(8,
        plotOutput("linediagram"))),
    fluidRow(column(8,
        dataTableOutput("dataset")))
)


############ server ###############
server <- function(input, output) {
    
    #select input to filter by year
    year_input <- reactive({
        switch(input$year,
               "2008" = 2008,
               "2009" = 2009,
               "2010" = 2010,
               "2011" = 2011,
               "2012" = 2012,
               "2013" = 2013,
               "2014" = 2014,
               "2015" = 2015,
               "2016" = 2016,)
    })
    
    error_input <- reactive({
        switch(input$error,
               "Relative" = "rel",
               "Absolute" = "abs",)
    })
    
    #Pareto diagram for the first factory
    output$Pareto <- renderPlot({
        y <- year_input()
        data <- filter(data, production_date == y)
        e <- error_input()
        plots <- list()
        for (i in 1:length(unique(data$factory))){
            plots[[i]] <- pareto(data,unique(data$factory)[i], e)
        }
        do.call(plot_grid, c(plots, list(nrow = 2)))
    })
    
    
    #Line diagram for one component
    # output$linediagram <- renderPlot({
    #     linediag(data, "K1")
    # })
    # 
    #Show the basic dataset
#     output$dataset <- renderDataTable(data)
}


# Run the application 
shinyApp(ui = ui, server = server)
