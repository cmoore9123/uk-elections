library(CmooreFunctions)
basicSetup()

file.choose()

results_raw <- read.csv("C:\\Users\\C6728215\\Documents\\WBI\\UK election data\\1918-2017election_results.csv",
                        stringsAsFactors = FALSE)

results_cleaned <- results_raw %>% 
  filter(election >= 1979) %>% 
  select(-seats, -boundary_set, -X) %>% 
  rename(constituency_id = 1)

c_ids <- results_cleaned %>% 
  filter(election == 2017) %>% 
  select(constituency_id, constituency)

results_with_ids <- results_cleaned %>% 
  select(-constituency_id) %>% 
  merge(c_ids) %>% 
  select(16, 17, 1:15)

write.csv(results_with_ids, 
          "C:\\Users\\C6728215\\Documents\\WBI\\UK election data\\cleaned results data.csv")

