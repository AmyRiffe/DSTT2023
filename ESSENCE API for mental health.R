#GETTING STARTED----
##Load libraries 
library(lubridate)
library(tidyverse)
library(knitr)
library(httr)
library(jsonlite)
library(keyring)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)


##Set your wd filepath - where do you want the created doc to go?
#setwd("C:/Users/ariffe/Spokane Regional Health District/Data Center Team - Documents/Mental Health 2020/Essence data/R")

##Enter your desired dates:
#start date of 2020 timeseries
s_start_date <- "01Mar2021"
#end date (Saturday of the ending week)  
s_end_date <- "28Feb2023"




#DISASTER MENTAL HEALTH ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=5Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                                  key_get("essence", 
                                                          key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmh_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmh <- read_csv(api_response_dmh_csv)

#clean up the data file
dmh<-dmh%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(dmh$timeResolution, -2, -1)))   #adds these columns



# * DISASTER MENTAL HEALTH ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhAge <- read_csv(api_response_dmhAge_csv)

#clean up the data file
dmhAge<-dmhAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhAge$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhSex <- read_csv(api_response_dmhSex_csv)

#clean up the data file
dmhSex<-dmhSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhSex$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhRace <- read_csv(api_response_dmhRace_csv)

#clean up the data file
dmhRace<-dmhRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhRace$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhEthnicity <- read_csv(api_response_dmhEthnicity_csv)

#clean up the data file
dmhEthnicity<-dmhEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhEthnicity$timeResolution, -2, -1))   #adds these columns





#DISASTER MENTAL HEALTH IP##########################################################################################

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenI=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhip_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhip <- read_csv(api_response_dmhip_csv)

#clean up the data file
dmhip<-dmhip%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health IP", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(dmhip$timeResolution, -2, -1)))   #adds these columns


# * DISASTER MENTAL HEALTH IP BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhipAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhipAge <- read_csv(api_response_dmhipAge_csv)

#clean up the data file
dmhipAge<-dmhipAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health IP", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhipAge$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH IP BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhipSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhipSex <- read_csv(api_response_dmhipSex_csv)

#clean up the data file
dmhipSex<-dmhipSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health IP", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhipSex$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH IP BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhipRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhipRace <- read_csv(api_response_dmhipRace_csv)

#clean up the data file
dmhipRace<-dmhipRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health IP", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhipRace$timeResolution, -2, -1))   #adds these columns


# * DISASTER MENTAL HEALTH IP BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_dmhipEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
dmhipEthnicity <- read_csv(api_response_dmhipEthnicity_csv)

#clean up the data file
dmhipEthnicity<-dmhipEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Mental Health IP", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(dmhipEthnicity$timeResolution, -2, -1))   #adds these columns


#PSYCHOLOGICAL DISTRESS ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&ccHistory=%5Epanic%5E,OR,(,%5Estress%5E,ANDNOT,(,%5Erespiratory%5E,OR,%5Eincontinence%5E,),),OR,%5Eanxiety%5E,OR,%5Eanxious%5E,OR,%5EF41%5E,OR,%5EF43%5E,OR,%5EF45%5E,OR,%5EF48%5E,OR,%5EF93%5E&percentParam=ccHistory&datasource=va_er&startDate=30Dec2018&ccHistoryApplyTo=dischargeDiagnosis&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_psych_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
psych <- read_csv(api_response_psych_csv)

#clean up the data file
psych<-psych%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Psychological Distress ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(psych$timeResolution, -2, -1)))   #adds these columns



# * PSYCHOLOGICAL DISTRESS ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&ccHistory=%5Epanic%5E,OR,(,%5Estress%5E,ANDNOT,(,%5Erespiratory%5E,OR,%5Eincontinence%5E,),),OR,%5Eanxiety%5E,OR,%5Eanxious%5E,OR,%5EF41%5E,OR,%5EF43%5E,OR,%5EF45%5E,OR,%5EF48%5E,OR,%5EF93%5E&percentParam=ccHistory&datasource=va_er&startDate=1Jan2019&ccHistoryApplyTo=dischargeDiagnosis&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_psychAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
psychAge <- read_csv(api_response_psychAge_csv)

#clean up the data file
psychAge<-psychAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Psychological Distress ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(psychAge$timeResolution, -2, -1))   #adds these columns


# * PSYCHOLOGICAL DISTRESS ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&ccHistory=%5Epanic%5E,OR,(,%5Estress%5E,ANDNOT,(,%5Erespiratory%5E,OR,%5Eincontinence%5E,),),OR,%5Eanxiety%5E,OR,%5Eanxious%5E,OR,%5EF41%5E,OR,%5EF43%5E,OR,%5EF45%5E,OR,%5EF48%5E,OR,%5EF93%5E&percentParam=ccHistory&datasource=va_er&startDate=1Jan2019&ccHistoryApplyTo=dischargeDiagnosis&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_psychSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
psychSex <- read_csv(api_response_psychSex_csv)

#clean up the data file
psychSex<-psychSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Psychological Distress ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(psychSex$timeResolution, -2, -1))   #adds these columns


# * PSYCHOLOGICAL DISTRESS ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=sdc%20disaster%20related%20mental%20health%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"

##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_psychRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
psychRace <- read_csv(api_response_psychRace_csv)

#clean up the data file
psychRace<-psychRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Psychological Distress ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(psychRace$timeResolution, -2, -1))   #adds these columns


# * PSYCHOLOGICAL DISTRESS ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&ccHistory=%5Epanic%5E,OR,(,%5Estress%5E,ANDNOT,(,%5Erespiratory%5E,OR,%5Eincontinence%5E,),),OR,%5Eanxiety%5E,OR,%5Eanxious%5E,OR,%5EF41%5E,OR,%5EF43%5E,OR,%5EF45%5E,OR,%5EF48%5E,OR,%5EF93%5E&percentParam=ccHistory&datasource=va_er&startDate=1Jan2019&ccHistoryApplyTo=dischargeDiagnosis&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_psychEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
psychEthnicity <- read_csv(api_response_psychEthnicity_csv)

#clean up the data file
psychEthnicity<-psychEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Psychological Distress ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(psychEthnicity$timeResolution, -2, -1))   #adds these columns






#ALCOHOL ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20alcohol%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_etoh_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
etoh <- read_csv(api_response_etoh_csv)

#clean up the data file
etoh<-etoh%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Alcohol ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(etoh$timeResolution, -2, -1)))   #adds these columns



# * ALCOHOL ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20alcohol%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_etohAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
etohAge <- read_csv(api_response_etohAge_csv)

#clean up the data file
etohAge<-etohAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Alcohol ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(etohAge$timeResolution, -2, -1))   #adds these columns


# * ALCOHOL ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20alcohol%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_etohSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
etohSex <- read_csv(api_response_etohSex_csv)

#clean up the data file
etohSex<-etohSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Alcohol ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(etohSex$timeResolution, -2, -1))   #adds these columns


# * ALCOHOL ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20alcohol%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_etohRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
etohRace <- read_csv(api_response_etohRace_csv)

#clean up the data file
etohRace<-etohRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Alcohol ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(etohRace$timeResolution, -2, -1))   #adds these columns


# * ALCOHOL ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20alcohol%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_etohEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
etohEthnicity <- read_csv(api_response_etohEthnicity_csv)

#clean up the data file
etohEthnicity<-etohEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Alcohol ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(etohEthnicity$timeResolution, -2, -1))   #adds these columns






#DRUG ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20all%20drug%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_drug_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
drug <- read_csv(api_response_drug_csv)

#clean up the data file
drug<-drug%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Drug ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(drug$timeResolution, -2, -1)))   #adds these columns



# * DRUG ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20all%20drug%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_drugAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
drugAge <- read_csv(api_response_drugAge_csv)

#clean up the data file
drugAge<-drugAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Drug ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(drugAge$timeResolution, -2, -1))   #adds these columns


# * DRUG ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20all%20drug%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_drugSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
drugSex <- read_csv(api_response_drugSex_csv)

#clean up the data file
drugSex<-drugSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Drug ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(drugSex$timeResolution, -2, -1))   #adds these columns


# * DRUG ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20all%20drug%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_drugRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
drugRace <- read_csv(api_response_drugRace_csv)

#clean up the data file
drugRace<-drugRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Drug ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(drugRace$timeResolution, -2, -1))   #adds these columns


# * DRUG ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20all%20drug%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_drugEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
drugEthnicity <- read_csv(api_response_drugEthnicity_csv)

#clean up the data file
drugEthnicity<-drugEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Drug ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(drugEthnicity$timeResolution, -2, -1))   #adds these columns





#SUICIDE ATTEMPT ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_sa_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
sa <- read_csv(api_response_sa_csv)

#clean up the data file
sa<-sa%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(sa$timeResolution, -2, -1)))   #adds these columns



# * SUICIDE ATTEMPT ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saAge <- read_csv(api_response_saAge_csv)

#clean up the data file
saAge<-saAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saAge$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saSex <- read_csv(api_response_saSex_csv)

#clean up the data file
saSex<-saSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saSex$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saRace <- read_csv(api_response_saRace_csv)

#clean up the data file
saRace<-saRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saRace$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saEthnicity <- read_csv(api_response_saEthnicity_csv)

#clean up the data file
saEthnicity<-saEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saEthnicity$timeResolution, -2, -1))   #adds these columns




#SUICIDE ATTEMPT IP######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=2Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenI=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saip_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saip <- read_csv(api_response_saip_csv)

#clean up the data file
saip<-saip%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt IP", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(saip$timeResolution, -2, -1)))   #adds these columns



# * SUICIDE ATTEMPT IP BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saipAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saipAge <- read_csv(api_response_saipAge_csv)

#clean up the data file
saipAge<-saipAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt IP", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saipAge$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT IP BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saipSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saipSex <- read_csv(api_response_saipSex_csv)

#clean up the data file
saipSex<-saipSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt IP", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saipSex$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT IP BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saipRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saipRace <- read_csv(api_response_saipRace_csv)

#clean up the data file
saipRace<-saipRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt IP", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saipRace$timeResolution, -2, -1))   #adds these columns


# * SUICIDE ATTEMPT IP BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicide%20attempt%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_saipEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
saipEthnicity <- read_csv(api_response_saipEthnicity_csv)

#clean up the data file
saipEthnicity<-saipEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Attempt IP", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(saipEthnicity$timeResolution, -2, -1))   #adds these columns




#SUICIDE IDEATION ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_si_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
si <- read_csv(api_response_si_csv)

#clean up the data file
si<-si%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(si$timeResolution, -2, -1)))   #adds these columns



# * SUICIDE IDEATION ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siAge <- read_csv(api_response_siAge_csv)

#clean up the data file
siAge<-siAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siAge$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siSex <- read_csv(api_response_siSex_csv)

#clean up the data file
siSex<-siSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siSex$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siRace <- read_csv(api_response_siRace_csv)

#clean up the data file
siRace<-siRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siRace$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siEthnicity <- read_csv(api_response_siEthnicity_csv)

#clean up the data file
siEthnicity<-siEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siEthnicity$timeResolution, -2, -1))   #adds these columns




#SUICIDE IDEATION IP######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=2Jan2021&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenI=1&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siip_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siip <- read_csv(api_response_siip_csv)

#clean up the data file
siip<-siip%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation IP", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(siip$timeResolution, -2, -1)))   #adds these columns



# * SUICIDE IDEATION IP BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siipAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siipAge <- read_csv(api_response_siipAge_csv)

#clean up the data file
siipAge<-siipAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation IP", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siipAge$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION IP BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siipSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siipSex <- read_csv(api_response_siipSex_csv)

#clean up the data file
siipSex<-siipSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation IP", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siipSex$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION IP BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siipRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siipRace <- read_csv(api_response_siipRace_csv)

#clean up the data file
siipRace<-siipRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation IP", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siipRace$timeResolution, -2, -1))   #adds these columns


# * SUICIDE IDEATION IP BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=ccddCategory&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20suicidal%20ideation%20v1&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenI=1&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_siipEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
siipEthnicity <- read_csv(api_response_siipEthnicity_csv)

#clean up the data file
siipEthnicity<-siipEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Suicide Ideation IP", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(siipEthnicity$timeResolution, -2, -1))   #adds these columns




#SELF HARM ED######################################################################################


#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=12Dec2020&geography=wa_spokane&percentParam=dischargeDiagnosis&datasource=va_er&startDate=30Dec2018&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&dischargeDiagnosisApplyTo=admitReasonCode,admitReasonCombo,ccHistory&geographySystem=region&detector=c2&timeResolution=weekly&hasBeenE=1&dischargeDiagnosis=%5E;X7%5B1-9%5D%5E,OR,%5E;X8%5B0-3%5D%5E,OR,%5E;248061004%5E,OR,%5E;102911000%5E,OR,(,%5ESELF%5E,AND,(,%5EHARM%5E,OR,%5EHURT%5E,OR,%5EINFLICT%5E,OR,%5ELACERAT%5E,OR,%5EMUTILAT%5E,OR,%5ECUT%5E,),),ANDNOT,(,%5EDENIES%20SELF_HARM%5E,OR,%5ENO%20SELF_HARM%5E,),OR,%5E;T3%5B6-9%5D__2%5E,OR,%5E;T3%5B6-9%5D.__2%5E,OR,%5E;T3%5B679%5D92%5E,OR,%5E;T3%5B679%5D.92%5E,OR,%5E;T4%5B0-9%5D__2%5E,OR,%5E;T4%5B0-9%5D.__2%5E,OR,%5E;T50__2%5E,OR,%5E;T50.__2%5E,OR,%5E;T4142%5E,OR,%5E;T41.42%5E,OR,%5E;T4272%5E,OR,%5E;T42.72%5E,OR,%5E;T4%5B3579%5D92%5E,OR,%5E;T4%5B3579%5D.92%5E,OR,%5E;T5%5B1-9%5D__2%5E,OR,%5E;T5%5B1-9%5D.__2%5E,OR,%5E;T6%5B0-5%5D__2%5E,OR,%5E;T6%5B0-5%5D.__2%5E,OR,%5E;T5%5B1-467%5D92%5E,OR,%5E;T5%5B1-467%5D.92%5E,OR,%5E;T58%5B019%5D2%5E,OR,%5E;T58.%5B019%5D2%5E,OR,%5E;T5992%5E,OR,%5E;T59.92%5E,OR,%5E;T6092%5E,OR,%5E;T60.92%5E,OR,%5E;T61%5B019%5D2%5E,OR,%5E;T61.%5B019%5D2%5E,OR,%5E;T6%5B235%5D92%5E,OR,%5E;T6%5B235%5D.92%5E,OR,%5E;T64%5B08%5D2%5E,OR,%5E;T64.%5B08%5D2%5E,OR,%5E;T71__2%5E,OR,%5E;T71.__2%5E&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_harm_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
harm <- read_csv(api_response_harm_csv)

#clean up the data file
harm<-harm%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Self Harm ED", Total="Total", Sex=NA, Race=NA, Hispanic=NA,`Age Group`=NA, month=NA,
         Year=substr(timeResolution, 1, 4), week=as.numeric(str_sub(harm$timeResolution, -2, -1)))   #adds these columns



# * SELF HARM ED BY AGE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=dischargeDiagnosis&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&dischargeDiagnosisApplyTo=admitReasonCode,admitReasonCombo,ccHistory&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&dischargeDiagnosis=%5E;X7%5B1-9%5D%5E,OR,%5E;X8%5B0-3%5D%5E,OR,%5E;248061004%5E,OR,%5E;102911000%5E,OR,(,%5ESELF%5E,AND,(,%5EHARM%5E,OR,%5EHURT%5E,OR,%5EINFLICT%5E,OR,%5ELACERAT%5E,OR,%5EMUTILAT%5E,OR,%5ECUT%5E,),),ANDNOT,(,%5EDENIES%20SELF_HARM%5E,OR,%5ENO%20SELF_HARM%5E,),OR,%5E;T3%5B6-9%5D__2%5E,OR,%5E;T3%5B6-9%5D.__2%5E,OR,%5E;T3%5B679%5D92%5E,OR,%5E;T3%5B679%5D.92%5E,OR,%5E;T4%5B0-9%5D__2%5E,OR,%5E;T4%5B0-9%5D.__2%5E,OR,%5E;T50__2%5E,OR,%5E;T50.__2%5E,OR,%5E;T4142%5E,OR,%5E;T41.42%5E,OR,%5E;T4272%5E,OR,%5E;T42.72%5E,OR,%5E;T4%5B3579%5D92%5E,OR,%5E;T4%5B3579%5D.92%5E,OR,%5E;T5%5B1-9%5D__2%5E,OR,%5E;T5%5B1-9%5D.__2%5E,OR,%5E;T6%5B0-5%5D__2%5E,OR,%5E;T6%5B0-5%5D.__2%5E,OR,%5E;T5%5B1-467%5D92%5E,OR,%5E;T5%5B1-467%5D.92%5E,OR,%5E;T58%5B019%5D2%5E,OR,%5E;T58.%5B019%5D2%5E,OR,%5E;T5992%5E,OR,%5E;T59.92%5E,OR,%5E;T6092%5E,OR,%5E;T60.92%5E,OR,%5E;T61%5B019%5D2%5E,OR,%5E;T61.%5B019%5D2%5E,OR,%5E;T6%5B235%5D92%5E,OR,%5E;T6%5B235%5D.92%5E,OR,%5E;T64%5B08%5D2%5E,OR,%5E;T64.%5B08%5D2%5E,OR,%5E;T71__2%5E,OR,%5E;T71.__2%5E&rowFields=age&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_harmAge_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
harmAge <- read_csv(api_response_harmAge_csv)

#clean up the data file
harmAge<-harmAge%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, `Age Group`=age)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Self Harm ED", Total=NA, Sex=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(harmAge$timeResolution, -2, -1))   #adds these columns


# * SELF HARM ED BY SEX ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=dischargeDiagnosis&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&dischargeDiagnosisApplyTo=admitReasonCode,admitReasonCombo,ccHistory&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&dischargeDiagnosis=%5E;X7%5B1-9%5D%5E,OR,%5E;X8%5B0-3%5D%5E,OR,%5E;248061004%5E,OR,%5E;102911000%5E,OR,(,%5ESELF%5E,AND,(,%5EHARM%5E,OR,%5EHURT%5E,OR,%5EINFLICT%5E,OR,%5ELACERAT%5E,OR,%5EMUTILAT%5E,OR,%5ECUT%5E,),),ANDNOT,(,%5EDENIES%20SELF_HARM%5E,OR,%5ENO%20SELF_HARM%5E,),OR,%5E;T3%5B6-9%5D__2%5E,OR,%5E;T3%5B6-9%5D.__2%5E,OR,%5E;T3%5B679%5D92%5E,OR,%5E;T3%5B679%5D.92%5E,OR,%5E;T4%5B0-9%5D__2%5E,OR,%5E;T4%5B0-9%5D.__2%5E,OR,%5E;T50__2%5E,OR,%5E;T50.__2%5E,OR,%5E;T4142%5E,OR,%5E;T41.42%5E,OR,%5E;T4272%5E,OR,%5E;T42.72%5E,OR,%5E;T4%5B3579%5D92%5E,OR,%5E;T4%5B3579%5D.92%5E,OR,%5E;T5%5B1-9%5D__2%5E,OR,%5E;T5%5B1-9%5D.__2%5E,OR,%5E;T6%5B0-5%5D__2%5E,OR,%5E;T6%5B0-5%5D.__2%5E,OR,%5E;T5%5B1-467%5D92%5E,OR,%5E;T5%5B1-467%5D.92%5E,OR,%5E;T58%5B019%5D2%5E,OR,%5E;T58.%5B019%5D2%5E,OR,%5E;T5992%5E,OR,%5E;T59.92%5E,OR,%5E;T6092%5E,OR,%5E;T60.92%5E,OR,%5E;T61%5B019%5D2%5E,OR,%5E;T61.%5B019%5D2%5E,OR,%5E;T6%5B235%5D92%5E,OR,%5E;T6%5B235%5D.92%5E,OR,%5E;T64%5B08%5D2%5E,OR,%5E;T64.%5B08%5D2%5E,OR,%5E;T71__2%5E,OR,%5E;T71.__2%5E&rowFields=sex&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_harmSex_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
harmSex <- read_csv(api_response_harmSex_csv)

#clean up the data file
harmSex<-harmSex%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Sex=sex)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Self Harm ED", Total=NA, `Age Group`=NA, Race=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(harmSex$timeResolution, -2, -1))   #adds these columns


# * SELF HARM ED BY RACE ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=dischargeDiagnosis&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&dischargeDiagnosisApplyTo=admitReasonCode,admitReasonCombo,ccHistory&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&dischargeDiagnosis=%5E;X7%5B1-9%5D%5E,OR,%5E;X8%5B0-3%5D%5E,OR,%5E;248061004%5E,OR,%5E;102911000%5E,OR,(,%5ESELF%5E,AND,(,%5EHARM%5E,OR,%5EHURT%5E,OR,%5EINFLICT%5E,OR,%5ELACERAT%5E,OR,%5EMUTILAT%5E,OR,%5ECUT%5E,),),ANDNOT,(,%5EDENIES%20SELF_HARM%5E,OR,%5ENO%20SELF_HARM%5E,),OR,%5E;T3%5B6-9%5D__2%5E,OR,%5E;T3%5B6-9%5D.__2%5E,OR,%5E;T3%5B679%5D92%5E,OR,%5E;T3%5B679%5D.92%5E,OR,%5E;T4%5B0-9%5D__2%5E,OR,%5E;T4%5B0-9%5D.__2%5E,OR,%5E;T50__2%5E,OR,%5E;T50.__2%5E,OR,%5E;T4142%5E,OR,%5E;T41.42%5E,OR,%5E;T4272%5E,OR,%5E;T42.72%5E,OR,%5E;T4%5B3579%5D92%5E,OR,%5E;T4%5B3579%5D.92%5E,OR,%5E;T5%5B1-9%5D__2%5E,OR,%5E;T5%5B1-9%5D.__2%5E,OR,%5E;T6%5B0-5%5D__2%5E,OR,%5E;T6%5B0-5%5D.__2%5E,OR,%5E;T5%5B1-467%5D92%5E,OR,%5E;T5%5B1-467%5D.92%5E,OR,%5E;T58%5B019%5D2%5E,OR,%5E;T58.%5B019%5D2%5E,OR,%5E;T5992%5E,OR,%5E;T59.92%5E,OR,%5E;T6092%5E,OR,%5E;T60.92%5E,OR,%5E;T61%5B019%5D2%5E,OR,%5E;T61.%5B019%5D2%5E,OR,%5E;T6%5B235%5D92%5E,OR,%5E;T6%5B235%5D.92%5E,OR,%5E;T64%5B08%5D2%5E,OR,%5E;T64.%5B08%5D2%5E,OR,%5E;T71__2%5E,OR,%5E;T71.__2%5E&rowFields=race&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_harmRace_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
harmRace <- read_csv(api_response_harmRace_csv)

#clean up the data file
harmRace<-harmRace%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Race=race)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Self Harm ED", Total=NA, `Age Group`=NA, Sex=NA, Hispanic=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(harmRace$timeResolution, -2, -1))   #adds these columns


# * SELF HARM ED BY ETHNICITY ----

#Create the url pathway from the API link from the time series in ESSENCE
url<-"https://essence.syndromicsurveillance.org/nssp_essence/api/tableBuilder/csv?endDate=31Dec2020&geography=wa_spokane&percentParam=dischargeDiagnosis&datasource=va_er&startDate=1Jan2019&medicalGroupingSystem=essencesyndromes&userId=3405&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&dischargeDiagnosisApplyTo=admitReasonCode,admitReasonCombo,ccHistory&geographySystem=region&detector=nodetectordetector&timeResolution=monthly&hasBeenE=1&dischargeDiagnosis=%5E;X7%5B1-9%5D%5E,OR,%5E;X8%5B0-3%5D%5E,OR,%5E;248061004%5E,OR,%5E;102911000%5E,OR,(,%5ESELF%5E,AND,(,%5EHARM%5E,OR,%5EHURT%5E,OR,%5EINFLICT%5E,OR,%5ELACERAT%5E,OR,%5EMUTILAT%5E,OR,%5ECUT%5E,),),ANDNOT,(,%5EDENIES%20SELF_HARM%5E,OR,%5ENO%20SELF_HARM%5E,),OR,%5E;T3%5B6-9%5D__2%5E,OR,%5E;T3%5B6-9%5D.__2%5E,OR,%5E;T3%5B679%5D92%5E,OR,%5E;T3%5B679%5D.92%5E,OR,%5E;T4%5B0-9%5D__2%5E,OR,%5E;T4%5B0-9%5D.__2%5E,OR,%5E;T50__2%5E,OR,%5E;T50.__2%5E,OR,%5E;T4142%5E,OR,%5E;T41.42%5E,OR,%5E;T4272%5E,OR,%5E;T42.72%5E,OR,%5E;T4%5B3579%5D92%5E,OR,%5E;T4%5B3579%5D.92%5E,OR,%5E;T5%5B1-9%5D__2%5E,OR,%5E;T5%5B1-9%5D.__2%5E,OR,%5E;T6%5B0-5%5D__2%5E,OR,%5E;T6%5B0-5%5D.__2%5E,OR,%5E;T5%5B1-467%5D92%5E,OR,%5E;T5%5B1-467%5D.92%5E,OR,%5E;T58%5B019%5D2%5E,OR,%5E;T58.%5B019%5D2%5E,OR,%5E;T5992%5E,OR,%5E;T59.92%5E,OR,%5E;T6092%5E,OR,%5E;T60.92%5E,OR,%5E;T61%5B019%5D2%5E,OR,%5E;T61.%5B019%5D2%5E,OR,%5E;T6%5B235%5D92%5E,OR,%5E;T6%5B235%5D.92%5E,OR,%5E;T64%5B08%5D2%5E,OR,%5E;T64.%5B08%5D2%5E,OR,%5E;T71__2%5E,OR,%5E;T71.__2%5E&rowFields=ethnicity&rowFields=timeResolution&columnField=geographyregion"


##Include the desired dates set above
url <- gsub(pattern="endDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('endDate=', 
                                                                                  s_end_date), x=url)
url <- gsub(pattern="startDate=[0-9]{1,2}[A-Z][a-z][a-z][0-9]{2,4}", replace=paste0('startDate=', 
                                                                                    s_start_date), x=url)

#Call ESSENCE credentials
api_response <- GET(url, authenticate(key_list("essence")[1,2], 
                                      key_get("essence", 
                                              key_list("essence")[1,2]))) 

#This should create an object in the values section with some data
api_response_harmEthnicity_csv <- content(api_response, by= "csv/text")

#This should create a data frame in the data section
harmEthnicity <- read_csv(api_response_harmEthnicity_csv)

#clean up the data file
harmEthnicity<-harmEthnicity%>%
  rename(Percent=WA_Spokane, Count=`WA_Spokane Data Count`, Hispanic=ethnicity)%>%
  select(-`WA_Spokane All Count`)%>%   #removes this column
  mutate(Indicator="Self Harm ED", Total=NA, `Age Group`=NA, Sex=NA, Race=NA, week=NA, 
         Year=substr(timeResolution, 1, 4), month=str_sub(harmEthnicity$timeResolution, -2, -1))   #adds these columns




#COMBINE INTO ONE DF########################################################################################

#combine df
MentalHealthCleaned<-rbind(dmh, dmhAge, dmhSex, dmhRace, dmhEthnicity, dmhip, dmhipAge, dmhipSex, dmhipRace, dmhipEthnicity,
                           psych, psychAge, psychSex, psychRace, psychEthnicity, etoh, etohAge, etohSex, etohRace, etohEthnicity,
                           drug, drugAge, drugSex, drugRace, drugEthnicity, sa, saAge, saSex, saRace, saEthnicity, 
                           saip, saipAge, saipSex, saipRace, saipEthnicity, si, siAge, siSex, siRace, siEthnicity, 
                           siip, siipAge, siipSex, siipRace, siipEthnicity, harm, harmAge, harmSex, harmRace, harmEthnicity)
MentalHealthCleaned<-MentalHealthCleaned%>%
  mutate(week=as.numeric(week), month=as.numeric(month), Year=as.numeric(Year))

#export data
write.csv(MentalHealthCleaned, file="C:/Users/ariffe/Spokane Regional Health District/Data Center Team - Documents/Mental Health 2020/Essence data/BehavioralHealthEssence.csv")
