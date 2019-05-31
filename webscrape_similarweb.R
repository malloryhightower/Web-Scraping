#webscrape the destination traffic percentages
#these are the top 5 destination traffic percentages 
#for StudentLoanHero from Similar Web

#Windows task manager task is set to run at 10:30 AM everyday

#the task is named similarweb_scrape

#the task manager is weird with R files, so in the file name 
#you need to add the location of the Rscript.exe file before the location of 
#the R code file separated by 
#a space and in quotes: "C:\Program Files\R\R-3.5.1\bin\Rscript.exe"

#load packages 
library(rvest)
library(purrr)
library(xml2)
library(xlsx)

#DESTINATION SITES-TOP 5
#get the top 5 destination site names and convert to dataframe
html <-
  read_html('https://www.similarweb.com/website/studentloanhero.com#referrals')
site_names <-html_nodes(html, '.destination .js-tooltipTarget') %>% html_text()
site_names <-as.data.frame(site_names)
head(site_names)

#TRAFFIC PERCENTAGE
#get the top 5 destination sites traffic percentages and convert to dataframe
html <-
  read_html('https://www.similarweb.com/website/studentloanhero.com#referrals')
traffic <-html_nodes(html, '.destination .websitePage-trafficShare') %>% html_text()
traffic <-as.data.frame(traffic)
head(traffic)

#COMBINE DATA
#combine the site names and traffic percentages
similarweb_data<-cbind(site_names,traffic)

#GET TIMESTAMP
#get current time
similarweb_data$time<-Sys.time()
#convert time to only time to make it easier for later excel analysis
similarweb_data$time <- strftime(similarweb_data$time, format="%H:%M:%S")
head(similarweb_data)
#get date
similarweb_data$date<-Sys.Date()
#get timezone
similarweb_data$timezone<-Sys.timezone()

#examine the data to make sure is stored the right way
is.data.frame(similarweb_data)
lapply(similarweb_data, class)

#write the dataframe to csv doc, change the \ to / and load the appropriate package
#cannot write to xlsx file bc it will not append the data, so writing to table
write.table(similarweb_data, file = "C:/Users/mhightower/Documents/WebScraping/similarweb_data.csv", append=TRUE, sep=",", col.names=FALSE, row.names=FALSE)



