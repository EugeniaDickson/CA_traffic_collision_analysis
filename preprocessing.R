library(DBI)
library(RSQLite)
library(lubridate)


##########################################################
######## California Traffic Collision Data_SWITRS ########
##########################################################

#connect to sqlite database
con <- dbConnect(SQLite(), "./switrs.sqlite")

# Show List of Tables
tables = as.data.frame(dbListTables(con))

# Get table
collisions = dbReadTable(con, 'collisions')
victims = dbReadTable(con, 'victims')
parties = dbReadTable(con, 'parties')
# case_ids = dbReadTable(con, 'case_ids')

#filtering only accidents that happened in 2018-2021 years
collisions_2018_2020 = collisions %>% filter(collision_date > "2018-01-01" & collision_date < "2021-02-01")

#ridding of accidents that don't have location
collisions_2018_2020 = collisions_2018_2020 %>% filter(is.na(latitude) != TRUE, is.na(longitude) != TRUE)

# Get column names for all tables
names_collisions = names(collisions_2018_2020)
names_victims = names(victims)
names_parties = names(parties)

# data is fetched so disconnect it.
dbDisconnect(con)

write.csv(collisions_2018_2020, "./collisions_2018_2020.csv")

