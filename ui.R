library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("ePub Merger", id="navbar", position="static-top", inverse=F, theme = "bootstrap.css",

    tabPanel("Main", 
      sidebarPanel(  
        fileInput("epub1", label = "First Language"),
        fileInput("epub2", label = "Second Language"),
        actionButton("submit", "Go!")
      ),
      
      mainPanel(
        uiOutput("descargaUI")
        
      )
      
    )
  
))