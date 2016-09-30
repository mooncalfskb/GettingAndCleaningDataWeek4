setwd("/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek4")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, "/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek4/ACS.csv",method="curl")
list.files
acs <- read.csv("/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek4/ACS.csv")

dude <- strsplit(names(acs),"wgtp")
dude[123]




fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, "/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek4/GDP.csv",method="curl")
list.files
gdp <- read.csv("/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek4/GDP2.csv")
str(gdp)
cleaned_gdp <- gsub(",", "", gdp$GDP)
cleaned_gdp <- gsub(" ", "", cleaned_gdp)
no_blanks <- cleaned_gdp[cleaned_gdp != ""]
head(no_blanks)
mean(as.numeric(no_blanks))


library(plyr)
library(dplyr)


#cleaned up gdp myself
gdp <- read.csv("/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek3/gdp.csv")
head(gdp)

fs <- read.csv("/Users/mooncalf/Dropbox/skb/coursera/GettingAndCleaningWeek3/FedStatsCountry.csv")
head(fs)

gdp_df <- tbl_df(gdp)
fs_df <- tbl_df(fs)
fs_df <- rename(fs_df, Country=CountryCode)

#mergedData = merge(reviews, solutions, by.x=“solution_id”, by.y=“id”, all=TRUE)
mergedData = merge(gdp, fs, by.x="Country", by.y="CountryCode", all=TRUE)
#189 with 45 NA
count(mergedData$Dollars)
mergedData <- arrange(mergedData, desc(Ranking))

md <- tbl_df(mergedData)
m <- regexpr("June", md$Special.Notes, perl=TRUE)
class(m)
length(m)
n <- data_frame(m,index=1:length(m))
june <- filter(n, m!=-1)
june_only <- june$index
june_only
june_notes <- md$Special.Notes[june_only]
june_notes


library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
library(lubridate)
#MO_L2 <- subset(MO, format(MO$Time, "%H:%M:$S") > "10:55:00" &
#                  format(MO$Time, "%H:%M:$S") < "11:30:00")

year12 <- subset(sampleTimes, format(sampleTimes, "%Y-%m-%d") > "2011-12-31" & format(sampleTimes, "%Y-%m-%d") < "2013-01-01")
weekdays <- wday(year12, label=TRUE)
mondays <- weekdays[weekdays == "Mon"]
