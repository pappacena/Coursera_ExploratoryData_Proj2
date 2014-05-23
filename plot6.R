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

to_plot <- subset(full_dataset, fips %in% c("24510", "06037"))
to_plot <- to_plot[grep("Vehicles", to_plot$EI.Sector), ]
to_plot <- to_plot[c("year", "fips", "Emissions")]

agg <- aggregate(to_plot$Emissions, list(Year=to_plot$year, fips=to_plot$fips), sum)
names(agg) <- c("Year", "fips", "Sum.Emissions")

agg$city <- ifelse(agg$fips == "24510", "Baltimore", "Los Angeles")

with(agg, {
    png(file = "plot6.png", bg = "transparent", width=800)
    library(ggplot2)
    g <- ggplot(agg, aes(x=Year, y=Sum.Emissions)) + 
        scale_y_log10() +
        geom_point(stat="identity") +
        facet_wrap(~city, nrow=1, ncol=2) +
        geom_smooth(method=lm) +
        labs(title = "Emissions change - Baltimore vs Los Angeles\n(Legends on log10 scale)")
    print(g)
    dev.off()
})