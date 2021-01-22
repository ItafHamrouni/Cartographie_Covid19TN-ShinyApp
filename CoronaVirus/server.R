library("shiny")
library("dplyr")
library("leaflet")
library("DT")
library("rsconnect")
library("stats")
library("readxl")


shinyServer(function(input, output) {
  
  # Import Data and clean it
  data_covid <- read.csv("coord.csv",sep = ",")
  data_cov <- read.csv("coord_cov.csv",sep = ",")
  data_covid <- data.frame(data_covid)
  data_covid$Latitude <-  as.numeric(data_covid$Latitude)
  data_covid$Longitude <-  as.numeric(data_covid$Longitude)
  data_covid=filter(data_covid, Latitude != "NA") # removing NA values # removing NA values
  
  # new column for the popup label
  
  data_covid <- mutate(data_covid, cntnt=paste0('<strong>Gouvernorat : </strong>',Gouvernorat,
                                          '<br><strong>Cas :</strong> ', cas,
                                          '<br><strong>Retabli :</strong> ', retabli,
                                          '<br><strong>Mort :</strong> ',mort,
                                          '<br><strong>Zone.infectee :</strong> ',zone.infectee,
                                          '<br><strong>N.Lit :</strong> ',lit,
                                          '<br><strong>N.en quarantaine :</strong> ',quarantaine
                                        )) 

  # create a color paletter for contaminated area type in the data file
  
  pal <- colorFactor(pal = c("#d60b15", "#6c05fc"), domain = c("Contaminee", "Non Contaminee"))
   
  # create the leaflet map  
  output$bbmap <- renderLeaflet({
      leaflet(data_covid) %>% 
      addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
      addTiles() %>%
      addCircleMarkers(data = data_covid, lat =  ~Latitude, lng =~Longitude, 
                       radius = 6, popup = ~as.character(cntnt), 
                       color = ~pal(data_covid$zone.dangereuse),
                       stroke = FALSE, fillOpacity = 1.2)%>%
      addLegend(pal=pal, values=data_covid$zone.dangereuse,opacity=1, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
        })
  
  #create a data object to display data
  
  output$data <-DT::renderDataTable(datatable(
    data_cov[,c(-1,-2)],filter = 'top',
      colnames = c("Gouvernorat", "N. cas", "N. cas retabli", "N. mort", 
                   "N. en quarantaine", "N. Lit","Zone dangereuse","Zone infectee")
  ))
 
  
})

