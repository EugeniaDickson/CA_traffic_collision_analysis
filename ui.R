shinyUI(
  dashboardPage(
  dashboardHeader(title = "CA Road Accidents"),

  dashboardSidebar(
    sidebarUserPanel("Eugenia Dickson",
                     image = "./avatar.png"),
    sidebarMenu(
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Top", tabName = "barcharts", icon = icon("bar-chart-o")),
      menuItem("Time", tabName = "distributions", icon = icon("fal fa-chart-area")),
      menuItem("COVID Impact", tabName = "covid", icon = icon("fas fa-viruses")),
      menuItem("Daylight Saving", tabName = "dls", icon = icon("fas fa-sun"))
                )
                  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(infoBoxOutput("totalKilled"),
                       infoBoxOutput("totalInjured"),
                       infoBoxOutput("alcoholInvolved")),
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
                       box(height = 450, width = 10, leafletOutput("heatMap"))
                        )),
      tabItem(tabName = "distributions",
              fluidRow(
                box(
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select severity level"), choices = severity_list, selected = "injury_all")),
                column(4, checkboxGroupInput(inputId='partiescheckb',label = h4("Select party"), choices = parties_list, selected = "party_all")),
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select cause of crash"), choices = cause_crash, selected = "cause_all")),
                width = 12)),
              fluidRow(
                      box(plotlyOutput("hourlyDensity"), width = 12, height = 300), #hourly distribution
                      box(plotlyOutput("weeklyDensity"), width = 12, height = 300)  #weekly distribution
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
                box(height = 300, width = 12))
              ),
      tabItem(tabName = "dls",
              fluidRow(
                box(height = 300,width = 12)
                      )
              )
            )
  )
))