# setwd
setwd("/Users/evanthompson/SDP/epa")


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



# drive scoring result
sea2018$drive_points <- ifelse(sea2018$Touchdown == 1, 7, ifelse(sea2018$FieldGoalResult == "Good", 3, 0))



# create drive identifier
sea2018$Drive <- sprintf("%02d", as.numeric(sea2018$Drive))
sea2018$drive_unique <- paste(sea2018$GameID, sea2018$HomeTeam, sea2018$Drive, sep = "_", collapse = NULL)


# keep desired PlayTypes
sea2018$DesiredPlayType <- ifelse(sea2018$PlayType == "Run" | sea2018$PlayType == "Pass" | sea2018$PlayType == "Field Goal" | sea2018$PlayType == "Sack",1,0)
sea2018 <- sea2018[ which(sea2018$DesiredPlayType == 1),]
save(sea2018, file = "sea2018.RData")


##Remove No Play


# reverse sort
sea2018_reverse <- sea2018
sea2018_reverse <- sea2018_reverse[order(sea2018_reverse$drive_unique, sea2018_reverse$drive_points, decreasing=TRUE),]


# keep unique drives
sea2018_unique <- sea2018_reverse[!duplicated(sea2018_reverse$drive_unique),]


# keep only drive identifier and drive points for dataset merge
myvars <- c("drive_unique", "drive_points")
sea2018_unique <- sea2018_unique[myvars]
sea2018_unique[is.na(sea2018_unique)] <- 0


# keep desired variables
myvars <- c("Date", "GameID", "Drive", "qtr", "down", "TimeSecs", "yrdline100", "ydstogo", "GoalToGo", "Yards.Gained", "FirstDown", "posteam", "DefensiveTeam", "HomeTeam", "AwayTeam", "desc", "Touchdown", "Safety", "PlayType", "RushAttempt", "FieldGoalResult", "PosTeamScore", "DefTeamScore", "ScoreDiff", "AbsScoreDiff", "EPA", "drive_unique", "DesiredPlayType")
sea2018 <- sea2018[myvars]


# merge onto primary dataset
sea2018 <- merge(sea2018,sea2018_unique,by="drive_unique")



# should we flag drive score change at end of drive before removing observations? Yes
# careful of defensive touchdowns


# remove temp dataset
rm(season2018)
rm(sea2018_unique)
rm(sea2018_reverse)



# create linear regression model 1 (no team effect)
linearMod1 <- lm(drive_points ~  factor(down) + ydstogo + yrdline100, data=sea2018)
print(linearMod1)
summary(linearMod1)



# create linear regression model 2 (w/ team effect)
linearMod2 <- lm(drive_points ~  factor(down) + ydstogo + yrdline100 + factor(posteam) + factor(DefensiveTeam), data=sea2018)
print(linearMod2)
summary(linearMod2)

