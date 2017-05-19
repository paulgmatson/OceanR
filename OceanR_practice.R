# OceanR_practice.R
# The script is for practicing coding in R in the OceanR working group
# First written by Paul Matson on 3 Feb 2017

rm(list=ls())
options(stringsAsFactors=F)

library(data.table) # will need for the rbindlist function

# check working directory
getwd()
setwd("~/Dropbox/OceanR/") # you will need to change this

# load BATS_bottle data
raw <- read.table("BATS_bottle.txt", skip=59, header=FALSE)
# check the structure of raw
str(raw) 

# create a vector containing the names that we need in our header
header <- c("Id","yyyymmdd","decy","time","latN","lonW","Depth","Temp", 
            "CTD_S","Sal1","Sig_th","O2_1","OxFix","Anom1","CO2","Alk",
            "NO3","NO2","PO4","Si","POC","PON","TOC","TN","Bac","POP",
            "TDP","SRP","BSi","LSi","Pro","Syn","Piceu","Naneu")
# put header names into column names
colnames(raw) <- header 
# check structure
str(raw)

# store raw dataframe under new name ('data')
data <- raw
# convert all values of '-999' to 'NA' in the dataframe 'data'
data[data == -999] <- NA
# check the dataframe structure
str(data)

# check for any other weird values in dataframe
summary(data)

# create new column for dataframe 'data'
data$cruise.type <- substr(data$Id, 1, 1)  
# check structure
str(data)
# create column for 'cruise'
data$cruise <- substr(data$Id, 2,5)
# create vector for 'cast'
data$cast <- substr(data$Id, 6,8)
# create vector for 'bottle'
data$bottle <- substr(data$Id, 9,10)
# check structure
str(data)

# create column in 'data' for 'lonE'
data$lonE <- 360 - data$lonW  # convert lonW to lonE
str(data)

# save 'data' as a .csv file
write.csv(data, file= "OceanR_BATS_data.csv", row.names=F)

# open data file
data <- read.table("OceanR_BATS_data.csv", header=TRUE, sep=",")

# look at first 5 rows of 'data'
head(data, 5)

# look at last 7 rows of 'data'
tail(data, 7)

# check which cruises are present in 'data'
unique(data$cruise)

# check the range in cruises in 'data'
range(data$cruise, na.rm=T)

# check the range in depths in 'data'
range(data$Depth, na.rm=T)

# select data from BATS cruise 300
x <- data[data$cruise == "300",]
str(x)
unique(x$cruise)

# select data from BATS cruises 300 and 302
x <- data[data$cruise %in% c("300", "302"),]
str(x)
unique(x$cruise)

# select data from cruises 289, 290, and 300 from depths between 100 and 1000m
x <- data[data$cruise %in% c("289", "290", "300") & data$Depth >= 100 & data$Depth <= 1000,]
str(x)
unique(x$cruise)
range(x$Depth, na.rm=T) 
######### 
## Stopped here on 9 Feb 2017
########


## Creating Lists
# split 'data' based on cruise
cruise.list <- split(data, data$cruise)

# store data for cruise 300 from 'cruise.list'
cruise.300 <- cruise.list[["300"]] # note the double brackets...¡muy importante!
str(cruise.300)

# The number of brackets are important!
x <- cruise.list["300"] # notice the single brackets here
str(x)

# calculate maximum temperature for each cruise and store as max.temp.list
# Note: the argument "na.rm" is useful for removing potential NA values from the calculation. Use it anytime there is or may be an NA in your vector of interest.
max.temp.list <- lapply(cruise.list, function(x){max(x$Temp, na.rm=T)}) 

#look at max temperature for cruise 300
max.temp.list[["300"]]

# calculate max temperature for cruise 300 using an index
max(data[data$cruise=="300","Temp"], na.rm=T)

# Save your dataframe as an R datafile (.Rda)
save(data, file="BATSdata.Rda")

# Load a dataframe file (.Rda)
load("BATSdata.Rda")

##################
## Stopped here on 18 May 2017

# create vector of cruise numbers that we want to look at
cruises <- c(seq(1:max(data$cruise)))
# create vector to put the resulting data
result <- data.frame(cruise = rep(NA,length(cruises)), maxT = rep(NA,length(cruises)))

for(i in cruises){
  result[i, "cruise"] <- unique(data[data$cruise==i, "cruise"])
  result[i, "maxT"] <- max(data[data$cruise==i,"Temp"], na.rm=T)
}
head(result)

# check max temp for cruise 300
result[300]

## Writing your own function
c2f <- function(x){
  degF <- (x * (9/5)) +32
  result <- paste(x," degrees C is equal to ",degF," degrees F", sep="")
  return(result)
}

# now use the function to check temp of 12C
c2f(12)

# prompt "Do you want to fish"
fishing <- function(){
  x <- readline("Do you want to fish, y or n?")  
  out1 <- sample(0:3,1)
  out2 <- sample(0:3,1)
  out3 <- ifelse(out1 == out2, "You caught a fish!", "No fish for you :-(")
  ifelse(x %in% c("y","Y"), out3, "Maybe next time")
}  

fishing()

# subset dataframe to only look at cruise 250
cruise.250 <- data[data$cruise==250,]

# split df into separate casts
cast.list<- split(cruise.250, cruise.250$cast)

# identify casts containing TOC or TN collected from the same bottle
findDOM.func <- function(x){
  DOM <- x[!(is.na(x$TOC) | is.na(x$TN)),]
  return(DOM)
}
# run the list through the function
DOM.list <- lapply(cast.list, findDOM.func)

# alternatively, we can wirte the function within the lapply command
DOM.list2 <- lapply(cast.list, function(x){
  DOM <- x[!(is.na(x$TOC) | is.na(x$TN)),]
  return(DOM)
})

str(DOM.list)

# Download and install package 'data.table' before trying to load it
library(data.table) # makes the package available

#bind list elements into a dataframe called DOM.df
DOM.df <- data.frame(rbindlist(DOM.list))
str(DOM.df) # check structure