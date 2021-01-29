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