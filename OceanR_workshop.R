# OceanR_practice.R
# The script is for practicing coding in R in the OceanR working group
# First written by Paul Matson on 3 Feb 2017

rm(list=ls())
options(stringsAsFactors=F)

library(data.table) # will need for the rbindlist function

# check working directory
getwd()
setwd("~/Dropbox/OceanR/") #### you will need to change this for your computer

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