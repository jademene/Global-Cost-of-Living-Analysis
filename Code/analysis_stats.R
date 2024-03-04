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
#   4.1 Drop na => simplification of analysis
#   4.2 Group data by categories
#  5. Analysis
#   5.1 Descriptive Statistics for Each Group
#   5.2 Compare Descriptive Statistics for Each Group
# 7. Correlation => not very insightful
# 8. 
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
#merged_data <- merge(data_by_country, HDI_data, by = "country", all.x = TRUE)
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

vhigh <- boxplot(vhigh_rank$Salaries, main = "Boxplot of Salaries in Developed Countries",
        xlab = "Salaries", ylab = "Salaries in USD")
high <- boxplot(high_rank$Salaries, main = "Boxplot of Salaries in High Developing Countries",
                 xlab = "Salaries", ylab = "Salaries in USD")
medium <- boxplot(medium_rank$Salaries, main = "Boxplot of Salaries in Medium Developing Countries",
                xlab = "Salaries", ylab = "Salaries in USD")
low <- boxplot(low_rank$Salaries, main = "Boxplot of Salaries in Low Developing Countries",
                xlab = "Salaries", ylab = "Salaries in USD")

library(patchwork)
vhigh + high + medium + low

# Create an empty plot with appropriate limits
plot(NULL, xlim = c(0.5, 4.5), ylim = range(c(vhigh_rank$Salaries, high_rank$Salaries, medium_rank$Salaries, low_rank$Salaries)),
     main = "Boxplots of Salaries in Different Country Categories", xlab = "Country Categories", ylab = "Salaries in USD")

# Add each boxplot to the plot
boxplot(vhigh_rank$Salaries, add = TRUE, at = 1, col = "red")
boxplot(high_rank$Salaries, add = TRUE, at = 2, col = "blue")
boxplot(medium_rank$Salaries, add = TRUE, at = 3, col = "green")
boxplot(low_rank$Salaries, add = TRUE, at = 4, col = "orange")

# Add legend
legend("topright", legend = c("Developed", "High Developing", "Medium Developing", "Low Developing"),
       fill = c("red", "blue", "green", "orange"))

#The split in the different levels of country development follows the UN classification from "very high" to "low". From looking at the four tables we can see that there is not an even country split in the categories.
#---
#4.1 Drop na
#---
#5. ANALYSIS using un grouped data
#5.1 Descriptive statistics for each column and development level
# vhigh level of development
vhigh <- vhigh_rank %>%
  summarise(across(where(is.numeric), list(
    SD = sd
    #,Median = median,
    #SD = sd,
    #Min = min,
    #Max = max
  ), .names = "{col}_{fn}"))

# high level of development
high <- high_rank %>%
  summarise(across(where(is.numeric), list(
    SD = sd
    #,Median = median,
    #SD = sd,
    #Min = min,
    #Max = max
  ), .names = "{col}_{fn}"))

# medium level of development
medium <- medium_rank %>%
  summarise(across(where(is.numeric), list(
    SD = sd
    #,Median = median,
    #SD = sd,
    #Min = min,
    #Max = max
  ), .names = "{col}_{fn}"))

# low level of development
low <- low_rank %>%
  summarise(across(where(is.numeric), list(
    SD = sd
    #,Median = median,
    #SD = sd,
    #Min = min,
    #Max = max
  ), .names = "{col}_{fn}"))

combined_summary <- bind_rows(vhigh, high, medium, low) #combine into one data frame for ease of analysis

combined_summary_t <- t(combined_summary)

view(combined_summary_t)
#V1 => vhigh
#V2 => high
#V3 => medium
#V4 => low
#---
#5.2 Compare Descriptive Statistics for Each Group
#Mean -> central tendency of the data.
#The mean values vary across the different levels of country development. Overall the cost of living is on average higher in developed countries than developing countries (as expected).
#However this doesn't hold true when looking at the three levels of development (high, medium, low):
#for these the group of countries where a product or service is more expensive isn't always the highest development level ones.
#For example, the cost of a fast food meal is cheaper in high developing countries than in low developing ones. 
#It is also interesting how the price of some goods are high in developed and low developing countries but is cheaper in medium to high developing countries (e.g cappucinos).
#It is also interesting to look at the stark difference in net salaries.
#While low to high development level countries have net salaries that fall within reasonable distance one from the other this is not the case for developed countries.
#These have a mean salary more than 4.5 times larger than the closest high developing countries.Interstingly, low countries have a higher average salary than medium countries.
#-> SD might explain this.

#Median -> less affected by outliers compared to the mean and provides insight into the central tendency of the data. 
#Differences between mean and median can indicate skewness in the distribution.

#Standard Deviation (SD) -> dispersion of the data around the mean. A higher standard deviation = greater variability, lower standard deviation = data points are closer to the mean.
#The data shows that low dev counties show the most variability in price for fresh produce (dairy, meats, fruits and vegetables + alchol).
#SD for drinks purchased in a restaurant is low across all levels of development. 
#NET SALARIES: As suspected, both developed and low development countries have a higher SD than the medium and high dev countries.
#This indicates that in low and very high dev level countries salaries varies greatly among the population.
#---
#7.Correlation - vhigh_rank
vhigh_rank1 <- vhigh_rank[, -1]
correlation_vhigh <- cor(vhigh_rank1)
view(correlation_vhigh)

# Plot heatmap
library(reshape2)
correlation_melted <- melt(correlation_vhigh)
ggplot(correlation_melted, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "#E98768", mid = "white", high = "#582766", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Correlation") +
  labs(x = "Variables", y = "Variables", title = "Correlation Heatmap") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, size = 10, hjust = 1)) +
  coord_fixed() +
  ggtitle("Developed countries (vhigh data)")

#LM of vhigh rank => relationship
Salaries <- vhigh_rank$Salaries
Rank <- vhigh_rank$Rank
modelHIGH <- lm (Rank ~ Salaries)
summary(modelHIGH)
#PLOT relationship
plot(Salaries, Rank, cex=0.95, col="black")
abline(coef(modelHIGH), col ="#E98768", lw=2)
legend("topright",c("Obs.","Reg. line"),col=c("black","#E98768"),
       lwd=c(1,1),lty=c(-1,1),pch=c(c(1,-1)))
title(main="Linear Regression of Rank on Salaries in Developed Countries")
#Residuals: Looking at these values, we see a wide range of residuals, indicating that the model might not perfectly capture all the variation in salaries based on rank.
#Coefficients:
#Rank (x) (-26.879): This is the slope of the fitted line. A negative slope indicates that, on average, salaries decrease as rank increases (higher ranks have lower salaries).
#The small p-values (< 2e-16 and 3.86e-09) indicate that both the intercept and slope are statistically significant at a 0.05 significance level, meaning they are unlikely to be due to chance.
#Other statistics:
#Multiple R-squared (0.4417): This represents the proportion of variance in salaries explained by the model. In this case, it's around 44%, indicating that the model explains a moderate portion of the variation.
#Adjusted R-squared (0.4324): This is a adjusted version of R-squared that accounts for the number of variables in the model. It's slightly lower than R-squared and provides a more accurate estimate of the model's explanatory power when comparing models with different numbers of predictors.
#F-statistic (47.47) and p-value (3.858e-09): The small p-value indicates that the model significantly fits the data better than a model with only the intercept (no relationship between salary and rank).
#Overall, the model suggests a statistically significant negative relationship between salary and rank in the data. However, it's important to consider that the model only explains a moderate portion (44%) of the variability in salaries, and the residuals indicate that there might be other factors not captured by the model influencing salary levels.

#7.1.Correlation - low_rank
low_rank1 <- low_rank[, -1]
correlation_low <- cor(low_rank1)
view(correlation_low)

# Plot heatmap
correlation_melted <- melt(correlation_low)
ggplot(correlation_melted, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "#E98768", mid = "white", high = "#582766",
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Correlation") +
  labs(x = "Variables", y = "Variables", title = "Developing countries (low data)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 10, hjust = 1)) +
  coord_fixed()

#LM of low rank => relationship
Salaries <- low_rank$Salaries
Rank <- low_rank$Rank
modelLOW <- lm (Rank ~ Salaries)
summary(modelLOW)
#PLOT relationship
plot(Salaries, Rank, cex=0.95, col="black")
abline(coef(modelLOW), col ="#E98768", lw=2)
legend("topright",c("Obs.","Reg. line"),col=c("black","#E98768"),
       lwd=c(1,1),lty=c(-1,1),pch=c(c(1,-1)))
title(main="Linear Regression of Rank on Salaries in Low Developing Countries")
#Based on the summary, it appears that the fitted model doesn't provide strong evidence of a statistically significant relationship between "Salaries" and "Rank" in the "low" data frame.
#This could be because there's genuinely no linear relationship between these variables, or other factors might be influencing "Salaries" that are not accounted for in this model.
