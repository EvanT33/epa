# setwd
setwd("C:/Users/v-evtho/Documents/Personal/NFL")


# load packages
library(nflscrapR)
library(tidyverse)
library(devtools)
library(lubridate)
library(stringr)


# load 2018 play-by-play data
season2018 <- season_play_by_play(Season = 2018)
write.csv(season2018, "season2018.csv", row.names = FALSE)
season2018 <- read.csv("season2018.csv")
save(season2018, file = "season2018.RData")

# load 2018
load("season2018.RData")

# keep Seahawks data only
season2018$hawks <- ifelse(season2018$HomeTeam == "SEA" | season2018$AwayTeam == "SEA",1,0)
summary(season2018$hawks)
sea2018 <- season2018[ which(season2018$hawks == 1),]
save(sea2018, file = "sea2018.RData")



# keep Seahawks data only
season2018$hawks <- ifelse(season2018$PlayType == "Field Goal",1,0)
summary(season2018$hawks)
sea2018 <- season2018[ which(season2018$hawks == 1),]
save(sea2018, file = "sea2018.RData")


