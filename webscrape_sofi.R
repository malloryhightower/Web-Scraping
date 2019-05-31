#webscrape the interest rate ranges
#these are refinance rates for sofi from their website

#Windows task manager task is set to run at 10:30 AM everyday

#the task is named sofi_scrape

#the task manager is weird with R files, so in the file name 
#you need to add the location of the Rscript.exe file before the location of 
#the R code file separated by 
#a space and in quotes: "C:\Program Files\R\R-3.5.1\bin\Rscript.exe"

#load packages 
library(rvest)
library(purrr)
library(xml2)
library(xlsx)

#FIXED RATES
#get the fixed teaser rates and convert to dataframe
html <-
  read_html('https://www.sofi.com/refinance-student-loan/refinance-student-loan-rates/')
fixed_ranges <-html_nodes(html, '.u-scroll:nth-child(2) td:nth-child(2)') %>% html_text()
fixed_ranges<-as.data.frame(fixed_ranges)
head(fixed_ranges)

#VARIABLE RATES
#get the variable teaser rates and convert to dataframe
html <-
  read_html('https://www.sofi.com/refinance-student-loan/refinance-student-loan-rates/')
variable_ranges <-html_nodes(html, ':nth-child(5) .table--product-rates td:nth-child(2)') %>% html_text()
variable_ranges<-as.data.frame(variable_ranges)
head(variable_ranges)

#LOAN TERMS
#get the loan terms and convert to dataframe
#fixed and variable should be the same
#make sure names are stored as character when converting to dataframe
html <-
  read_html('https://www.sofi.com/refinance-student-loan/refinance-student-loan-rates/')
loan_terms <-html_nodes(html, '.u-scroll:nth-child(2) tr:nth-child(6) th , .u-scroll:nth-child(2) tr:nth-child(5) th, .u-scroll:nth-child(2) tr:nth-child(4) th, .u-scroll:nth-child(2) tr:nth-child(3) th, .u-scroll:nth-child(2) tr:nth-child(2) th') %>% html_text()
loan_terms<-as.data.frame(loan_terms, stringsAsFactors=FALSE)
head(loan_terms)

#COMBINE DATA
#combine the loan terms, fixed rates, and variable rates
sofi_data<-cbind(loan_terms, fixed_ranges, variable_ranges)

#GET TIMESTAMP
#get current time
sofi_data$time<-Sys.time()
#convert time to only time to make it easier for later excel analysis
sofi_data$time <- strftime(sofi_data$time, format="%H:%M:%S")
head(sofi_data)
#get date
sofi_data$date<-Sys.Date()
#get timezone
sofi_data$timezone<-Sys.timezone()

#examine the data to make sure is stored the right way
is.data.frame(sofi_data)
lapply(sofi_data, class)

#write the dataframe to csv doc, change the \ to / and load the appropriate package
#cannot write to xlsx file bc it will not append the data, so writing to table
write.table(sofi_data, file = "C:/Users/mhightower/Documents/WebScraping/sofi_data.csv", append=TRUE, sep=",", col.names=FALSE, row.names=FALSE)



