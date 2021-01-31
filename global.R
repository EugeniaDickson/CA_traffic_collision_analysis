library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
library(googleVis)
library(shinythemes)

collisions = read.csv("./collisions_2019_2021.csv") %>% 
  mutate(collision_date = parse_date(collision_date, "%Y-%m-%d"),
         collision_time = parse_time(collision_time),
         weekdays = weekdays(collision_date))
traffic_vol = read.csv("./monthly_traffic_volumes_2018_2020.csv") %>% mutate(date = parse_date(date))
daylight_saving = read.csv("./daylight_savings.csv") %>% mutate(date = parse_date(date))

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