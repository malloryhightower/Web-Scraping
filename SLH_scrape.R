#webscrape the top 4 student loan hero refinance rates
#these are refinance rates for the top refinance lenders from the SLH website

#Windows task manager task name is SLH_scrape

#the task is set to run at 10:30 AM every day

#the task manager is weird with R files, so in the file name 
#you need to add the location of the Rscript.exe file before the location of 
#the R code file separated by 
#a space and in quotes: "C:\Program Files\R\R-3.5.1\bin\Rscript.exe"

#load packages 
library(rvest)
library(purrr)
library(xml2)
library(xlsx)

#VARIABLE APR
#get the variable APR rates and convert to dataframe
html <-
  read_html('https://studentloanhero.com/6-best-banks-to-refinance-your-student-loans-lendingtree-003/?gclid=EAIaIQobChMI8bDT-syd4QIVymSGCh09sgWQEAAYASAAEgLDovD_BwE')
variable_apr_ranges <-html_nodes(html, '.qa-rates-sofi-refinancing-variable-all , .qa-rates-lendkey-refinancing-variable-all, .qa-rates-earnest-refinancing-variable-all, .qa-rates-laurelroad-refinancing-variable-all') %>% html_text()
variable_apr_ranges<-as.data.frame(variable_apr_ranges)
variable_apr_ranges <- variable_apr_ranges[-c(5, 6, 7,8), ]
variable_apr_ranges<-as.data.frame(variable_apr_ranges)
head(variable_apr_ranges)


#LENDER NAMES
#get the lender names and convert to dataframe
# have to grab these because the other names are stored as an image on the website
html <-
  read_html('https://studentloanhero.com/6-best-banks-to-refinance-your-student-loans-lendingtree-003/?gclid=EAIaIQobChMI8bDT-syd4QIVymSGCh09sgWQEAAYASAAEgLDovD_BwE')
lender_names <-html_nodes(html, '.slh-away-sm') %>% html_text()
lender_names<-as.data.frame(lender_names)
head(lender_names)
#create trim3 cunction to eliminate text
trim3<-function(x) {
  x<-gsub("Visit ", "", x)
  return(x)
}
# apply trim3 function to the lender names and reconvert to df
lender_names<-apply(lender_names, MARGIN = 1, FUN = trim3)
lender_names<-as.data.frame(lender_names)
head(lender_names)

#delete the repetitive rows
lender_names <- lender_names[-c(5, 6, 7,8), ]
lender_names<-as.data.frame(lender_names)

#LOAN TERMS
#get the loan terms and convert to dataframe
html <-
  read_html('https://studentloanhero.com/6-best-banks-to-refinance-your-student-loans-lendingtree-003/?gclid=EAIaIQobChMI8bDT-syd4QIVymSGCh09sgWQEAAYASAAEgLDovD_BwE')
loan_terms <-html_nodes(html, '.qa-field-terms') %>% html_text()
loan_terms<-as.data.frame(loan_terms)
loan_terms <- loan_terms[-c(5, 6, 7,8), ]
loan_terms<-as.data.frame(loan_terms)
head(loan_terms)

#LOAN TYPES
#get the loan types and convert to dataframe
html <-
  read_html('https://studentloanhero.com/6-best-banks-to-refinance-your-student-loans-lendingtree-003/?gclid=EAIaIQobChMI8bDT-syd4QIVymSGCh09sgWQEAAYASAAEgLDovD_BwE')
loan_types <-html_nodes(html, '.qa-field-refinancing_loan_types') %>% html_text()
loan_types <-as.data.frame(loan_types)
loan_types <- loan_types[-c(5, 6, 7,8), ]
loan_types<-as.data.frame(loan_types)
head(loan_types)

#COMBINE DATA
#combine the site names and traffic percentages
SLH_data<-cbind(lender_names,variable_apr_ranges,loan_types,loan_terms)

#GET TIMESTAMP
#get current time
SLH_data$time<-Sys.time()
#convert time to only time to make it easier for later excel analysis
SLH_data$time <- strftime(SLH_data$time, format="%H:%M:%S")
head(SLH_data)
#get date
SLH_data$date<-Sys.Date()
#get timezone
SLH_data$timezone<-Sys.timezone()

#examine the data to make sure is stored the right way
is.data.frame(SLH_data)
lapply(SLH_data, class)

#write the dataframe to csv doc, change the \ to / and load the appropriate package
#cannot write to xlsx file bc it will not append the data, so writing to table
write.table(SLH_data, file = "C:/Users/mhightower/Documents/WebScraping/SLH_data.csv", append=TRUE, sep=",", col.names=FALSE, row.names=FALSE)



