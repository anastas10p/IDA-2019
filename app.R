library(shiny)
library(ggplot2)
library(dplyr)

#generate example dataframes
comp <- c("K1", "K2", "K3", "K4", "K1", "K2", "K3", "K4", "K1", "K2", "K3", "K4", "K1", "K2", "K3", "K4")
factory <- c("F1", "F1", "F1", "F1", "F1", "F1", "F1", "F1", "F2", "F2", "F2", "F2", "F2", "F2", "F2", "F2")
absErr <- c(50, 20, 65, 25, 70, 30, 15, 5, 100, 20, 65, 25, 80, 30, 15, 50)
relErr <- c(0.12, 0.05, 0.36, 0.15, 0.3, 0.6, 0.75, 0.2, 0.1, 0.05, 0.36, 0.8, 0.3, 0.6, 0.75, 0.5)
year <- c(2017, 2017, 2017, 2017, 2018, 2018, 2018, 2018, 2017, 2017, 2017, 2017, 2018, 2018, 2018, 2018)
data <- data.frame(Component = comp, factory = factory, absError = absErr, relError = relErr, year = year, stringsAsFactors = FALSE)

#define functions for plotting
pareto <- function(df, y){
    
    #filter year and factory
    df <- filter(df, year == y)
    
    #descending order
    df <- df[order(df$relError, decreasing=TRUE), ]
    
    #make factors
    df$Component <- factor(df$Component, levels= unique(df$Component))
    
    #new column cumulative relative error
    df$cumRelError <- cumsum(df$relError)
    
    #generate the Pareto chart
    ggplot(df, aes(x=df$Component)) +
        geom_bar(aes(y=df$relError), fill='blue', stat = "identity", width = 0.8) +
        scale_y_continuous(sec.axis = sec_axis(~./max(df$cumRelError), name = "Cumulated")) +
        geom_point(aes(y=df$cumRelError), color = "green", size=2) +
        geom_path(aes(y=df$cumRelError, group=1), colour="blue", size=0.5) +
        labs(title = "Pareto", x = 'Components', y = 'Relative Error') +
        facet_grid(cols = vars(df$factory), scales = "free")
}

linediag <- function(df, comp){
    df <- filter(df, Component == comp)
    
    ggplot(df, aes(x=df$year, y=df$absError, col = df$factory)) +
        geom_line()
}


############### UI ###############
ui <- fluidPage(
    
    # Application title
    headerPanel("Test"),
    
    selectInput("year", "Year:", 
                choices = c("2017", "2018", "2019")),
    
    # Show plots
    fluidRow(
        column(8,
            plotOutput("Pareto"))),
    fluidRow(
        column(8,
            plotOutput("Pareto2"))),
    fluidRow(column(4,
        plotOutput("linediagram"))),
    fluidRow(column(4,
        dataTableOutput("dataset")))
)


############ server ###############
server <- function(input, output) {
    
    #select input to filter by year
    datasetInput <- reactive({
        switch(input$year,
               "2017" = 2017,
               "2018" = 2018,
               "2019" = 2019)
    })
    
    #Pareto diagram for the first factory
    output$Pareto <- renderPlot({
        x    <- datasetInput()
        pareto(data, x)
    })
    
    #Pareto diagram for the second factory
    output$Pareto2 <- renderPlot({
        x    <- datasetInput()
        pareto(data, x)
    })
    
    
    #Line diagram for one component
    output$linediagram <- renderPlot({
        linediag(data, "K1")
    })
    
    #Show the basic dataset
    output$dataset <- renderDataTable(data)
}


# Run the application 
shinyApp(ui = ui, server = server)
