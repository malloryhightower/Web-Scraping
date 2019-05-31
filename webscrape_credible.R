#webscrape the interest rate ranges
#these are refinance rates for lenders listed on credible

#Windows task manager task is set to run at 10:30 AM everyday

#the task is named AA

#the task manager is weird with R files, so in the file name 
#you need to add the location of the Rscript.exe file before the location of 
#the R code file separated by 
#a space and in quotes: "C:\Program Files\R\R-3.5.1\bin\Rscript.exe"

#load packages 
library(rvest)
library(purrr)
library(xml2)
library(xlsx)
library(miniUI)
library(shiny)
library(XLConnect)

#FIXED RATES
#get the fixed teaser rates and convert to dataframe
html <-
  read_html('https://www.credible.com/refinance-student-loans/1')
fixed_ranges <-html_nodes(html, '.with-margin:nth-child(1) span') %>% html_text()
fixed_ranges<-as.data.frame(fixed_ranges)
head(fixed_ranges)

#create trim1 cunction to eliminate text, # after percentage, and whitespace
trim1<-function(x) {
x<-gsub("Fixed: ", "", x)
x<-sub('%.*', '', x)
x<-gsub("^\\s+|\\s+$", "", x)
return(x)
}

#apply trim1 function over the dataframe and convert back to dataframe
fixed_ranges<-apply(fixed_ranges, MARGIN = 1, FUN = trim1)
fixed_ranges<-as.data.frame(fixed_ranges)
head(fixed_ranges)



#VARIABLE RATES
#get the variable teaser rates and convert to dataframe
html <-
  read_html('https://www.credible.com/refinance-student-loans/1')
variable_ranges <-html_nodes(html, '.with-margin:nth-child(2) span') %>% html_text()
variable_ranges<-as.data.frame(variable_ranges)
#tkae care of where the selector gadget couldn't grab the 
#rows well that didn't have variable rates
variable_ranges[10,]<-""
variable_ranges<-variable_ranges[ -c(11), ]
variable_ranges<-as.data.frame(variable_ranges)
head(variable_ranges)

#create trim2 cunction to eliminate text, # after percentage, and whitespace
trim2<-function(x) {
  x<-gsub("Variable: ", "", x)
  x<-sub('%.*', '', x)
  x<-gsub("^\\s+|\\s+$", "", x)
  return(x)
}

#apply trim2 function over the dataframe and convert back to dataframe
variable_ranges<-apply(variable_ranges, MARGIN = 1, FUN = trim2)
variable_ranges<-as.data.frame(variable_ranges)
head(variable_ranges)

#LENDER NAMES
#get the lender names and convert to dataframe
#make sure names are stored as character when converting to dataframe
html <-
  read_html('https://www.credible.com/refinance-student-loans/1')
lenders <-html_nodes(html, '.lender-name') %>% html_text()
lenders<-as.data.frame(lenders, stringsAsFactors=FALSE)
head(lenders)

#combine the lender named, fixed rates, and variable rates
data<-cbind(lenders, fixed_ranges, variable_ranges)

#get current time
data$time<-Sys.time()
#convert time to only time to make it easier for later excel analysis
data$time <- strftime(data$time, format="%H:%M:%S")
head(data)
#get date
data$date<-Sys.Date()
#get timezone
data$timezone<-Sys.timezone()

#examine the data to make sure is stored the right way
is.data.frame(data)
lapply(data, class)

#create function for converting factors to numeric and character
as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}

#convert the factor values to correct values for export
data[,2:3]<-lapply(data[,2:3], as.numeric.factor)
lapply(data, class)

#write the dataframe to csv doc, change the \ to / and load the appropriate package
#cannot write to xlsx file bc it will not append the data, so writing to table
write.table(data, file = "C:/Users/mhightower/Documents/WebScraping/credible_data_2.csv", append=TRUE, sep=",", col.names=TRUE, row.names = FALSE)






