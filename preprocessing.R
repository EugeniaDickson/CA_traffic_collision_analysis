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

#filtering only accidents that happened in 2018-2021 years
collisions_2018_2020 = collisions %>% filter(collision_date > "2018-01-01" & collision_date < "2021-02-01")

#ridding of accidents that don't have location
collisions_2018_2020 = collisions_2018_2020 %>% filter(is.na(latitude) != TRUE, is.na(longitude) != TRUE)

# data is fetched so disconnect it.
dbDisconnect(con)

# get case_id's from selected cases:
case_ids = data.frame(case_id = collisions_2018_2020$case_id)

#filter victims and parties tables by selected case_id's
victims_2018_2020 = inner_join(victims, case_ids, by = "case_id")
parties_2018_2020 = inner_join(parties, case_ids, by = "case_id")

#exporting selection to csv for further processing
write.csv(collisions_2018_2020, "./collisions_2018_2020.csv", row.names = FALSE)
write.csv(victims_2018_2020, "./victims_2018_2020.csv", row.names = FALSE)
write.csv(parties_2018_2020, "./parties_2018_2020.csv", row.names = FALSE)
