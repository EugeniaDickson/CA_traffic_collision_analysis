library(tidyverse)
library(lubridate)
library(shiny)
library(shinydashboard)
# library(DT)
# library(googleVis)
# library(shinythemes)
library(plotly)
library(leaflet)
# library(leaflet.extras)

collisions = read.csv("./collisions_2019_2021.csv", stringsAsFactors = FALSE) %>% 
  mutate(collision_date = parse_date(collision_date, "%m/%d/%Y"),
         collision_time = parse_time(collision_time),
         weekdays = weekdays(collision_date)) %>%
  mutate(timestamp = paste0(collision_date, " ", collision_time))
COVID_shelter_order = parse_date(c("2020-01-25", "2020-3-17"), "%Y-%m-%d")

# traffic_vol = read.csv("./monthly_traffic_volumes_2018_2020.csv") %>% mutate(date = parse_date(date))
# daylight_saving = read.csv("./daylight_savings.csv") %>% mutate(date = parse_date(date, "%m/%d/%Y"))

severity_list = list(
  # "All" = "injury_all",
  "Fatal injury" = "fatal",
  "Severe injury" = "severe injury",
  "Light injury" = "pain",
  "No injuries"  = "property damage only")

parties_list = list(
  # "All" = "party_all",
  "Pedestrian" = "pedestrian",
  "Bicycle" = "bicycle",
  "Other motor vehicle"  = "other motor vehicle")

cause_crash = list(
  # "All" = "cause_all",
  "Drunk driving" = "dui",
  "Speeding" = "speeding",
  "Following too closely" = "following too closely",
  "Right of way" = "automobile right of way",
  "Wrong side of road" = "wrong side of road",
  "Pedestrian violation" = "pedestrian violation")

barplot_list = c(
  "Collision Severity", 
  "Party at Fault", 
  "Crash Cause", 
  "Parties involved")


# ### VERSION 1 SEMI-WORKING
# barplot_col_name = list("Collision Severity" = "collision_severity",
#                         "Party at Fault" = "statewide_vehicle_type_at_fault",
#                         "Crash Cause" = "pcf_violation_category",
#                         "Victims" = "motor_vehicle_involved_with")

# ## VERSION 2 NOT-WORKING
# barplot_col_name = list("Collision Severity",
#                         "Party at Fault",
#                         "Crash Cause",
#                         "Victims")