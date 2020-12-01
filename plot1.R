fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

fileDir = "household_power_consumption.txt"

if (!file.exists(fileDir)) {
    download.file(fileURL, destfile = "power_data.zip", method = "curl")
    unzip("power_data.zip")
}


rawData <- read.table(fileDir, sep = ";", header = TRUE)

#filter data by rows with dates from 2007-02-01 OR 2007-02-02
filteredData <- rawData[which(rawData$Date == '1/2/2007' | rawData$Date == '2/2/2007'),]

#convert "Date" column to Date class
filteredData$Date <- as.Date(filteredData$Date, "%d/%m/%Y")

#convert columns 3 to 9 from character to numeric class
filteredData[, c(3:9)] = apply(filteredData[, c(3:9)], 2, function(x) as.numeric(x))

#
png(filename="plot1.png")

hist(filteredData$Global_active_power,
     col = 'red',
     main = 'Global Active Power',
     xlab = 'Global Active Power (Kilowatts)',
     )

dev.off()