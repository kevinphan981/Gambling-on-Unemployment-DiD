library(fredr)
library(tidyverse)
library(purrr)

api_key <- getOption("fred_api_key")
fredr_set_key(api_key)

#####
# I don't think this is particularly useful, but it is there.
fredr(
  series_id = "UNRATE"
)
#####

state_abbr <- c(
  "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
  "HI","ID","IL","IN","IA","KS","KY","LA","ME","MD",
  "MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
  "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
  "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"
)
state_series_ids_edu <- paste0("GCT1502", state_abbr)
all_states_df <- data.frame()

for (i in seq_along(state_series_ids_edu)) {
  state_data <- fredr(series_id = state_series_ids_edu[i], frequency = "a")
  state_data$state <- state_abbr[i]
  all_states_df <- dplyr::bind_rows(all_states_df, state_data)
}
head(all_states_df)

all_states_df <- all_states_df %>%
  select(date, state, value)

write.csv(all_states_df, "all_states_education.csv", row.names = FALSE)



