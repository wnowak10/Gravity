getwd()
demo_data=readRDS("data/demo_data.rds")
head(demo_data)
election <- read.csv("data/election_2016_county.csv")
head(election)

# clean election data!
# dcast to switch to wide format
el_results <- dcast(election, election$CountyName + election$CountyFips +election$StateName ~ election$Candidate)

#tolower county names
el_results$`election$CountyName` = tolower(el_results$`election$CountyName`)

# paste state and counties together
el_results$state_county <- do.call(paste, c(el_results[c( "election$StateName","election$CountyName")], sep = ",")) 

#add space where hyphens are using stringr package
library(stringr)
# change to name col name for merge
el_results$name = str_replace_all(el_results$state_county,"-"," ")

# compare two dataframes
head(el_results)
head(demo_data)

#change trump and clinton votes to percents
# convert to numeric
el_results$Trump = as.numeric(el_results$Trump)
el_results$Clinton = as.numeric(el_results$Clinton)
el_results$Johnson = as.numeric(el_results$Johnson)
el_results$Stein = as.numeric(el_results$Stein)
el_results$Castle = as.numeric(el_results$Castle)

el_results$total_votes = rowSums( el_results[,4:8],na.rm=T )
el_results$perc_Trump = 100*el_results$Trump / el_results$total_votes
el_results$perc_Clinton = 100*el_results$Clinton / el_results$total_votes


head(el_results)
# merge on counties.
total <- merge(demo_data,el_results,by='name')
head(total)

saveRDS(total,file="data/counties.rds")
