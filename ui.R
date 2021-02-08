shinyUI(
  dashboardPage(
  dashboardHeader(title = "CA Road Accidents"),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("fas fa-info-circle")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Timeline distribution", tabName = "distributions", icon = icon("fal fa-chart-area")),
      menuItem("Ratings", tabName = "barcharts", icon = icon("bar-chart-o")),
      menuItem("COVID Impact", tabName = "covid", icon = icon("fas fa-viruses")),
      menuItem("Resources", tabName = "resources", icon = icon("fas fa-database"))
                )
                  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "intro",
              fluidRow(
                box(width = 12,
                    div(
                      h2("Introduction", align = "center"),
                      column(width = 3,
                        img(src="./traffic.jpg", width = "100%", align = 'left')),
                      column(width = 6,
                             h4(
                          tags$ul(
                            tags$li("Average number of car accidents in the U.S. every year is 6 million"),
                            tags$li("More than 90 people die and 3 million get injured every day in car accidents"),
                            tags$li("1 in 7 people do not wear a seatbelt while driving"),
                            tags$li("More than half of all road traffic deaths are among vulnerable road users: pedestrians, cyclists, and motorcyclists"),
                          )),
                          h4(p("One of the primary agencies that conducts research on roadway and driver safety is the National Highway Traffic Safety Administration. 
                                In a study looking at critical reasons of car accidents, they found that 94% of car accidents are caused by drivers. 
                                Vehicles, environmental factors, and other unknown reasons are responsible for 2% of crashes each."),
                             p("The data analyzed in this project comes from the Statewide Integrated Traffic Records System (SWITRS). 
                               It's been carefully collected by California Highway Patrol, whose mission is to provide the highest 
                               level of Safety, Service, and Security."),
                             p("This database contains in-depth information about each traffic accident: road and weather conditions, 
                             causes, violations and other circumstances. An analysis of this data can help answer questions such as 
                             whom is the most frequent party at fault, what are most frequent causes of accidents, 
                                on which day and time the risk of getting in an accident is higher, and many-many others.")
                          ),
                    )
              )))),
      tabItem(tags$style(type = "text/css", "#heatMap {height: calc(100vh - 185px) !important;}"),
              tabName = "map",
              div(class="outer",
                  fluidRow(infoBoxOutput("totalAccidents", width = 3),
                           infoBoxOutput("totalKilled", width = 3),
                           infoBoxOutput("totalInjured", width = 3),
                           infoBoxOutput("alcoholInvolved", width = 3)),
                  leafletOutput(outputId = "heatMap")),

              absolutePanel(class = "inner", id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                            top = 180, left = 300, right = "auto", bottom = "auto",
                            width = 300, height = "auto", padding = 50,
                            div(style = "margin: auto; width: 80%", 
                                h5(p("This heatmap shows density of car accidents within selected time range, 
                                     and the boxes on top show accident aftermath statistics of that period.
                                     The range can be set to one day."),
                                   p("Opacity, Radius and Blur sliders drive the visual representation of the congested areas."),
                                   br()),
                                sliderInput("date_range", "Select Time Range:",
                                            min = min(collisions$collision_date), 
                                            max = max(collisions$collision_date),
                                            value = c(min(collisions$collision_date), 
                                                      max(collisions$collision_date))),
                                sliderInput("opacity", "Opacity:",
                                            min = 0, max = 1,
                                            value = 0.5, step = 0.05,
                                            width = "100%"),
                                sliderInput("radius", "Radius:",
                                            min = 0, max = 6,
                                            value = 3, step = 0.25,
                                            width = "100%"),
                                sliderInput("blur", "Blur:",
                                            min = 0, max = 7,
                                            value = 4, step = 0.25,
                                            width = "100%")))
      ),
      tabItem(tabName = "distributions",
              fluidRow(
                box(
                h2("Hourly and Weekday Accident Distributions", align = "center"),
                h4("This tab shows hour and weekday distributions of accidents by selected factors. 
                          Please select one or more factors for each group to see the graphs.", align = "center"),
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select severity level"), choices = severity_list, selected = "fatal")),
                column(4, checkboxGroupInput(inputId='partiescheckb',label = h4("Select party"), choices = parties_list, selected = "pedestrian")),
                column(4, checkboxGroupInput(inputId='causecheckb',label = h4("Select cause of crash"), choices = cause_crash, selected = "dui")),
                width = 12)),
              fluidRow(
                      box(plotOutput("hourlyDensity"), width = 6, height = 450), #hourly distribution
                      box(plotOutput("weeklyDensity"), width = 6, height = 450)  #weekly distribution
                      )
             ),
      tabItem(tabName = "barcharts",
              fluidRow(
                box(width = 12,
                    h2("Accident Bar Charts", align = "center"),
                    column(6,
                    selectizeInput("selectBarPlot", label = "Select Item", 
                                   choices = barplot_list, selected = "Collision Severity"))
                    )
              ),
              fluidRow(
                box(width = 12,
                plotlyOutput("barPlot", width = "100%", height = 700))
                )
              ),
      tabItem(tabName = "covid",
              fluidRow(
                
                box(width = 12,
                    h2("COVID impact on Traffic Accident Distribution", align = "center"),
                    plotOutput("covidDistr", width = "100%", height = 400),
                    plotOutput("trafficVol", width = "100%", height = 400))
                )
              ),
      tabItem(tabName = "resources",
        box(width = 12, height = "100%",
            h2("Resources", align = "center"),
            div(width = 6, align = "center",
            a(href = "https://www.kaggle.com/alexgude/california-traffic-collision-data-from-switrs", "CA TRAFFIC COLLISION DATASET AND INSPIRATION"), br(),
            a(href = "https://www.chp.ca.gov/programs-services/services-information/switrs-internet-statewide-integrated-traffic-records-system", "SWITRS"), br(),
            a(href = "https://www.driverknowledge.com/road-accidents-usa/", "US TRAFFIC ACCIDENT STATISTICS"), br(),
            a(href = "https://dot.ca.gov/programs/traffic-operations/census/mvmt", "CALTRANS TRAFFIC VOLUME DATA"), br(),
            a(href = "https://www.bcmlawyers.com/what-percentage-of-car-accidents-are-caused-by-human-error/", "ARTICLE ABOUT HUMAN ERROR ON THE ROADS"),
            h2("STAY SAFE!", align = "center")))
            )
            )
  )
))
