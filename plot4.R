if(!"data" %in% dir()) {
    stop("data directory not found. Did you set your working directory?")
}

if(!file.exists("./data/NEI_data.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  "data/NEI_data.zip")
}

if(!file.exists("./data/summarySCC_PM25.rds") ||
       !file.exists("./data/Source_Classification_Code.rds")) {
    unzip("./data/NEI_data.zip", exdir="data")
}


# Loads only if not in environment
if(!exists("NEI")) {
    NEI <- readRDS("data/summarySCC_PM25.rds")
}
if(!exists("SCC")) {
    SCC <- readRDS("data/Source_Classification_Code.rds")
}

if(!exists("full_dataset")) {
    full_dataset <- merge(NEI, SCC, by="SCC")
}

to_plot <- full_dataset[grep("Fuel Comb - .* - Coal", full_dataset$EI.Sector), ]
to_plot <- to_plot[c("year", "Emissions")]
agg <- aggregate(to_plot$Emissions, list(Year=to_plot$year), sum)
names(agg) <- c("Year", "Sum.Emissions")

with(agg, {
    png(file = "plot4.png", bg = "transparent")
    library(ggplot2)
    g <- ggplot(agg, aes(x=Year, y=Sum.Emissions)) + 
        geom_line(stat="identity")
    print(g)
    dev.off()
})