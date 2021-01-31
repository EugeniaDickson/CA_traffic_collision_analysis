shinyUI(
  dashboardPage(
    skin = "black",
  dashboardHeader(title = "CA Road Accidents"),

  dashboardSidebar(
    sidebarUserPanel("Eugenia Dickson",
                     image = "./avatar.png"),
    sidebarMenu(
      menuItem("Time", tabName = "distributions", icon = icon("fal fa-chart-area")),
      menuItem("Top", tabName = "barcharts", icon = icon("bar-chart-o")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      # menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("COVID Impact", tabName = "covid", icon = icon("fas fa-viruses")),
      menuItem("Daylight Saving", tabName = "dls", icon = icon("fas fa-sun"))
                )#,
    # selectizeInput("selected",
    #                "Select Item to Display"
    #                )
                  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(column(12,
                       infoBoxOutput("totalKilled"),
                       infoBoxOutput("totalInjured"),
                       infoBoxOutput("alcoholInvolved"))),
              fluidRow(
                       column(12, 
                              sidebarPanel(width = 3, height = 500,
                                                   sliderInput("range", "Range:",
                                                               min = 1, max = 1000,
                                                               value = c(200,500)),
                                                   sliderInput("range", "Range:",
                                                               min = 1, max = 1000,
                                                               value = c(200,500))
                                           ),
                              box(height = 600, width = 9)
              ))),
      tabItem(tabName = "distributions",
              fluidRow(
                box(
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select severity level"), choices = severity_list, selected = "injury_all")),
                column(4, checkboxGroupInput(inputId='partiescheckb',label = h4("Select party"), choices = parties_list, selected = "party_all")),
                column(4, checkboxGroupInput(inputId='severitycheckb',label = h4("Select cause of crash"), choices = cause_crash, selected = "cause_all")),
                width = 12)),
              fluidRow(
                      box(htmlOutput("density_hourly"), width = 12, height = 300), #hourly distribution
                      box(htmlOutput("density_weekly"), width = 12, height = 300)  #weekly distribution
                      )
             ),
      tabItem(tabName = "barcharts",
              fluidRow(box(width = 12, height = 300)),
              fluidRow(box(width = 12, height = 300))
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