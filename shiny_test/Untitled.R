runApp("/Users/wnowak/opportunity/shiny_test")

library(maps)
library(mapproj)
source("/Users/wnowak/opportunity/shiny_test/data/helpers.R")
counties <- readRDS("/Users/wnowak/opportunity/shiny_test/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")

map("county")