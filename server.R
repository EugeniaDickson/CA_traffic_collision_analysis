shinyServer(function(input, output){


  
  
# show weekly distribution plot
  densityDataWeek = reactive({
    collisions %>%
      filter(collision_severity %in% input$severitycheckb &
               pcf_violation_category %in% input$causecheckb &
               motor_vehicle_involved_with %in% input$partiescheckb) %>%
      group_by(weekdays)
  })
  
  output$weeklyDensity = renderPlot({
    densityDataWeek() %>% ggplot(aes(x = densityDataWeek()$weekdays, fill = densityDataWeek()$collision_severity)) +
      geom_density(alpha=0.1) +
      ggtitle("Weekly Accident Distribution") +
      xlab("Day of Week") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + 
      labs(fill = "Day of Week", color = "Day of Week")

  })
  
# show hourly distribution plot
  densityDataHour = reactive({
    collisions %>%
      filter(collision_severity %in% input$severitycheckb &
               pcf_violation_category %in% input$causecheckb &
               motor_vehicle_involved_with %in% input$partiescheckb) %>%
      group_by(collision_time)
  })
  
  output$hourlyDensity = renderPlot({
    densityDataHour() %>% ggplot(aes(x = densityDataHour()$collision_time, fill = densityDataHour()$collision_severity)) +
      geom_density(alpha=0.1) +
      ggtitle("Daily Accident Distribution") +
      xlab("Time of Day") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + 
      labs(fill = "Time of Day", color = "Day of Week")

  })

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
    
  
  ### VERSION 2 WORKING
  barPlotData = reactive({
    if (input$selectBarPlot == "Collision Severity") {
        data = collisions %>% filter(is.na(collision_severity) == FALSE) %>%
          mutate(colname = collision_severity) %>%
          group_by(colname) %>%
          summarize(totals = sum(n())) %>% 
          arrange(desc(totals))
        return(data)}
    if (input$selectBarPlot == "Party at Fault") {
        data = collisions %>% filter(is.na(statewide_vehicle_type_at_fault) == FALSE) %>%
          mutate(colname = statewide_vehicle_type_at_fault) %>%
          group_by(colname) %>%
          summarize(totals = sum(n())) %>% 
          arrange(desc(totals))
        return(data)}
    if (input$selectBarPlot == "Crash Cause") {
        data = collisions %>% filter(is.na(pcf_violation_category) == FALSE) %>%
          mutate(colname = pcf_violation_category) %>%
          group_by(colname) %>%
          summarize(totals = sum(n())) %>% 
          arrange(desc(totals))
        return(data)}
    if (input$selectBarPlot == "Parties involved") {
      data = collisions %>% filter(is.na(motor_vehicle_involved_with) == FALSE) %>%
          mutate(colname = motor_vehicle_involved_with) %>%
               group_by(colname) %>%
               summarize(totals = sum(n())) %>% 
        arrange(desc(totals))
             return(data)}
  })
  
  # sort bars by totals (I'm asking for too much to make it work)
  # xform = list(
  #   categoryorder = "array",
  #   categoryarray = barPlotData()$colname,
  #   title = "Party at Fault"
  # )

   output$barPlot = renderPlotly({
     barPlot = plot_ly(x = barPlotData()$colname, y = barPlotData()$totals, type = 'bar') %>%
       layout(title = input$selectBarPlot, yaxis = list(title = 'Count'))
   })
  
  ###### VERSION 1 SEMI-WORKING
  # barPlotData = reactive({
  #   collisions %>% filter(is.na(!!sym(barplot_col_name[[input$selectBarPlot]])) == FALSE) %>%
  #     select(!!sym(barplot_col_name[[input$selectBarPlot]])) %>%
  #     group_by(!!sym(barplot_col_name[[input$selectBarPlot]])) %>% 
  #     summarize(totals = sum(n())) %>% 
  #     arrange(desc(totals))
  # })
  # 
  # output$barPlot = renderPlotly({
  #   barPlot = plot_ly(x = barPlotData()[, 1], y = barPlotData()$totals, type = 'bar') %>% 
  #     layout(title = input$selectBarPlot, yaxis = list(title = 'Count'))
  # })
  
#----------HEAT MAP TAB ------------ 
  collisions_subset = reactive({
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
    total_injured = collisions_subset() %>% summarize(sum(injured_victims))
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