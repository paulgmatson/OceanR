# OceanR_practice.R
# The script is for practicing coding in R in the OceanR working group
# First written by Paul Matson on 3 Feb 2017

rm(list=ls())
options(stringsAsFactors=F)

library(data.table) # will need for the rbindlist function

# check working directory
getwd()

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
