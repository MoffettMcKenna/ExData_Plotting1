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
                        "%d/%m/%Y %H:%M:%S")
                    )
                )

# start the file
png(filename = "plot2.png", width = 480, height = 480, bg = "transparent")

#make the plot
with(feb12,
     plot(TimeStamp,
          Global_active_power,
          type = "l",
          ylab = "Global Active Power (kilowatts)")
     )

#close the file
dev.off()