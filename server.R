shinyServer(function(input, output){

  # show weekly distribution plot
  densityDataWeek = reactive({
    densityDataWeek = collisions %>%
      filter(collision_severity %in% input$severitycheckb &
               pcf_violation_category %in% input$causecheckb &
               motor_vehicle_involved_with %in% input$partiescheckb) %>%
      group_by(weekdays) %>% summarize(density = sum(n())*100/nrow(collisions)) %>% 
      mutate(weekdays = factor(weekdays, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")))
  })
  
  output$weeklyDensity = renderPlot({
    densityDataWeek() %>% ggplot() +
      geom_bar(aes(x = densityDataWeek()$weekdays, y = densityDataWeek()$density), stat = 'identity', color = "black", fill = "#E5989B", alpha = 0.5) +
      ggtitle("Accident Distribution by Weekdays") +
      xlab("Day of Week") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + theme_bw()
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
      ggtitle("Accident Distribution by Time of Day") +
      xlab("Time of Day") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + 
      labs(fill = "Time of Day", color = "Day of Week") + theme_bw()
  })

  # show barplots by selected category (severity)
  barPlotData = reactive({
    if (input$selectBarPlot == "Collision Severity") {
        data = collisions %>% filter(is.na(collision_severity) == FALSE, str_length(collision_severity) > 1) %>%
          mutate(colname = collision_severity) %>%
          group_by(colname) %>%
          summarize(totals = round(sum(n())*100/nrow(collisions), 2)) %>% 
          arrange(desc(totals)) %>% mutate(colname = factor(colname, levels = (colname)))
        return(data)}
    if (input$selectBarPlot == "Party at Fault") {
        data = collisions %>% filter(is.na(statewide_vehicle_type_at_fault) == FALSE) %>%
          mutate(colname = statewide_vehicle_type_at_fault) %>%
          group_by(colname) %>%
          summarize(totals = round(sum(n())*100/nrow(collisions), 2)) %>% 
          arrange(desc(totals)) %>% mutate(colname = factor(colname, levels = (colname)))
        return(data)}
    if (input$selectBarPlot == "Crash Cause") {
        data = collisions %>% filter(is.na(pcf_violation_category) == FALSE) %>%
          mutate(colname = pcf_violation_category) %>%
          group_by(colname) %>%
          summarize(totals = round(sum(n())*100/nrow(collisions), 2)) %>% 
          arrange(desc(totals)) %>% mutate(colname = factor(colname, levels = (colname)))
        return(data)}
    if (input$selectBarPlot == "Parties involved") {
      data = collisions %>% filter(is.na(motor_vehicle_involved_with) == FALSE, str_length(motor_vehicle_involved_with) > 1) %>%
          mutate(colname = motor_vehicle_involved_with) %>%
               group_by(colname) %>%
               summarize(totals = round(sum(n())*100/nrow(collisions), 2)) %>% 
        arrange(desc(totals)) %>% mutate(colname = factor(colname, levels = (colname)))
             return(data)}
  })

   output$barPlot = renderPlotly({
     barPlot = plot_ly(x = barPlotData()$colname, y = barPlotData()$totals, type = 'bar') %>%
       layout(title = input$selectBarPlot, yaxis = list(title = 'Percent'))
   })
  
  #----------HEAT MAP TAB ------------ 
  collisions_subset = reactive({
    collisions %>%
      filter(collision_date >= input$date_range[1] &
               collision_date <= input$date_range[2])
  })

  # show total accidents info box 
  output$totalAccidents = renderInfoBox({
    infoBox(nrow(collisions_subset()), title = "TOTAL ACCIDENTS", icon = icon("fas fa-car-crash"))
  })  
  # show total killed info box  
  output$totalKilled = renderInfoBox({
    total_killed = collisions_subset() %>% summarize(sum(killed_victims))
    infoBox(paste0(total_killed, " / ", round(total_killed*100/nrow(collisions_subset()), 2), "%"), title = "TOTAL KILLED", icon = icon("fas fa-skull-crossbones"))
  })  
  
  # show total injured info box
  output$totalInjured = renderInfoBox({
    total_injured = collisions_subset() %>% summarize(sum(injured_victims))
    infoBox(paste0(total_injured, " / ", round(total_injured*100/nrow(collisions_subset()), 2), "%"), title = "TOTAL INJURED", icon = icon("fas fa-user-injured"))
  })  
  
  # show alcohol involved info box
  output$alcoholInvolved = renderInfoBox({
    alcohol_involved = collisions_subset() %>%filter(is.na(alcohol_involved) != TRUE) %>% summarise(sum(alcohol_involved))
    infoBox(paste0(alcohol_involved, " / ", round(alcohol_involved*100/nrow(collisions_subset()), 2), "%"), title = "ALCOHOL INVOLVED", icon = icon("fas fa-wine-bottle"))
  })    
  
  # show heat map
  output$heatMap<-renderLeaflet({
    leaflet(collisions_subset()) %>% setView(lng = -122.37, lat = 37.81, zoom = 9) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addHeatmap(lng = ~longitude, lat = ~latitude, 
                 minOpacity= ~input$opacity, blur = ~input$blur, radius = ~input$radius)
  })
  
  #----------COVID IMPACT TAB ------------    
  # show COVID year distribution
  xticks = unique(floor_date(collisions$collision_date, "month"))

  output$covidDistr = renderPlot({
    collisions %>%
      ggplot(aes(collision_date)) +
      geom_density(fill = "red", alpha = 0.5) +
      ggtitle("Year Accident Distribution") +
      xlab("Year and Month") + ylab("Percent of Accidents") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + 
      labs(fill = "Day of Week", color = "Day of Week") +
      theme_bw() +
      theme(axis.text.x = element_text(size = 12, angle = 90)) +
      scale_x_continuous(labels = xticks, breaks = xticks) +
      annotate(geom = "vline",
               x = COVID_milestones$date,
               xintercept = COVID_milestones$date,
               linetype = "dashed") +
      annotate(geom = "text",
               label = COVID_milestones$name,
               x = COVID_milestones$date,
               y = 0.0007,
               angle = 90,
               vjust = 1.3) + 
      annotate(geom = "text",
               label = as.character(COVID_milestones$date),
               x = COVID_milestones$date,
               y = 0.0007,
               angle = 90,
               vjust = -0.9)
  })
  
  # show monthly traffic volume plot
  output$trafficVol = renderPlot(
    traffic_vol %>% ggplot(aes(x = date, y = season_adj_vmt)) + geom_line(color="black", size = 1) + geom_point(size = 2) +
      ggtitle("Monthly Traffic Volume") +
      xlab("Year and Month") + ylab("Total Miles Travelled (Billion Miles)") +
      theme(plot.title = element_text(hjust = 0.5, size = 30, face = 'bold'),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20)) + theme_bw() +
      theme(axis.text.x = element_text(size = 12, angle = 90)) +
      scale_x_continuous(labels = xticks, breaks = xticks) +
      annotate(geom = "vline",
               x = COVID_milestones$date,
               xintercept = COVID_milestones$date,
               linetype = "dashed") +
      annotate(geom = "text",
               label = COVID_milestones$name,
               x = COVID_milestones$date,
               y = 200000,
               angle = 90,
               vjust = 1.3) + 
      annotate(geom = "text",
               label = as.character(COVID_milestones$date),
               x = COVID_milestones$date,
               y = 200000,
               angle = 90,
               vjust = -0.9)
  )

})