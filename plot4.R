library(dplyr)

#find the lines we care about
linenos <- grep(
    "^[12]/2/2007",
    readLines("household_power_consumption\\household_power_consumption.txt")
)

#calculate the mnumber of lines to skip
skips <- linenos[1] - 1

#read in only the lines we care about - since we skip the header row, don't get headers here
feb12 <- read.delim(
    "household_power_consumption\\household_power_consumption.txt",
    sep = ";",
    na.strings = c("?"),
    skip = skips,
    nrows = length(linenos),
    header = FALSE
)
#now get the headers from the top of the file
headers <- read.delim(
    "household_power_consumption\\household_power_consumption.txt",
    sep = ";",
    nrows = 1
)

#re-assign the headers
names(feb12) <- names(headers)

#make a TimeStamp column for the x-axis
# This combines the Date and Time columns with paste, then uses strptime to get
# a datetime object.  But the result is POSIXlt, which mutate can't process.  So
# we use as.POSIXct to get an object mutate can work with.
feb12 <- mutate(feb12,
                TimeStamp = as.POSIXct(
                    strptime(
                        paste(feb12$Date, feb12$Time, sep = " "),
                        "%d/%m/%Y %H:%M:%S"
                    )
                )
)

# start the file
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")

#divide it up
par(mfrow = c(2,2))

#do graph #1 - this is the same as plot2
with(feb12,
     plot(TimeStamp,
          Global_active_power,
          type = "l",
          ylab = "Global Active Power (kilowatts)")
)

#do graph #2 - new one
with(feb12,
     plot(TimeStamp,
          Voltage,
          type = "l",
          ylab = "Voltage")
)

#do graph #3 - same as plot 3
with(feb12, plot(TimeStamp, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab=""))
with(feb12, lines(TimeStamp, Sub_metering_2, col = 2))
with(feb12, lines(TimeStamp, Sub_metering_3, col = 4))
legend("topright", legend = c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"), lty =1, col = c(1,2,4))

#do graph #4 - new one
with(feb12,
     plot(TimeStamp,
          Global_reactive_power,
          type = "l",
          ylab = "Global_reactive_power")
)

# close the file
dev.off()