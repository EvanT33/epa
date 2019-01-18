# setwd
setwd("C:/Users/v-evtho/Documents/Personal/NFL")

# load packages
library(nflscrapR)

# load 2018 play-by-play data
season2018 <- season_play_by_play(Season = 2018)
write.csv(season2018, "season2018.csv", row.names = FALSE)
season2018 <- read.csv("season2018.csv")
save(season2018, file = "season2018.RData")

# can start from here
# load 2018
load("season2018.RData")

# keep Seahawks data only
season2018$hawks <- ifelse(season2018$HomeTeam == "SEA" | season2018$AwayTeam == "SEA",1,0)
summary(season2018$hawks)
sea2018 <- season2018[ which(season2018$hawks == 1),]
save(sea2018, file = "sea2018.RData")

# keep desired variables
myvars <- c("Date", "GameID", "Drive", "qtr", "down", "TimeSecs", "yrdline100", "ydstogo", "GoalToGo", "Yards.Gained", "FirstDown", "posteam", "HomeTeam", "AwayTeam", "desc", "Touchdown", "Safety", "PlayType", "RushAttempt", "FieldGoalResult", "PosTeamScore", "DefTeamScore", "ScoreDiff", "AbsScoreDiff", "EPA")
sea2018 <- sea2018[myvars]

# keep desired PlayTypes
sea2018$DesiredPlayType <- ifelse(sea2018$PlayType == "Run" | sea2018$PlayType == "Pass" | sea2018$PlayType == "Field Goal" | sea2018$PlayType == "Sack",1,0)
sea2018 <- sea2018[ which(sea2018$DesiredPlayType == 1),]
summary(season2018$PlayType)
save(sea2018, file = "sea2018.RData")
