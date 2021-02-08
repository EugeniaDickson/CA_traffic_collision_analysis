library(tidyverse)
library(lubridate)
library(shiny)
library(shinydashboard)
library(hms)
library(plotly)
library(leaflet)
library(leaflet.extras)

collisions = read.csv("./collisions_2019_2021.csv", stringsAsFactors = FALSE) %>% 
  mutate(collision_date = parse_date(collision_date, "%m/%d/%Y"),
         collision_time = parse_time(collision_time),
         weekdays = weekdays(collision_date)) %>%
  mutate(timestamp = paste0(collision_date, " ", collision_time))
COVID_milestones = read.csv("./covid_milestones.csv", stringsAsFactors = FALSE) %>% mutate(date = parse_date(date, "%Y-%m-%d"))
traffic_vol = read.csv("./monthly_traffic_volumes_2019_2020.csv") %>% mutate(date = parse_date(date, "%Y-%m-%d"))

#------------------INPUT LISTS-------------------
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
  "Other motor vehicle"  = "other motor vehicle",
  "Fixed object" = "fixed object",
  "Parked vehicle" = "parked motor vehicle",
  "Other object" = "other object")

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