shinyServer(function(input, output){

# show hourly distribution plot

  
  
# show weekly distribution plot
  # 
  # distr_data = collisions %>% group_by(weekdays)
  # 
  # weeklyDensity = renderPlotly({
  #   
  #   diamonds1 <- diamonds[which(diamonds$cut == "Fair"),]
  #   density1 <- density(distr_data$weekdays)
  #   
  #   fig = plot_ly(data = distr_data, x = ~density1$x, y = ~density1$y, 
  #                  type = 'scatter', mode = 'lines', name = 'Fair cut', fill = 'tozeroy') %>%
  #     layout(xaxis = list(title = 'Carat'),
  #                         yaxis = list(title = 'Density'))
  #   
  # }) 
  
  # show party at fault bar plot 
 #############BACKUP
  # party_at_fault = collisions %>% 
  #   filter(is.na(statewide_vehicle_type_at_fault) != TRUE) %>% 
  #   select(statewide_vehicle_type_at_fault) %>%
  #   group_by(statewide_vehicle_type_at_fault) %>% summarize(totals = sum(n())) %>% arrange(desc(totals))
  # names_sorted = party_at_fault$statewide_vehicle_type_at_fault
  # #sort the bars by number
  # xform = list(
  #   categoryorder = "array",
  #   categoryarray = names_sorted,
  #   title = "Party at Fault"
  # )
  # 
  # output$partyAtFault = renderPlotly({
  #   
  #   partyAtFault = plot_ly(x = ~party_at_fault$statewide_vehicle_type_at_fault, y = ~party_at_fault$totals, type = 'bar') %>% 
  #     layout(title = 'Party at Fault', yaxis = list(title = 'Count'), xaxis = xform)
  # })
  #####################    

  # barPlotColName = reactive({
  #   switch(input$selectBarPlot, 
  #                     "Collision Severity" = "collision_severity",
  #                     "Party at Fault" = "statewide_vehicle_type_at_fault", 
  #                     "Crash Cause" = "pcf_violation_category", 
  #                     "Victims" = "motor_vehicle_involved_with"
  #   )
  # })
    
  
  
  barPlotData = reactive({
    collisions %>% filter(is.na(!!sym(barplot_col_name[[input$selectBarPlot]])) == FALSE) %>%
      select(!!sym(barplot_col_name[[input$selectBarPlot]])) %>%
      group_by(!!sym(barplot_col_name[[input$selectBarPlot]])) %>% 
      summarize(totals = sum(n())) %>% 
      arrange(desc(totals))
  })
  
  output$barPlot = renderPlotly({
    barPlot = plot_ly(x = barPlotData()[, 1], y = barPlotData()$totals, type = 'bar') %>% 
      layout(title = input$selectBarPlot, yaxis = list(title = 'Count'))
  })
  
# show severity bar plot
  
  
  
# show cause of accident bar plot
  
  
  
# most popular crash victim
  
  
#----------HEAT MAP TAB ------------ 
  
  
  
  collisions_subset <- reactive({
    collisions %>%
      filter(collision_date >= input$date_range[1] &
               collision_date <= input$date_range[2])
  })
# show total killed info box 
  output$totalKilled = renderInfoBox({
    total_killed = collisions_subset() %>% summarize(sum(killed_victims))
    infoBox(total_killed, title = "TOTAL KILLED", icon = icon("fas fa-skull-crossbones"))
  })  
  
#show total injured info box
  output$totalInjured = renderInfoBox({
    # ped_injured = collisions %>% summarize(sum(pedestrian_injured_count))
    # bicycle_injured = collisions %>% summarize(sum(bicyclist_injured_count))
    # motorcycle_injured = collisions %>% summarize(sum(motorcyclist_injured_count))
    total_injured = collisions_subset() %>% summarize(sum(injured_victims))
    # text1 = HTML(paste(tags$h6(ped_injured, "pedestrians", br()),
    #                    tags$h6(bicycle_injured, "bicyclists", br()),
    #                    tags$h6(motorcycle_injured, "motorcyclists")
    #              ))
    infoBox(total_injured, title = "TOTAL INJURED", icon = icon("fas fa-user-injured"))
  })  
  
#show alcohol involved info box
  output$alcoholInvolved = renderInfoBox({
    alcohol_involved = collisions_subset() %>%filter(is.na(alcohol_involved) != TRUE) %>% summarise(sum(alcohol_involved))
    infoBox(alcohol_involved, title = "ALCOHOL INVOLVED", icon = icon("fas fa-wine-bottle"))
  })    
  
# show heat map
  output$heatMap<-renderLeaflet({
    leaflet(collisions_subset()) %>% setView(lng = -119.8, lat = 36.7, zoom = 6) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addHeatmap(lng = ~longitude, lat = ~latitude, 
                 minOpacity= ~input$opacity, blur = ~input$blur, radius = ~input$radius)
  })
  
#----------COVID IMPACT TAB ------------    
# show COVID year distribution
  
  

  
  
#----------DAYLIGHT SAVING TAB ---------  
# show  daylight saving box plot
  
  
  
  
})