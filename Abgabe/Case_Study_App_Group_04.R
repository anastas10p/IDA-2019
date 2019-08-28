if (!require(shiny)) {
  install.packages("shiny")
}
library(shiny)

if (!require(ggplot2)) {
  install.packages("ggplot2")
}
library(ggplot2)


if (!require(cowplot)) {
  install.packages("cowplot")
}
library(cowplot)

if (!require(dplyr)) {
  install.packages("dplyr")
}
library(dplyr)


load(paste(getwd(), "/Additional_files_Group_04/dataset_app.RData", sep = ""))
addResourcePath(prefix = "resources", directoryPath = "./Additional_files_Group_04")

############### UI ###############
ui <- fluidPage(

  # Application title
  titlePanel(title = div("Error Statistics: Factories and Components", img(src = "resources/images.png", height = "20%", width = "20%", align = "right"))),



  tabsetPanel(
    type = "tabs",
    tabPanel(
      "Info",
      img(src = "resources/car.jpeg", height = "40%", width = "40%", align = "center"),
      p(strong("Description")),
      p({
        "The present app is designed to cope with large amount of data in the automotive sector.
                           It helps identifying suppliers of certain components which have high error rates (absolute and relative)."
      }),
      br(),
      p(strong("Pareto Plots")),
      p({
        "In the tab \"Pareto Plots\", you can generate Pareto digrams which sort the factory and components, respectively in a descending order.
                           The upper Pareto diagram displays the error rates of the factory as a whole, meaning that
                           there is no distinction between the manufactured components within the factory. Beneath the 
                           Pareto diagram, you have the possibility to manually select individual factories in order to 
                           have a more detailed look on a component-sharp resolution."
      }),
      br(),
      p(strong("Error on component-sharp resolution")),
      p({
        "In the tab \"Error on component-sharp resolution\", you can select certain components in order to examine the distribution of 
                           absolute errors over the selcted time frame."
      }),
      br(),
      p(strong("Dataset")),
      p({
        "The tab \"Dataset\" displays a browsable table of the dataset that is used to generate the plots."
      })
    ),


    tabPanel(
      "Pareto Plots",
      # Scrollable tab

      fluidRow(
        column(
          width = 6,
          h4("Selection of the year"),
          # dropdown for production year
          selectInput("year", "Production Year:",
            choices = errors_by_id$production_year, selected = TRUE
          )
        ),
        column(
          width = 6,
          h4("Selction of error type"),
          # switch between rel/abs error
          selectInput("error", "Relative/Absolute Error", choices = list("Relative", "Absolute"))
        )
      ),

      plotOutput("Pareto1"),

      # checkboxes to choose factories
      fluidRow(
        column(
          width = 9,
          # Checkbox for factories
          checkboxGroupInput("factories", "Choose factories to show components:", unique(errors_by_id$factory), inline = TRUE),
          checkboxInput("all", "All")
        ),
        column(
          h6("Press \"Go\"-Button to display factories"),
          width = 3,
          # Go Buttom
          actionButton("go", "Go")
        )
      ),


      plotOutput("Pareto2", height = "600px")
    ),

    tabPanel(
      "Error on component-sharp resolution",

      fluidRow(
        column(
          width = 6,
          h4("Selection of the year"),
          # dropdown for production year
          selectInput("year_line", "Production Year:",
            choices = errors_by_id$production_year, selected = TRUE
          )
        ),
        column(
          width = 6,
          h4("Selection of the component"),
          # switch between rel/abs error
          selectInput("component", "Select component for detailed error plot", choices = names(errors_by_id_week))
        )
      ),

      plotOutput("Linediagram")
    ),


    tabPanel("Dataset", dataTableOutput("dataset"))
  )
)


############ server ###############
server <- function(input, output, session) {

  # select input to filter by year for pareto diagram
  year_input <- reactive({
    input$year
  })

  # Input for line diagram
  year_line_input <- reactive({
    input$year_line
  })

  error_input <- reactive({
    switch(input$error,
      "Relative" = "rel",
      "Absolute" = "abs"
    )
  })


  component_input <- reactive({
    input$component
  })


  # Pareto diagram to compare factories
  output$Pareto1 <- renderPlot({
    y <- year_input()
    errors_by_factory <- filter(errors_by_factory, production_year == y)
    e <- error_input()
    if (e == "rel") {
      errors_by_factory$error_data <- errors_by_factory$rel_error
      ymax <- 0.25
      sec_axis_factor <- 9
      ylabel <- "Relative Error"
    }
    if (e == "abs") {
      errors_by_factory$error_data <- errors_by_factory$abs_error
      ymax <- 40000
      sec_axis_factor <- 6
      ylabel <- "Absolute Error"
    }
    errors_by_factory <- errors_by_factory[order(errors_by_factory$error_data, decreasing = TRUE), ]
    errors_by_factory$factory <- factor(errors_by_factory$factory, levels = unique(errors_by_factory$factory))
    errors_by_factory$cum_error <- cumsum(errors_by_factory$error_data)
    ggplot(errors_by_factory, aes(x = errors_by_factory$factory, y = errors_by_factory$error_data)) +
      geom_bar(aes(fill = errors_by_factory$factory), stat = "identity") +
      scale_y_continuous(limits = c(0, ymax), sec.axis = sec_axis(~ . / max(errors_by_factory$cum_error / sec_axis_factor), name = "Cumulated")) +
      geom_point(aes(y = errors_by_factory$cum_error / sec_axis_factor), size = 2) +
      geom_path(aes(y = errors_by_factory$cum_error / sec_axis_factor, group = 1)) +
      geom_hline(yintercept = max(errors_by_factory$cum_error / sec_axis_factor), linetype = "dashed") +
      labs(title = "Errors by Factory", x = "Factories", y = ylabel) +
      theme(legend.position = "none")
  })



  observe({
    updateCheckboxGroupInput(
      session, "factories",
      choices = unique(errors_by_id$factory), inline = TRUE,
      selected = if (input$all) unique(errors_by_id$factory)
    )
  })


  # Delay creation of plots via go button
  factory_plots <- eventReactive(input$go, {
    (input$factories)
  })

  # Pareto diagrams to compare components
  output$Pareto2 <- renderPlot({
    # define function for plotting the pareto diagram
    pareto <- function(df, f, e) {

      # filter factory
      df <- filter(df, factory == f)

      if (e == "rel") {
        df$error_data <- df$rel_error
        ymax <- 0.3
        ylabel <- "Relative Error"
      }
      if (e == "abs") {
        df$error_data <- df$abs_error
        ymax <- 25000
        ylabel <- "Absolute Error"
      }

      if (length(df$factory != 0)) {
        # descending order
        df <- df[order(df$error_data, decreasing = TRUE), ]

        # make factors for x-axis
        df$id <- factor(df$id, levels = unique(df$id))


        # new column cumulative relative error
        df$cum_error <- cumsum(df$error_data)

        # generate the Pareto chart
        ggplot(df, aes(x = df$id, y = df$error_data)) +
          geom_bar(aes(fill = df$id), stat = "identity", width = length(df$id) * 0.2) +
          scale_y_continuous(limits = c(0, ymax), sec.axis = sec_axis(~ . / max(df$cum_error / 2), name = "Cumulated")) +
          geom_point(aes(y = df$cum_error / 2), size = 2) +
          geom_path(aes(y = df$cum_error / 2, group = 1), size = 0.5) +
          labs(title = df$factory, x = "Components", y = ylabel) +
          theme(legend.position = "none", aspect.ratio = 1) +
          scale_fill_manual(values = c(
            "K1BE1" = colors()[10], "K1BE2" = colors()[20], "K1DI1" = colors()[50], "K1DI2" = colors()[55],
            "K2LE1" = colors()[65], "K2LE2" = colors()[100], "K2ST1" = colors()[30],
            "K2ST2" = colors()[80], "K3AG1" = colors()[70], "K3AG2" = colors()[60], "K3SG1" = colors()[90],
            "K3SG2" = colors()[40], "K4" = colors()[400], "K5" = colors()[450],
            "K6" = colors()[500], "K7" = colors()[550]
          ))
      }
    }

    y <- year_input()
    errors_by_id <- filter(errors_by_id, production_year == y)
    e <- error_input()
    plots <- list()
    for (i in factory_plots()) {
      plots[[i]] <- pareto(errors_by_id, i, e)
    }
    if (length(plots) == 0) {
      NULL
    } else if (length(plots) <= 4) {
      do.call(plot_grid, c(plots, nrow = 1))
    } else if (length(plots) <= 8) {
      do.call(plot_grid, c(plots, nrow = 2))
    } else {
      do.call(plot_grid, c(plots, nrow = 3))
    }
  })



  output$Linediagram <- renderPlot({
    validate(
      need(input$component, "Please select a component")
    )
    selected_component <- component_input()
    selected_year <- year_line_input()
    df <- data.frame(errors_by_id_week[[selected_component]]) %>%
      filter(production_year == selected_year)
    df$factory <- factor(df$factory)
    ggplot(df, aes(x = df$production_week, group = df$factory)) +
      geom_line(aes(y = df$abs_error, color = df$factory), size = 1) +
      geom_point(aes(y = df$abs_error, color = df$factory), size = 2) +
      geom_line(aes(y = df$total_error, color = "total"), size = 1.3, linetype = "dotted") +
      labs(x = "Production Week", y = "Absolute Error", color = "Factory")
  })


  # Show the basic dataset
  output$dataset <- renderDataTable(rename(errors_by_id, component = id), options = list(pageLength = 10))
}

# Run the application
shinyApp(ui = ui, server = server)