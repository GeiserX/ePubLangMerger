library(shiny)

shinyUI(
  navbarPage("ePub Merger", id = "navbar", position = "static-top",
             inverse = FALSE, theme = "bootstrap.css",

    tabPanel("Main",
      sidebarPanel(
        p("Upload two epub files of the same book in different languages.",
          "The tool merges the second language into the first as sibling paragraphs."),
        fileInput("epub1", label = "First Language", accept = ".epub"),
        fileInput("epub2", label = "Second Language", accept = ".epub"),
        actionButton("submit", "Go!")
      ),

      mainPanel(
        uiOutput("descargaUI")
      )
    )
  )
)
