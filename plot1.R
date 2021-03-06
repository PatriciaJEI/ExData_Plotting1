### We are going to assume that the file is in the working directory

library(dplyr)

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

rm(start, first, second)

### NOW WE START PRODUCING THE IMAGE 1

hist(x = my_data$Global_active_power, xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency", main = "Global Active Power", col = "red")

### We store the image

dev.copy(png, "plot1.png")

### We close the device

dev.off()