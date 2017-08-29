#This pragram will work if plot1.R is placed in current working directory

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
mainDir <- getwd()
dir <- "Coursera"
#Check if "Coursera" directory exists or not.
#This will be our working dorectory
#If exists, make it working directory, else create it and then set it
if(file.exists(dir)){
  setwd(file.path(mainDir, dir))
} else{
  dir.create(file.path(mainDir, dir))
  setwd(file.path(mainDir, dir))
}

# "downloader" package needs to be installed
# Checking for already installed package, else will automatically download and install

if("downloader" %in% rownames(installed.packages()) == FALSE){
  install.packages("downloader")  #installing the package
  library(downloader)
} else{
  library(downloader)
}

#check if the source zip file is present
if(file.exists("CourseProj_dataFile.zip") == FALSE){
  #downloading the source file using downloader package
  download(url, dest = "CourseProj_dataFile.zip", mode = "wb")
}

#check if the source files are present
if(!file.exists("summarySCC_PM25.rds") && !file.exists("Source_Classification_Code.rds")){
  unzip("CourseProj_dataFile.zip") #unzip the downloaded file 
}

# Reading the 2 files inside the .zip file
if(!exists("NEI")){
  NEI <- readRDS("summarySCC_PM25.rds") 
}
if(!exists("SCC")){
  SCC <- readRDS("Source_Classification_Code.rds") 
}

# Selecting only required columns
sunsetDF <- subset(NEI, fips == "24510")[,c("Emissions","year")]

DF2agg <- aggregate(Emissions ~ year, sunsetDF, FUN = sum)

png(file="plot2.png")
barplot(height = DF2agg$Emissions, names.arg = DF2agg$year, xlab="Years", ylab=expression('Total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' Emissions in Baltimore City'))
dev.off()

#Now setting the working directory to original
setwd(mainDir)
