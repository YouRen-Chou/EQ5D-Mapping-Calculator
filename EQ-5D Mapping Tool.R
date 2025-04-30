library(shiny)
library(shinydashboard)
library(plotly)

# UI definition
ui <- dashboardPage(
  # Dashboard header
  dashboardHeader(title = "EQ-5D UK Mapping Tool"),
  
  # Dashboard sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Mapping Tool", tabName = "mapping", icon = icon("exchange-alt")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  # Dashboard body
  dashboardBody(
    # Custom CSS
    tags$head(
      tags$style(HTML("
        .skin-blue .main-header .logo {
          background-color: #4287f5;
          font-weight: bold;
        }
        .skin-blue .main-header .navbar {
          background-color: #3c8dbc;
        }
        .content-wrapper, .right-side {
          background-color: #ffffff;
        }
        .result-box {
          background-color: #f9f9f9;
          border: 1px solid #ddd;
          border-radius: 5px;
          padding: 15px;
          margin-top: 20px;
          margin-bottom: 20px;
        }
        .info-box {
          background-color: #e8f4f8;
          border-left: 5px solid #3c8dbc;
          padding: 10px;
          margin-bottom: 20px;
        }
      "))
    ),
    
    tabItems(
      # Mapping Tool Tab
      tabItem(
        tabName = "mapping",
        h2("EQ-5D UK Mapping Tool"),
        
        div(class = "info-box",
            p("This tool maps between UK-specific EQ-5D-3L and EQ-5D-5L health utility values.")
        ),
        
        fluidRow(
          column(
            width = 6,
            box(
              title = "Mapping Direction",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              radioButtons(
                "mapping_direction",
                "Select Mapping Direction:",
                choices = c("EQ-5D-3L to EQ-5D-5L", "EQ-5D-5L to EQ-5D-3L"),
                selected = "EQ-5D-3L to EQ-5D-5L"
              )
            )
          ),
          column(
            width = 6,
            box(
              title = "Demographic Information",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              sliderInput(
                "age",
                "Age:",
                min = 18,
                max = 100,
                value = 40,
                step = 1
              ),
              radioButtons(
                "gender",
                "Gender:",
                choices = c("Male", "Female"),
                selected = "Male"
              )
            )
          )
        ),
        
        # Health State Inputs (3L)
        conditionalPanel(
          condition = "input.mapping_direction == 'EQ-5D-3L to EQ-5D-5L'",
          box(
            title = "EQ-5D-3L Health State Input",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            p(strong("Domain values: "), "1=no problems, 2=some problems, 3=extreme problems"),
            fluidRow(
              column(
                width = 6,
                numericInput("y3_1", "Mobility:", value = 1, min = 1, max = 3, step = 1),
                numericInput("y3_2", "Self-Care:", value = 1, min = 1, max = 3, step = 1),
                numericInput("y3_3", "Usual Activities:", value = 1, min = 1, max = 3, step = 1)
              ),
              column(
                width = 6,
                numericInput("y3_4", "Pain/Discomfort:", value = 1, min = 1, max = 3, step = 1),
                numericInput("y3_5", "Anxiety/Depression:", value = 1, min = 1, max = 3, step = 1)
              )
            )
          )
        ),
        
        # Health State Inputs (5L)
        conditionalPanel(
          condition = "input.mapping_direction == 'EQ-5D-5L to EQ-5D-3L'",
          box(
            title = "EQ-5D-5L Health State Input",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            p(strong("Domain values: "), "1=no, 2=slight, 3=moderate, 4=severe, 5=extreme problems"),
            fluidRow(
              column(
                width = 6,
                numericInput("y5_1", "Mobility:", value = 1, min = 1, max = 5, step = 1),
                numericInput("y5_2", "Self-Care:", value = 1, min = 1, max = 5, step = 1),
                numericInput("y5_3", "Usual Activities:", value = 1, min = 1, max = 5, step = 1)
              ),
              column(
                width = 6,
                numericInput("y5_4", "Pain/Discomfort:", value = 1, min = 1, max = 5, step = 1),
                numericInput("y5_5", "Anxiety/Depression:", value = 1, min = 1, max = 5, step = 1)
              )
            )
          )
        ),
        
        # Result display options
        checkboxInput("show_visualisation", "Show visualisation", value = TRUE),
        
        # Map button
        actionButton("map_button", "Map Health State", class = "btn-primary"),
        
        # Results section
        uiOutput("mapping_results"),
        
        # Visualisation
        conditionalPanel(
          condition = "input.show_visualisation == true && output.has_results",
          box(
            title = "Visualisation",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("value_comparison_plot")
          )
        )
      ),
      
      # About Tab
      tabItem(
        tabName = "about",
        h2("About EQ-5D UK Mapping"),
        
        box(
          title = "What is EQ-5D?",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("EQ-5D is a standardised instrument developed by the EuroQol Group as a measure of health-related quality of life 
            that can be used in a wide range of health conditions and treatments. The instrument consists of a descriptive system 
            and a visual analogue scale (EQ VAS)."),
          p("The descriptive system comprises five dimensions:"),
          tags$ol(
            tags$li("Mobility"),
            tags$li("Self-Care"),
            tags$li("Usual Activities"),
            tags$li("Pain/Discomfort"),
            tags$li("Anxiety/Depression")
          )
        ),
        
        box(
          title = "EQ-5D Versions",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("There are two main versions of the EQ-5D descriptive system:"),
          tags$ul(
            tags$li(strong("EQ-5D-3L"), ": Each dimension has 3 levels (no problems, some problems, extreme problems)"),
            tags$li(strong("EQ-5D-5L"), ": Each dimension has 5 levels (no problems, slight problems, moderate problems, severe problems, extreme problems)")
          )
        ),
        
        box(
          title = "Why Mapping is Necessary",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("The newer 5L version was developed to improve sensitivity and reduce ceiling effects compared to the 3L version. 
            However, since many historical studies used the 3L version, mapping between the versions is often necessary to:"),
          tags$ul(
            tags$li("Compare results across studies using different versions"),
            tags$li("Update health economic models"),
            tags$li("Utilise utility values in situations where only one set is available")
          )
        ),
        
        box(
          title = "UK Value Sets",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("This application uses UK-specific value sets for both the 3L and 5L versions. These value sets convert 
            health states into utility values that can be used in health economic evaluations.")
        ),
        
        box(
          title = "How Mapping Works",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("This application uses a cross-walking approach based on published mapping algorithms for the UK population. 
            The mapping takes into account:"),
          tags$ul(
            tags$li("The specific health state described by the dimension levels"),
            tags$li("Demographic factors (age and gender)")
          ),
          p("When you map a health state, the application looks up the corresponding mapped value in reference tables 
            derived from large studies that have directly compared the two versions.")
        ),
        
        box(
          title = "References",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          p("Hernandez Alava, M., Pudney, S., and Wailoo, A. (2020). Estimating the relationship between EQ-5D-5L and EQ-5D-3L: results from an English Population Study. Policy Research Unit in Economic Evaluation of Health and Care Interventions. Universities of Sheffield and York. Report 063.")
        )
      )
    ),
    
    # Footer
    tags$div(
      style = "text-align: center; margin-top: 20px; margin-bottom: 10px;",
      hr(),
      p("EQ-5D UK Mapping Tool | UK-specific EQ-5D-5L and EQ-5D-3L utility values")
    )
  )
)

library(shiny)
library(plotly)
library(readr)
library(dplyr)

# Server logic
server <- function(input, output, session) {
  
  # Load the mapping tables
  table_3l_to_5l <- reactive({
    read_csv("Table3v5.csv")
  })
  
  table_5l_to_3l <- reactive({
    read_csv("Table5v5.csv")
  })
  
  # Helper function to get age group from age
  get_age_group <- function(age) {
    if (age <= 34) {
      return("18-34")
    } else if (age <= 44) {
      return("35-44")
    } else if (age <= 54) {
      return("45-54")
    } else if (age <= 64) {
      return("55-64")
    } else {
      return("65+")
    }
  }
  
  # Mapping function: 3L to 5L
  map_3l_to_5l <- function(y3_1, y3_2, y3_3, y3_4, y3_5, age, gender_value) {
    age_group <- get_age_group(age)
    
    filtered_data <- table_3l_to_5l() %>%
      filter(
        `_Y3_1` == y3_1,
        `_Y3_2` == y3_2,
        `_Y3_3` == y3_3,
        `_Y3_4` == y3_4,
        `_Y3_5` == y3_5,
        `_age5grp` == age_group,
        `_male` == gender_value
      )
    
    if (nrow(filtered_data) > 0) {
      original_value <- filtered_data$`_U3UK`[1]
      mapped_value <- filtered_data$`_EUUKcopula`[1]
      return(list(original_value = original_value, mapped_value = mapped_value))
    } else {
      return(NULL)
    }
  }
  
  # Mapping function: 5L to 3L
  map_5l_to_3l <- function(y5_1, y5_2, y5_3, y5_4, y5_5, age, gender_value) {
    age_group <- get_age_group(age)
    
    filtered_data <- table_5l_to_3l() %>%
      filter(
        `_Y5_1` == y5_1,
        `_Y5_2` == y5_2,
        `_Y5_3` == y5_3,
        `_Y5_4` == y5_4,
        `_Y5_5` == y5_5,
        `_age5grp` == age_group,
        `_male` == gender_value
      )
    
    if (nrow(filtered_data) > 0) {
      original_value <- filtered_data$`_U5UK`[1]
      mapped_value <- filtered_data$`_EUUKcopula`[1]
      return(list(original_value = original_value, mapped_value = mapped_value))
    } else {
      return(NULL)
    }
  }
  
  # Store mapping results
  mapping_result <- reactiveVal(NULL)
  
  # React to the Map button
  observeEvent(input$map_button, {
    gender_value <- ifelse(input$gender == "Male", 1, 0)
    
    if (input$mapping_direction == "EQ-5D-3L to EQ-5D-5L") {
      result <- map_3l_to_5l(
        input$y3_1, input$y3_2, input$y3_3, input$y3_4, input$y3_5,
        input$age, gender_value
      )
      
      if (!is.null(result)) {
        mapping_result(list(
          original_value = result$original_value,
          mapped_value = result$mapped_value,
          original_label = "EQ-5D-3L Value",
          mapped_label = "Mapped EQ-5D-5L Value"
        ))
      } else {
        mapping_result(NULL)
      }
    } else {
      result <- map_5l_to_3l(
        input$y5_1, input$y5_2, input$y5_3, input$y5_4, input$y5_5,
        input$age, gender_value
      )
      
      if (!is.null(result)) {
        mapping_result(list(
          original_value = result$original_value,
          mapped_value = result$mapped_value,
          original_label = "EQ-5D-5L Value",
          mapped_label = "Mapped EQ-5D-3L Value"
        ))
      } else {
        mapping_result(NULL)
      }
    }
  })
  
  # Output for checking if results are available
  output$has_results <- reactive({
    !is.null(mapping_result())
  })
  outputOptions(output, "has_results", suspendWhenHidden = FALSE)
  
  # Display mapping results
  output$mapping_results <- renderUI({
    result <- mapping_result()
    
    if (is.null(result)) {
      if (input$map_button > 0) {
        div(
          class = "alert alert-danger",
          "No matching health state found in the mapping table."
        )
      } else {
        return(NULL)
      }
    } else {
      original_value <- result$original_value
      mapped_value <- result$mapped_value
      difference <- mapped_value - original_value
      
      difference_text <- if (difference > 0) {
        "The mapped value is higher than the original value."
      } else if (difference < 0) {
        "The mapped value is lower than the original value."
      } else {
        "The mapped value is equal to the original value."
      }
      
      div(
        class = "result-box",
        fluidRow(
          column(
            width = 6,
            h4("Original Value"),
            h3(sprintf("%.4f", original_value))
          ),
          column(
            width = 6,
            h4("Mapped Value"),
            h3(sprintf("%.4f", mapped_value))
          )
        ),
        hr(),
        h4(sprintf("Difference: %.4f", difference)),
        p(tags$strong(difference_text))
      )
    }
  })
  
  # Create bar chart visualization
  output$value_comparison_plot <- renderPlotly({
    result <- mapping_result()
    
    if (!is.null(result)) {
      original_value <- result$original_value
      mapped_value <- result$mapped_value
      original_label <- result$original_label
      mapped_label <- result$mapped_label
      
      # Create data frame for plotting
      plot_data <- data.frame(
        label = c(original_label, mapped_label),
        value = c(original_value, mapped_value)
      )
      
      # Determine y-axis range based on values
      y_range <- if (original_value < 0 || mapped_value < 0) {
        c(-1, 1)  # Include negative values if any value is negative
      } else {
        c(0, 1)   # Otherwise, start at 0 for positive values only
      }
      
      # Create plot
      p <- plot_ly(
        data = plot_data,
        x = ~label, 
        y = ~value,
        type = "bar",
        text = ~sprintf("%.4f", value),
        textposition = "auto",
        marker = list(color = c("rgba(66, 135, 245, 0.8)", "rgba(245, 102, 66, 0.8)"))
      ) %>%
        layout(
          title = "Comparison of Original and Mapped Health Utility Values",
          xaxis = list(title = "Value Type"),
          yaxis = list(title = "Health Utility Value", range = y_range)
        )
      
      return(p)
    }
  })
}

shinyApp(ui, server)
