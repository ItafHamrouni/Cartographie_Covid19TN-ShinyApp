library("shiny")
library("leaflet")

navbarPage("Cartographie Covid19.TN", id="main",
           tabPanel("Map", leafletOutput("bbmap", height=1000)),
           tabPanel("Data", DT::dataTableOutput("data")),
           tabPanel("Read Me",includeMarkdown("readme.md"),
                    img(src='ctrs.jpg',width="250",height="200",align = "left")))

