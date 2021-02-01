shinyUI(
  dashboardPage(
  dashboardHeader(title = "CA Road Accidents"),
  dashboardSidebar(
    sidebarUserPanel("Eugenia Dickson",
                     image = "./avatar.png"),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Timeline distribution", tabName = "distributions", icon = icon("fal fa-chart-area")),
      menuItem("Ratings", tabName = "barcharts", icon = icon("bar-chart-o")),
      menuItem("COVID Impact", tabName = "covid", icon = icon("fas fa-viruses"))
      # menuItem("Daylight Saving", tabName = "dls", icon = icon("fas fa-sun"))
                )
                  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(infoBoxOutput("totalAccidents", width = 3),
                       infoBoxOutput("totalKilled", width = 3),
                       infoBoxOutput("totalInjured", width = 3),
                       infoBoxOutput("alcoholInvolved", width = 3)),
              fluidRow(sidebarPanel(width = 2,
                                    sliderInput("date_range", "Select Time Range:",
                                               min = min(collisions$collision_date), 
                                               max = max(collisions$collision_date),
                                               value = c(min(collisions$collision_date), 
                                                         max(collisions$collision_date))),
                                     sliderInput("opacity", "Opacity:",
                                                 min = 0, max = 1,
                                                 value = 0.5, step = 0.05),
                                     sliderInput("radius", "Radius:",
                                                 min = 0, max = 6,
                                                 value = 3, step = 0.25),
                                     sliderInput("blur", "Blur:",
                                                 min = 0, max = 7,
                                                 value = 4, step = 0.25),
                                               ),
                       box(width = 10, leafletOutput("heatMap"))
                        )),
      tabItem(tabName = "distributions",
              fluidRow(
                box(
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select severity level"), choices = severity_list, selected = "fatal")),
                column(4, checkboxGroupInput(inputId='partiescheckb',label = h4("Select party"), choices = parties_list, selected = "pedestrian")),
                column(4, checkboxGroupInput(inputId='causecheckb',label = h4("Select cause of crash"), choices = cause_crash, selected = "dui")),
                width = 12)),
              fluidRow(
                      box(plotOutput("hourlyDensity"), width = 6, height = 600), #hourly distribution
                      box(plotOutput("weeklyDensity"), width = 6, height = 600)  #weekly distribution
                      )
             ),
      tabItem(tabName = "barcharts",
              fluidRow(
                box(width = 12, height = 100,
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
                box(height = 50, width = 12,
                    title = "COVID IMPACT ON TRAFFIC ACCIDENT FREQUENCY"),
                box(width = 12,
                    plotOutput("covidDistr", width = "100%", height = 700))
                )
              )
      # tabItem(tabName = "dls",
      #         fluidRow(
      #           box(height = 300,width = 12)
      #                 )
      #         )
            )
  )
))
