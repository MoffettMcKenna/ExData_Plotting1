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

# start the file
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")

#make the graph into the file
hist(feb12$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = 2
)

#closed the file
dev.off()