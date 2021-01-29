library(tidyverse)

# Loading previously exported csv's:
collisions = read.csv("./collisions_2018_2020.csv")
victims = read.csv("./victims_2018_2020.csv")
parties = read.csv("./parties_2018_2020.csv")

# exporting column names for a data map
names_collisions = names(collisions)
names_victims = names(victims)
names_parties = names(parties)
write.csv(names_collisions, "./names_collisions.csv", row.names = FALSE)
write.csv(names_victims, "./names_victims.csv", row.names = FALSE)
write.csv(names_parties, "./names_parties.csv", row.names = FALSE)

#changing data types for jurisdiction and county_city_location codes
collisions$jurisdiction = as.character(collisions$jurisdiction)
collisions$county_city_location = as.character(collisions$county_city_location)
class(collisions$county_city_location)
class(collisions$jurisdiction)

#exporting unique jurisdiction and county_city_location codes
jur_unique = collisions %>% summarize(jurisdiction = unique(jurisdiction)) %>% arrange(jurisdiction)
county_city_location_unique = collisions %>% summarize(county_city_location = unique(county_city_location)) %>% arrange(county_city_location)
write.csv(names_collisions, "./jur_unique.csv", row.names = FALSE)
write.csv(names_victims, "./county_city_location_unique.csv", row.names = FALSE)

#creating vectors with desired column names
select_collisions = c("case_id",
                      "jurisdiction",
                      "population",
                      "county_city_location",
                      "intersection",
                      "weather_1",
                      "weather_2",
                      "tow_away",
                      "collision_severity",
                      "killed_victims",
                      "injured_victims",
                      "party_count",
                      "primary_collision_factor",
                      "pcf_violation_category",
                      "hit_and_run",
                      "type_of_collision",
                      "motor_vehicle_involved_with",
                      "pedestrian_action",
                      "road_surface",
                      "road_condition_1",
                      "road_condition_2",
                      "lighting",
                      "pedestrian_collision",
                      "bicycle_collision",
                      "motorcycle_collision",
                      "truck_collision",
                      "alcohol_involved",
                      "statewide_vehicle_type_at_fault",
                      "chp_vehicle_type_at_fault",
                      "severe_injury_count",
                      "other_visible_injury_count",
                      "complaint_of_pain_injury_count",
                      "pedestrian_killed_count",
                      "pedestrian_injured_count",
                      "bicyclist_killed_count",
                      "bicyclist_injured_count",
                      "motorcyclist_killed_count",
                      "motorcyclist_injured_count",
                      "latitude",
                      "longitude",
                      "collision_date",
                      "collision_time"
                    )

select_parties = c( "id",
                    "case_id",
                    "party_number",
                    "party_type",
                    "at_fault",
                    "party_sex",
                    "party_age",
                    "party_sobriety",
                    "party_drug_physical",
                    "party_safety_equipment_1",
                    "party_safety_equipment_2",
                    "cellphone_use",
                    "other_associate_factor_1",
                    "other_associate_factor_2",
                    "party_number_killed",
                    "party_number_injured",
                    "movement_preceding_collision",
                    "vehicle_year",
                    "vehicle_make",
                    "statewide_vehicle_type"
                    )

#selecting desired columns in the tables (all cols from victims table)
collisions = collisions %>% select(all_of(select_collisions))
parties = parties %>% select(all_of(select_parties))

