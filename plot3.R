### We are going to assume that the file is in the working directory

library(dplyr)
library(lubridate)

### First, lets read enough lines to cover a couple of days. The file stores
### information every minute since 16/12/2006 and we want to calculate how
### many lines we want to skip and read

start <- read.table("household_power_consumption.txt", header = T, sep = ";",
                    nrows = 4000)
Colnames <- names(start)

### With this we are going to store how many lines are in the first date (which
### is incomplete) and the second date (complete)

first <- length(grep("16/12/2006", start[,1]))
second <- length(grep("17/12/2006", start[,1]))

### There are 46 days to skip plus the first one until 01/02/2007

skips <- first+46*second

### and we want to read the two whole following days

read <- 2*second

### The data set we are going to use is:

my_data <- read.table("household_power_consumption.txt", header = T, sep = ";",
                      nrows = read, skip = skips, col.names = Colnames)

### We create a new variable to store the date and time in one place as a whole

### As my computer shows dates in Spanish, I'm setting the language into English
### so that the labels in the tics of the x axis are show in English, as is shown
### in the original image.

Sys.setlocale("LC_ALL","English")
my_data$TIME <- 
        paste(my_data$Date, my_data$Time) %>%
        strptime("%d/%m/%Y %H:%M:%S")

rm(start, first, second)

### NOW WE START PRODUCING THE IMAGE 3

png("plot3.png")

with(my_data, plot(x = rep(TIME, times = 3), 
                   y = c(Sub_metering_1, Sub_metering_2, Sub_metering_3), 
                   xlab = "", ylab = "Energy sub metering", type = "n"))

with(my_data, lines(x = TIME, y = Sub_metering_1, col = "black"))
with(my_data, lines(x = TIME, y = Sub_metering_2, col = "red"))
with(my_data, lines(x = TIME, y = Sub_metering_3, col = "blue"))

legend('topright', col = c("black", "red", "blue"), lty = 1, seg.len = 1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

### We close the device

dev.off()