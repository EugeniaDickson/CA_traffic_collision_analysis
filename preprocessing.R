library(DBI)
library(RSQLite)

##########################################################
######## California Traffic Collision Data_SWITRS ########
########       Loading data from SQLite           ########
##########################################################

#connect to sqlite database
con = dbConnect(SQLite(), "./switrs.sqlite")

# Show List of Tables
tables = as.data.frame(dbListTables(con))

# Get table
collisions = dbReadTable(con, 'collisions')
victims = dbReadTable(con, 'victims')
parties = dbReadTable(con, 'parties')
# case_ids = dbReadTable(con, 'case_ids')

# data is fetched so disconnect it.
dbDisconnect(con)
##########################################################

#filtering only accidents that happened in mid-2019 - 2021 years that have time stamps and location
collisions_2019_2021 = collisions %>% 
  filter(collision_date >= "2019-03-01" & collision_date <= "2021-01-01") %>% 
  filter(is.na(collision_time) == FALSE) %>%
  filter(is.na(latitude) != TRUE, is.na(longitude) != TRUE)

### EXTRACTING SOME DATA FOR ANALYSIS ###
names_collisions = names(collisions)
names_victims = names(victims)
names_parties = names(parties)
write.csv(names_collisions, "./names_collisions.csv", row.names = FALSE)
write.csv(names_victims, "./names_victims.csv", row.names = FALSE)
write.csv(names_parties, "./names_parties.csv", row.names = FALSE)

collisions$jurisdiction = as.character(collisions$jurisdiction)
collisions$county_city_location = as.character(collisions$county_city_location)

jur_unique = collisions %>% summarize(jurisdiction = unique(jurisdiction)) %>% arrange(jurisdiction)
county_city_location_unique = collisions %>% summarize(county_city_location = unique(county_city_location)) %>% arrange(county_city_location)
write.csv(names_collisions, "./jur_unique.csv", row.names = FALSE)
write.csv(names_victims, "./county_city_location_unique.csv", row.names = FALSE)
##########################################################

############## SELECTING DESIRED COLUMNS #################
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
##########################################################

# get case_id's from selected cases:
case_ids = data.frame(case_id = collisions_2019_2021$case_id)

#filter victims and parties tables by selected case_id's
victims_2019_2021 = inner_join(victims, case_ids, by = "case_id")
parties_2019_2021 = inner_join(parties, case_ids, by = "case_id")

#exporting selection to csv for further processing
write.csv(collisions_2019_2021, "./collisions_2019_2021.csv", row.names = FALSE)
write.csv(victims_2019_2021, "./victims_2019_2021.csv", row.names = FALSE)
write.csv(parties_2019_2021, "./parties_2019_2021.csv", row.names = FALSE)


