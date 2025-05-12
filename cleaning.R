library(tidyverse)
library(abind)
library(lubridate)
# if statement to get directory in right place (will do later)

setwd("raw_data")

# must combine the following data sets by state and by year.
legal <- read.csv("AGA-LegalizationData.csv")
pop <- read.csv("all_states_population.csv")
unemp <- read.csv("all_states_unemployed.csv")
edu <- read.csv("all_states_education.csv")
rgdp <- read.csv("all_states_rgdp.csv")
stateid <- read.csv("states.csv")

# Step 1: Combining legal data with state id
# renaming the stateid dataframe
names(stateid) <- c("state", "abbrev")
df <- left_join(stateid, legal, by = 'state') %>%
  filter(!(abbrev == "DC"))


# Step 2: Converting all datetime objects to just year and renaming columns of values.
pop <- pop %>% 
  mutate(date = year(date)) %>%
  rename("population" = "value") 

unemp <- unemp %>%
  mutate(date = year(as.Date(date))) %>%
  rename("unemployment" = "value")

edu <- edu %>%
  mutate(date = year(as.Date(date))) %>%
  rename("bachelors" = "value")

rgdp <- rgdp %>%
  mutate(date = year(as.Date(date))) %>%
  rename("rgdp_2017" = "value") #chained to 2017

# Step 3: Assemble all fred data and then assemble with gambling data.
fred_list <- list(pop, unemp, edu, rgdp)
df_fred <- Reduce(function(x,y) merge(x,y, all = TRUE), fred_list)
# intermediary step: rename state to abbrev and filter to just 2000
df_fred <- df_fred %>%
  filter(date > 1999) %>%
  rename("abbrev" = "state") %>%
  na.omit() # omits the NAs, which only occur legitimately here.


df_clean <- left_join(df_fred, df, by = "abbrev")


write.csv(df_clean, "../clean_data/df_clean.csv", row.names = F)
# small test, comment to exclude
# df_clean %>% filter(abbrev == "IA") #Iowa, it works.
