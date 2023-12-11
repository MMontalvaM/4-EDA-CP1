# 0.- Previous steps: set Working Directory (wd), download file, unzip
wd<-"C:/Users/mmont/OneDrive/Documents/R/Codigos/Ciencia Datos/04 - Exploratory Data Analysis/Course Project 1"
setwd(wd)
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL,destfile = "dataCP1.zip")
unzip("dataCP1.zip")

# 1.- Loading and subsetting the data
EPCdata.total<-read.csv2("household_power_consumption.txt",
                         header = TRUE,
                         colClasses = c("character","character","numeric",
                                        "numeric","numeric","numeric",
                                        "numeric","numeric","numeric"),
                         dec = ".",
                         na.strings = "?")
EPCdata.total$Date<-as.Date(EPCdata.total$Date,
                            format = "%d/%m/%Y")
EPCdata<-subset(EPCdata.total,
                subset = Date>="2007-02-01" & Date<="2007-02-02")
rm(EPCdata.total,
   fileURL,
   wd)

# 2.- Setting date and hour and removing NA values
library(dplyr)
EPCdata<-mutate(EPCdata,
                FullDate=as.POSIXct(paste(Date,Time, sep = " ")),
                .before=Date)
EPCdata$Date<-NULL
EPCdata$Time<-NULL
EPCdata<-EPCdata[complete.cases(EPCdata),]

# 3.- Plot and export
png(filename = "plot1.png")
hist(EPCdata$Global_active_power,
     freq = TRUE,
     col = "red",
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()
