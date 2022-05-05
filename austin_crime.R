library(tidyverse)

austin_crime <- read_csv("https://raw.githubusercontent.com/johnsonabigail/austin-crime/main/austin_crime.csv")
austin_crime_zips <- read_csv("https://raw.githubusercontent.com/johnsonabigail/austin-crime/main/austin_crime_zips.csv")

#merge the two datasets
austin_table <- merge(austin_crime, austin_crime_zips, by = "zipcode") %>%
    drop_na 

#check class
lapply(austin_table, class)
austin_table$council_district_code <- austin_table$council_district_code %>% 
    factor()
    
# Game Plan: hand-built linear model, lasso, random forest, gradient boosting, CART
#before running lasso need to standardize
#measure performance using AIC or CV(min deviance or 1SE)

set.seed(1)
austin_split <- initial_split(austin_table, 0.8)
austin_train <- training(austin_split)
austin_test <- testing(austin_split)

#CART
trctrl <- trainControl(method = "cv", number = 5, savePredictions=TRUE)
austin_tree1 <- train(total_cases ~., data = dengue_train, method = "rpart", trControl=trctrl, 
                     tuneLength = 1, control = rpart.control(cp = 0.002, minsplit=30))
