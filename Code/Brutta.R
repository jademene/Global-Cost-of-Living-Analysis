#---
#title: "Cost Of Living | What are the main drivers of cost-of-living disparities between developed and developing nations?"
#output: r_document
#---
#Plan of Action:
#  1. Clean the data
#  2. Group data by country
#   2.1 City column to be dropped
#   2.2 Variables values => avg. of cities data
#  3. Group by country development status
#   3.1 Human Development Index (HDI) status data taken from UN https://hdr.undp.org/data-center/country-insights
#  4. Divide the ranked data into quarters
#    4.1 Drop na => simplifiaction of analysis
#  5. Analysis
#   5.1 Descriptive Statistics for Each Group
#   5.2 Compare Descriptive Statistics for Each Group
# 6.0 Group data by categories
# 7. Simple linear regression for markets
#   7.0 group vhigh, high, medium and low into 1 table.
#   7.1 vhigh vs High
#   7.3 vhigh vs Medium
#   7.4 vhigh vs Low
# 8. Multiple linear regression 
#---
#Select the local working directory
proj_directory <- "C:/Users/jadem/OneDrive/Desktop/BABD/Statistics/PersoProject/Statistics_Project"
setwd(proj_directory)
#---
#Load the libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr) #to be able to use gather()
library(magrittr) #so we can use the pipe operator %>%
#---
#Import data from local .csv
col_data <- read.csv("cost-of-living_v2.csv")
#---
#1. Clean the data
col_imputed_country <- col_data
col_imputed_country <- col_imputed_country %>%
  group_by(country) %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) #Group by 'country' and calculate mean for each numeric column

col_imputed_na <- na.omit(col_imputed_country) #drop remaining missing values

data <- select(col_imputed_na, -x28, -x29, -x40, -x43, -x50, -x51, -x52, -x53) #Lastly remove from data the variables highlighted above as missing too many values for analysis.

#---
#2. Group data by country
data_by_country <- data %>%
  group_by(country) %>%
  summarise(
    x1 = mean(x1),
    x2 = mean(x2),
    x3 = mean(x3),
    x4 = mean(x4),
    x5 = mean(x5),
    x6 = mean(x6),
    x7 = mean(x7),
    x8 = mean(x8),
    x9 = mean(x9),
    x10 = mean(x10),
    x11 = mean(x11),
    x12 = mean(x12),
    x13 = mean(x13),
    x14 = mean(x14),
    x15 = mean(x15),
    x16 = mean(x16),
    x17 = mean(x17),
    x18 = mean(x18),
    x19 = mean(x19),
    x20 = mean(x20),
    x21 = mean(x21),
    x22 = mean(x22),
    x23 = mean(x23),
    x24 = mean(x24),
    x25 = mean(x25),
    x26 = mean(x26),
    x27 = mean(x27),
    x30 = mean(x30),
    x31 = mean(x31),
    x32 = mean(x32),
    x33 = mean(x33),
    x34 = mean(x34),
    x35 = mean(x35),
    x36 = mean(x36),
    x37 = mean(x37),
    x38 = mean(x38),
    x39 = mean(x39),
    x41 = mean(x41),
    x42 = mean(x42),
    x44 = mean(x44),
    x45 = mean(x45),
    x46 = mean(x46),
    x47 = mean(x47),
    x48 = mean(x48),
    x49 = mean(x49),
    x54 = mean(x54),
    x55 = mean(x55)
  )
#---
#3. Group by country development status
HDI_data <- read.csv("HDI.csv")
merged_data <- merge(data_by_country, HDI_data, by = "country", all.x = TRUE)
merged_data$Rank[is.na(merged_data$Rank)] <- 0 #replacing Rank NA with 0 for later easy separation with filter
#---
#4. Divide the ranked data into development level
vhigh_rank <- filter(merged_data, Rank >= 1 & Rank < 66)
high_rank <- filter(merged_data, Rank >= 67 & Rank < 115)
medium_rank <- filter(merged_data, Rank >= 116 & Rank < 159)
low_rank <- filter(merged_data, Rank >= 160 & Rank < 191)
na_rank <- filter(merged_data, Rank == 0)

view(vhigh_rank)
view(high_rank)
view(medium_rank)
view(low_rank)
view(na_rank)
#---
#The split in the different levels of country development follows the UN classification from "very high" to "low". From looking at the four tables we can see that there is not an even split in the categories
#4.1 Drop na
#---
#5. ANALYSIS
#5.1 Descriptive statistics for each column and development level
# vhigh level of development
vhigh <- vhigh_rank %>%
  summarise(across(where(is.numeric), list(
    vhighMean = mean
  ), .names = "{col}_{fn}"))

# high level of development
high <- high_rank %>%
  summarise(across(where(is.numeric), list(
    highMean = mean
  ), .names = "{col}_{fn}"))

# medium level of development
medium <- medium_rank %>%
  summarise(across(where(is.numeric), list(
    mediumMean = mean
  ), .names = "{col}_{fn}"))

# low level of development
low <- low_rank %>%
  summarise(across(where(is.numeric), list(
    lowMean = mean
  ), .names = "{col}_{fn}"))

vhighmeans <- colMeans(vhigh_rank)
lowmeans <- colMeans(low_rank)
correl <- cor(vhigh,high)
view(correl)
#Format the table to comine all of them in one
combined_summary <- bind_rows(vhigh, high, medium, low) #combine into one data frame for ease of analysis

dev_level_summary1 <- pivot_longer(combined_summary,
                                   cols = -c(dev_level),
                                   names_to = c(".value", "stat"), 
                                   names_sep = "_") %>%
  mutate(variable = paste(dev_level, stat, sep = "_")) %>%
  select(-dev_level, -stat, -Rank, -HDI.Value) %>%
  arrange(variable)

dev_level_summary <- t(dev_level_summary1)
colnames(dev_level_summary) <- dev_level_summary["variable",]
dev_level_summary_transposed <- dev_level_summary[, -which(rownames(dev_level_summary) == "variable")]

view(dev_level_summary_transposed)
#-----------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------
#Select the local working directory
proj_directory <- "C:/Users/jadem/OneDrive/Desktop/BABD/Statistics/PersoProject/Statistics_Project"
setwd(proj_directory)
#---
#Load the libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr) #to be able to use gather()
library(magrittr) #so we can use the pipe operator %>%
#---
#Import data from local .csv
col_data <- read.csv("cost-of-living_v2.csv")
#---
#1. Clean the data
col_imputed_country <- col_data
col_imputed_country <- col_imputed_country %>%
  group_by(country) %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) #Group by 'country' and calculate mean for each numeric column

col_imputed_na <- na.omit(col_imputed_country) #drop remaining missing values

data <- select(col_imputed_na, -x28, -x29, -x40, -x43, -x50, -x51, -x52, -x53) #Lastly remove from data the variables highlighted above as missing too many values for analysis.

#---
#2. Group data by country
data_by_country <- data %>%
  group_by(country) %>%
  summarise(
    x1 = mean(x1),
    x2 = mean(x2),
    x3 = mean(x3),
    x4 = mean(x4),
    x5 = mean(x5),
    x6 = mean(x6),
    x7 = mean(x7),
    x8 = mean(x8),
    x9 = mean(x9),
    x10 = mean(x10),
    x11 = mean(x11),
    x12 = mean(x12),
    x13 = mean(x13),
    x14 = mean(x14),
    x15 = mean(x15),
    x16 = mean(x16),
    x17 = mean(x17),
    x18 = mean(x18),
    x19 = mean(x19),
    x20 = mean(x20),
    x21 = mean(x21),
    x22 = mean(x22),
    x23 = mean(x23),
    x24 = mean(x24),
    x25 = mean(x25),
    x26 = mean(x26),
    x27 = mean(x27),
    x30 = mean(x30),
    x31 = mean(x31),
    x32 = mean(x32),
    x33 = mean(x33),
    x34 = mean(x34),
    x35 = mean(x35),
    x36 = mean(x36),
    x37 = mean(x37),
    x38 = mean(x38),
    x39 = mean(x39),
    x41 = mean(x41),
    x42 = mean(x42),
    x44 = mean(x44),
    x45 = mean(x45),
    x46 = mean(x46),
    x47 = mean(x47),
    x48 = mean(x48),
    x49 = mean(x49),
    x54 = mean(x54),
    x55 = mean(x55)
  )
#---
#2.2 Group by category of data and make a new df
headers                <- data_by_country[,1]
meal            <- data_by_country[,2:3]
restaurants <- data_by_country[,4:9]
markets                <- data_by_country[,10:28]
transportation         <- data_by_country[,29:32]
car                   <- data_by_country[,33:34]
utilities              <- data_by_country[,35:37]
sports_and_leisure     <- data_by_country[,38:39]
childcare              <- data_by_country[,40]
clothing_and_shoes     <- data_by_country[,41:44]
rent_per_month         <- data_by_country[,45:46]
salaries_and_financing <- data_by_country[,47:48]

meal_avg         <- round(rowMeans(meal),digits=2)
restaurants_avg            <- round(rowMeans(restaurants), digits=2)
markets_avg                <- round(rowMeans(markets),digits=2)
transportation_avg         <- round(rowMeans(transportation),digits=2)
utilities_avg              <- round(rowMeans(utilities),digits=2)
sports_and_leisure_avg     <- round(rowMeans(sports_and_leisure),digits=2)
childcare_avg              <- round(rowMeans(childcare),digits=2)
clothing_and_shoes_avg     <- round(rowMeans(clothing_and_shoes),digits=2)
rent_per_month_avg         <- round(rowMeans(rent_per_month),digits=2)
salaries_and_financing_avg <- round(rowMeans(salaries_and_financing),digits=2)

basket <- data.frame(
  Country = headers
  ,Restaurants    = restaurants_avg
  ,Markets        = markets_avg
  ,Transports     = transportation_avg
  ,Utilities      = utilities_avg
  ,Entertainment  = sports_and_leisure_avg
  ,Childcare      = childcare_avg
  ,Clothing       = clothing_and_shoes_avg
  ,MonthlyRent    = rent_per_month_avg
  ,Salaries       = salaries_and_financing_avg
)
#---
#3. Group by country development status
HDI_data <- read.csv("HDI.csv")
merged_data <- merge(basket, HDI_data, by = "country", all.x = TRUE)
#---
#4. Divide the ranked data into development level
vhigh_rank <- filter(merged_data, Rank >= 1 & Rank < 66)
high_rank <- filter(merged_data, Rank >= 67 & Rank < 115)
medium_rank <- filter(merged_data, Rank >= 116 & Rank < 159)
low_rank <- filter(merged_data, Rank >= 160 & Rank < 191)
na_rank <- filter(merged_data, Rank == 0)

view(vhigh_rank)
view(high_rank)
view(medium_rank)
view(low_rank)
view(na_rank)
#The split in the different levels of country development follows the UN classification from "very high" to "low". From looking at the four tables we can see that there is not an even country split in the categories.
#---
#5. ANALYSIS using un grouped data
#5.1 Descriptive statistics for each column and development level
# vhigh level of development
vhigh <- vhigh_rank %>%
  summarise(across(where(is.numeric), list(
    Mean = mean,
    Median = median,
    SD = sd,
    Min = min,
    Max = max
  ), .names = "{col}_{fn}"))

# high level of development
high <- high_rank %>%
  summarise(across(where(is.numeric), list(
    Mean = mean,
    Median = median,
    SD = sd,
    Min = min,
    Max = max
  ), .names = "{col}_{fn}"))

# medium level of development
medium <- medium_rank %>%
  summarise(across(where(is.numeric), list(
    Mean = mean,
    Median = median,
    SD = sd,
    Min = min,
    Max = max
  ), .names = "{col}_{fn}"))

# low level of development
low <- low_rank %>%
  summarise(across(where(is.numeric), list(
    Mean = mean,
    Median = median,
    SD = sd,
    Min = min,
    Max = max
  ), .names = "{col}_{fn}"))

combined_summary <- bind_rows(vhigh, high, medium, low) #combine into one data frame for ease of analysis

combined_summary_t <- t(combined_summary)
colnames(combined_summary_t) <- combined_summary_t["dev_level",]
combined_summary_t[, -which(rownames(combined_summary_t) == "dev_level")]

view(combined_summary_t)