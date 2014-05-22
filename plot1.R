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

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
full_dataset <- merge(NEI, SCC, by="SCC")