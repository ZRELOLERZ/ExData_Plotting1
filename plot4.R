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

#convert time to POSIX date time format
filteredData$POSIX_date_time <- strptime(paste(filteredData$Date, filteredData$Time), "%Y-%m-%d %X")

#convert columns 3 to 9 from character to numeric class
filteredData[, c(3:9)] = apply(filteredData[, c(3:9)], 2, function(x) as.numeric(x))

#
png(filename="plot4.png")

par(mfrow = c(2,2))

#top left graph
with(filteredData, plot(x = POSIX_date_time, y = Global_active_power, type = 'l', xlab = ''))

#top right graph
with(filteredData, plot(x = POSIX_date_time, y = Voltage, type = 'l', xlab = 'datetime'))

#bottom left graph

with(filteredData,
     plot(x = POSIX_date_time,
          y = Sub_metering_1,
          ylab = 'Energy sub metering',
          xlab = '',
          type = 'l'
     ),
)

with(filteredData, lines(x = POSIX_date_time, y = Sub_metering_2, col = 'red'))
with(filteredData, lines(x = POSIX_date_time, y = Sub_metering_3, col = 'blue'))

legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2','Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1)

#bottom right graph

with(filteredData, plot(x = POSIX_date_time, y = Global_reactive_power, type = 'l', xlab = 'datetime'))

dev.off()