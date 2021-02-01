library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
library(googleVis)
library(shinythemes)
library(plotly)
library(leaflet)
library(leaflet.extras)

collisions = read.csv("./collisions_2019_2021.csv", stringsAsFactors = FALSE) %>% 
  mutate(collision_date = parse_date(collision_date, "%m/%d/%Y"),
         collision_time = parse_time(collision_time),
         weekdays = weekdays(collision_date)) %>%
  mutate(timestamp = paste0(collision_date, " ", collision_time))


traffic_vol = read.csv("./monthly_traffic_volumes_2018_2020.csv") %>% mutate(date = parse_date(date))
daylight_saving = read.csv("./daylight_savings.csv") %>% mutate(date = parse_date(date, "%m/%d/%Y"))

severity_list = list(
  "All" = "injury_all",
  "Fatal injury" = "injury_fatal",
  "Severe injury" = "injury_severe",
  "Light injury" = "injury_light",
  "No injuries" = "injury_none")

parties_list = list(
  "All" = "party_all",
  "Pedestrian" = "party_ped",
  "Bicycle" = "party_bicycle",
  "Other motor vehicle" = "party_vehicle"
)

cause_crash = list(
  "All" = "cause_all",
  "Drunk driving" = "cause_dui",
  "Speeding" = "cause_speeding",
  "Following too closely" = "cause_following",
  "Right of way" = "cause_rightow",
  "Wrong side of road" = "cause_wrongside",
  "Pedestrian violation" = "cause_pedviol"
)

barplot_list = c(
  "Collision Severity", 
  "Party at Fault", 
  "Crash Cause", 
  "Victims")

barplot_col_name = list("Collision Severity" = "collision_severity",
                        "Party at Fault" = "statewide_vehicle_type_at_fault",
                        "Crash Cause" = "pcf_violation_category",
                        "Victims" = "motor_vehicle_involved_with")