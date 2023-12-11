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
#library(dplyr)
EPCdata<-mutate(EPCdata,
                FullDate=as.POSIXct(paste(Date,Time, sep = " ")),
                .before=Date)
EPCdata$Date<-NULL
EPCdata$Time<-NULL
EPCdata<-EPCdata[complete.cases(EPCdata),]

# 3.- Plot and export
png(filename = "plot4.png")
par(mfrow=c(2,2))
#Top-left
plot(EPCdata$FullDate,
     EPCdata$Global_active_power,
     type = "l",
     xlab = NA,
     ylab = "Global Active Power")
#Top-right
plot(EPCdata$FullDate,
     EPCdata$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage")
#Bottom-left
plot(EPCdata$FullDate,
     EPCdata$Sub_metering_1, 
     type = "l",
     xlab = NA,
     ylab = "Energy sub metering")
points(EPCdata$FullDate,
       EPCdata$Sub_metering_2,
       type = "l",
       col="red")
points(EPCdata$FullDate,
       EPCdata$Sub_metering_3,
       type = "l",
       col="blue")
legend("topright",
       bty = "n",
       col=c("black","red","blue"),
       lwd=c(1,1,1),
       legend=names(EPCdata[,6:8]))
#Bottom-right
plot(EPCdata$FullDate,
     EPCdata$Global_reactive_power,
     type = "l",
     ylab = "Global_reactive_power",
     xlab = "datetime")
dev.off()
