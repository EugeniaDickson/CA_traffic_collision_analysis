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
write.csv(names_collisions, "./names_collisions.csv", row.names = FALSE)

collisions$jurisdiction = as.character(collisions$jurisdiction)
collisions$county_city_location = as.character(collisions$county_city_location)

jur_unique = collisions %>% summarize(jurisdiction = unique(jurisdiction)) %>% arrange(jurisdiction)
county_city_location_unique = collisions %>% summarize(county_city_location = unique(county_city_location)) %>% arrange(county_city_location)
write.csv(names_collisions, "./jur_unique.csv", row.names = FALSE)
write.csv(names_victims, "./county_city_location_unique.csv", row.names = FALSE)
##########################################################

############## SELECTING DESIRED COLUMNS #################
select_collisions = c("collision_severity",
                      "killed_victims",
                      "injured_victims",
                      "pcf_violation_category",
                      "type_of_collision",
                      "motor_vehicle_involved_with",
                      "lighting",
                      "alcohol_involved",
                      "latitude",
                      "longitude",
                      "collision_date",
                      "collision_time"
)

#selecting desired columns in the table
collisions = collisions %>% select(all_of(select_collisions))
##########################################################

#exporting selection to csv for further processing
write.csv(collisions_2019_2021, "./collisions_2019_2021.csv", row.names = FALSE)


