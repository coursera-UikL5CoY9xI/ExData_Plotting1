# plot2.R
# Display Line graph for Global Active Power

# Read in dataset, reduce to necessary working set.
# Note: we have pleanty of RAM, we can import the whole thing
# Prepare conversion functions
setClass('hpcDate')
setAs("character", "hpcDate", function(from) as.Date(from, format="%d/%m/%Y") )
setClass('hpcTime')
setAs("character", "hpcTime", function(from) { return (as.numeric(strptime(from, format="%H:%M:%S"))
                                               - as.numeric(trunc(Sys.time(), units=c("days"))))
                                               })
# Source data
data  <- read.table("data/household_power_consumption.txt", sep=";",
                    header=TRUE, stringsAsFactors = FALSE, na.strings="?",
                    colClasses = c("hpcDate", "hpcTime", "numeric",
                                   "numeric", "numeric", "numeric",
                                   "numeric", "numeric", "numeric"))
# Trim to what we will use
dateRange  <- c(as.Date("2007-02-01"), as.Date("2007-02-02"))
data  <- data[data$Date %in% dateRange,]
# Generate index by day incrementing times
data$Epoc <- ifelse(data$Date == dateRange[2], data$Time+86400, data$Time)

# Set output
png(file="plot4.png")

# Set up Framing, fill by column
par(mfcol=c(2,2), mar=c(4,5,5,1), oma=c(0,0,0,0))

# Generate Global Active Power chart
with(data, plot(Epoc, Global_active_power, type='l', ylab="Global Active Power",
                xaxt="n", xlab=""))
axis(1, at=c(0,86370,172700),labels=c("Thu", "Fri", "Sat"))

# Generate Energy sub metering chart
with(data, {
    plot(Epoc, Sub_metering_1, type='n', ylab="Energy sub metering", xaxt="n", xlab="")
    points(Epoc, Sub_metering_1, type='l', col="black")
    points(Epoc, Sub_metering_2, type='l', col="red")
    points(Epoc, Sub_metering_3, type='l', col="blue")
})
legend("topright", lwd=1, lty=1, bty='n', col=c("black", "blue", "red"),
       legend=c("Sub_metering_1",
                "Sub_metering_2",
                "Sub_metering_3"))
axis(1, at=c(0,86370,172700),labels=c("Thu", "Fri", "Sat"))

# Generate Voltage chart
with(data, plot(Epoc, Voltage, type='l', ylab="Voltage", xaxt="n", xlab="datetime"))
axis(1, at=c(0,86370,172700),labels=c("Thu", "Fri", "Sat"))

# Generate Global_reactive_power chart
with(data, plot(Epoc, Global_reactive_power, type='l', yaxt="n", xaxt="n", xlab="datetime"))
axis(1, at=c(0,86370,172700),labels=c("Thu", "Fri", "Sat"))
axis(2, at=c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6), labels=c("0.0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6"))

# close the PNG device
dev.off()
