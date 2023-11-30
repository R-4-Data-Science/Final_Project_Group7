#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(logreg)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("The Boot Confidence Interval"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("value",
                        "The Confidence Level:",
                        min = 0,
                        max = 1,
                        value = 0.5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           textOutput("Boot_CI_demo")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  X = matrix(unif(100), ncol = 10)
  beta = c(1:10)
  Y = X%*%beta
  for(i in 1:10){
    if(Y[i] < 0.5){
      Y[i] <- 0
    }else{
      Y[i] <- 1
    }
  }
  output$Boot_CI_demo <- Boot_CI(n=20, alpha=input$value, pred= X, resp= Y)
  
}

# Run the application 
shinyApp(ui = ui, server = server)
