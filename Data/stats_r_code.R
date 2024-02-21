#Select the local working directory
#proj_directory <- "C:/Users/jadem/OneDrive/Desktop/BABD/Statistics/PersoProject/Statistics_Project/Data"
proj_directory <- "C:/Users/jadem/OneDrive/Desktop/BABD/Statistics/PersoProject/Statistics_Project/Data"
setwd(proj_directory)

#load packages
library(tidyverse)
library(dplyr)
library(ggplot2)

#Import data from local .csv
col_data <- read.csv("cost-of-living_v2.csv")

#EDA

#summary of what the dataset looks like
View(col_data)
str(col_data)
dim(col_data) # obs./row:4956  variables/columns:58
length(unique(col_data$country)) #215 distinct countries
summary(col_data)

#Index table explaining the meaning of each column label
index_table <- data.frame(
  column_name = c("city", "country", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19", "x20", "x21", "x22", "x23", "x24", "x25", "x26", "x27", "x28", "x29", "x30", "x31", "x32", "x33", "x34", "x35", "x36", "x37", "x38", "x39", "x40", "x41", "x42", "x43", "x44", "x45", "x46", "x47", "x48", "x49", "x50", "x51", "x52", "x53", "x54", "x55", "data_quality"), 
  description = c("Name of the city","Name of the country","Meal, Inexpensive Restaurant (USD)","Meal for 2 People, Mid-range Restaurant, Three-course (USD)","McMeal at McDonalds (or Equivalent Combo Meal) (USD)","Domestic Beer (0.5 liter draught, in restaurants) (USD)","Imported Beer (0.33 liter bottle, in restaurants) (USD)","Cappuccino (regular, in restaurants) (USD)","Coke/Pepsi (0.33 liter bottle, in restaurants) (USD)","Water (0.33 liter bottle, in restaurants) (USD)","Milk (1 liter) (USD)","Loaf of Fresh White Bread (500g) (USD)","Rice (white), (1kg) (USD)","Eggs (regular) (12) (USD)","Local Cheese (1kg) (USD)","Chicken Fillets (1kg) (USD)","Beef Round (1kg) (or Equivalent Back Leg Red Meat) (USD)","Apples (1kg) (USD)","Banana (1kg) (USD)","Oranges (1kg) (USD)","Tomato (1kg) (USD)","Potato (1kg) (USD)","Onion (1kg) (USD)","Lettuce (1 head) (USD)","Water (1.5 liter bottle, at the market) (USD)","Bottle of Wine (Mid-Range, at the market) (USD)","Domestic Beer (0.5 liter bottle, at the market) (USD)","Imported Beer (0.33 liter bottle, at the market) (USD)","Cigarettes 20 Pack (Marlboro) (USD)","One-way Ticket (Local Transport) (USD)","Monthly Pass (Regular Price) (USD)","Taxi Start (Normal Tariff) (USD)","Taxi 1km (Normal Tariff) (USD)","Taxi 1hour Waiting (Normal Tariff) (USD)","Gasoline (1 liter) (USD)","Volkswagen Golf 1.4 90 KW Trendline (Or Equivalent New Car) (USD)","Toyota Corolla Sedan 1.6l 97kW Comfort (Or Equivalent New Car) (USD)","Basic (Electricity, Heating, Cooling, Water, Garbage) for 85m2 Apartment (USD)","1 min. of Prepaid Mobile Tariff Local (No Discounts or Plans) (USD)","Internet (60 Mbps or More, Unlimited Data, Cable/ADSL) (USD)","Fitness Club, Monthly Fee for 1 Adult (USD)","Tennis Court Rent (1 Hour on Weekend) (USD)","Cinema, International Release, 1 Seat (USD)","Preschool (or Kindergarten), Full Day, Private, Monthly for 1 Child (USD)","International Primary School, Yearly for 1 Child (USD)","1 Pair of Jeans (Levis 501 Or Similar) (USD)","1 Summer Dress in a Chain Store (Zara, H&M, …) (USD)","1 Pair of Nike Running Shoes (Mid-Range) (USD)","1 Pair of Men Leather Business Shoes (USD)","Apartment (1 bedroom) in City Centre (USD)","Apartment (1 bedroom) Outside of Centre (USD)","Apartment (3 bedrooms) in City Centre (USD)","Apartment (3 bedrooms) Outside of Centre (USD)","Price per Square Meter to Buy Apartment in City Centre (USD)","Price per Square Meter to Buy Apartment Outside of Centre (USD)","Average Monthly Net Salary (After Tax) (USD)","Mortgage Interest Rate in Percentages (%), Yearly, for 20 Years Fixed-Rate","0 if Numbeo considers that more contributors are needed to increase data quality, else 1"))

View(index_table)
subset(index_table, column_name=="x34") #Find one specific row given the column label, just replace "x34"

#Visualising the summary as boxplots
library(tidyr)

col_data_long <- gather(col_data, key = "metric", value = "value", -city, -country)

ggplot(col_data_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "pink", color = "black") +
  labs(title = "Distribution of Cost of Living Metrics",
       x = "Metric", y = "Cost (USD)")

#Visualising the summary as boxplots grouped by category
restaurants <- c("x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8") #columns to visualise
restaurants1 <- col_data[, c("city", "country", restaurants)] #subset data to include only the specified columns
restaurants1_long <- gather(restaurants1, key = "metric", value = "value", -city, -country) #gather the subsetted data into key-value pairs

markets <- c("x9", "x10", "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19", "x20", "x21", "x22", "x23", "x24", "x25", "x26", "x27")
markets1 <- col_data[, c("city", "country", markets)]
markets1_long <- gather(markets1, key = "metric", value = "value", -city, -country)

transportation <- c("x28", "x29", "x30", "x31", "x32", "x33", "x34", "x35")
transportation1 <- col_data[, c("city", "country", transportation)]
transportation1_long <- gather(transportation1, key = "metric", value = "value", -city, -country)

utilities <- c("x36", "x37", "x38")
utilities1 <- col_data[, c("city", "country", utilities)]
utilities1_long <- gather(utilities1, key = "metric", value = "value", -city, -country)

sports_and_leisure <- c("x39", "x40", "x41")
sports_and_leisure1 <- col_data[, c("city", "country", sports_and_leisure)]
sports_and_leisure1_long <- gather(sports_and_leisure1, key = "metric", value = "value", -city, -country)

childcare <- c("x42", "x43")
childcare1 <- col_data[, c("city", "country", childcare)]
childcare1_long <- gather(childcare1, key = "metric", value = "value", -city, -country)

clothing_and_shoes <- c("x44", "x45", "x46", "x47")
clothing_and_shoes1 <- col_data[, c("city", "country", clothing_and_shoes)]
clothing_and_shoes1_long <- gather(clothing_and_shoes1, key = "metric", value = "value", -city, -country)

rent_per_month <- c("x48", "x49", "x50", "x51")
rent_per_month1 <- col_data[, c("city", "country", rent_per_month)]
rent_per_month1_long <- gather(rent_per_month1, key = "metric", value = "value", -city, -country)

buy_apartment_price <- c("x52", "x53")
buy_apartment_price1 <- col_data[, c("city", "country", buy_apartment_price)]
buy_apartment_price1_long <- gather(buy_apartment_price1, key = "metric", value = "value", -city, -country)

salaries_and_financing <- c("x54", "x55")
salaries_and_financing1 <- col_data[, c("city", "country", salaries_and_financing)]
salaries_and_financing1_long <- gather(salaries_and_financing1, key = "metric", value = "value", -city, -country)

#Plots
ggplot(restaurants1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "pink", color = "black") +
  labs(title = "Distribution of Restaurants Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(markets1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  labs(title = "Distribution of Markets Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(transportation1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "red", color = "black") +
  labs(title = "Distribution of Transportation Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(utilities1_long, aes(x = metric, y = value)) + #Solomon islands outlier in internet -> false data
  geom_boxplot(fill = "orange", color = "black") +
  labs(title = "Distribution of Utilities Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(sports_and_leisure1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  labs(title = "Distribution of Sports And Leisure Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(childcare1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "yellow", color = "black") +
  labs(title = "Distribution of Childcare Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(clothing_and_shoes1_long, aes(x = metric, y = value)) +
  geom_boxplot(fill = "purple", color = "black") +
  labs(title = "Distribution of Clothing And Shoes Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(rent_per_month1_long, aes(x = metric, y = value)) + #Seoul and Shanghai are outliers they might be mistakes
  geom_boxplot(fill = "green", color = "black") +
  labs(title = "Distribution of Rent Per Month Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(buy_apartment_price1_long, aes(x = metric, y = value)) + #Seoul is the outlier, I suspect the value is incorrect
  geom_boxplot(fill = "brown", color = "black") +
  labs(title = "Distribution of Buy Apartment Price Metrics",
       x = "Metric", y = "Cost (USD)")

ggplot(salaries_and_financing1_long, aes(x = metric, y = value)) + #Seoul salary outlier again, this might be another error
  geom_boxplot(fill = "violet", color = "black") +
  labs(title = "Distribution of Salaries And Financing Metrics",
       x = "Metric", y = "Cost (USD)")

#check for missing values
sum(is.na(col_data)) #45858 -> there are a lot of missing values to manage

  #OPT 1: Dropping -  remove rows with any missing values
    col_data_dropna <- na.omit(col_data)
  
  #ANALYSIS
    sum(is.na(col_data_dropna)) #0 -> ideal
    dim(col_data_dropna) # obs./row:1278  variables/columns:58 -> lost over 3500 rows
    length(unique(col_data_dropna$country)) #150 distinct countries -> lost data for 65 countries
  
  #OPT 2: Dropping - rows with data_quality = 0
    col_data_drop0 <- subset(col_data, data_quality != 0)
  
  #ANALYSIS
    sum(is.na(col_data_drop0)) #270 -> significantly reduced number
    dim(col_data_drop0) # obs./row:923  variables/columns:58 -> lost over 4000 rows
    length(unique(col_data_drop0$country)) #146 distinct countries -> lost data for 69 countries
  
  #OPT 3: Imputation with Mean, Median or Mode -> Categorical columns do not have any missing values.
    col_imputed <- col_data #duplicating the data to avoid editing the og data.frame
    n_columns <- sapply(col_imputed, is.numeric) #select only numeric columns
    mean <- colMeans(col_imputed[, n_columns], na.rm = TRUE) #Numeric columns -> MEAN, MEDIAN cannot compute as the function doesn't work if there are missing values
    
    col_imputed[, n_columns] <- lapply(col_imputed[, n_columns], function(x) {
      is_na <- is.na(x)
      ifelse(is_na, ifelse(is.numeric(x), mean), x)
    })
      
  #ANALYSIS
    sum(is.na(col_imputed)) #0 -> perfect
    dim(col_imputed) # obs./row:4956  variables/columns:58 -> no rows lost
    summary(col_imputed) #compared to summary(col_data) -> distribution is heavily impacted as it now pulls towards itself. It also impacts relationships and correlations as the mean is not weighted. Aslo shoudl check it sensitivity against outliers.
    length(unique(col_imputed$country)) #215 distinct countries -> no lost countries
  
  #OPT 4: Imputation with Mean of data grouped by country
    library(magrittr) #so we can use the pipe operator %>%
    
    col_imputed_country <- col_data
    
    col_imputed_country <- col_imputed_country %>%
      group_by(country) %>%
      mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) #Group by 'country' and calculate mean for each numeric column
    
  #ANALYSIS
    sum(is.na(col_imputed_country)) #698 -> we still have some missing values as some countries might only have 1 entry and there is no possibility to calculate the mean for those (e.g. Vatican City)
    dim(col_imputed_country) # obs./row:4956  variables/columns:58 -> no rows/columns lost
    summary(col_imputed_country) #compared to summary(col_imputed) -> 
    length(unique(col_imputed_country$country)) #215 distinct countries -> no lost countries
  
#Final Decision: Imputation with Mean of data grouped by country & Dropping missing values
library(magrittr) #so we can use the pipe operator %>%

col_imputed_country <- col_data

col_imputed_country <- col_imputed_country %>%
  group_by(country) %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) #Group by 'country' and calculate mean for each numeric column


data <- na.omit(col_imputed_country) #drop remaining missing values

#ANALYSIS
sum(is.na(data)) #0
dim(data) # obs./row:4849  variables/columns:58 -> little rows/columns lost
summary(data) #compared to summary(col_imputed) -> distribution and relationships are impacted as it now pulls towards each country avg. 
length(unique(data$country)) #153 distinct countries -> 62 lost countries


