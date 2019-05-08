# lok_sabha_public
## Analysis of Twitter Data on the 2019 Indian Parliamentary Elections by Hemanth Bharatha Chakravarthy 
_This project aims to investigate scraped twitter data on the ongoing 2019 Indian Lok Sabha Elections and perform sentiment analysis, forecasting, and analysis on bot tweets based on this data._ 

### Note on the Project
#### The App
Link: https://hemanth-bharatha-chakravarthy.shinyapps.io/lok_sabha/

#### 1: Sentiment Analysis
What words were most used? Were they favorable or unfavorable? What were the broad sentiments on the BJP's campaign and how did these sentiments evolve over time? Built using sentiment analysis and text mining.

#### 2: Bots & IT Cells -- Analysis of Fake Tweets
Tracking down bots and stopping their misinformation requires understanding them--this analyses their performance over time in the day. This is built to be interactive.

#### Technical Details
This project is written in R and it's UI is built with R`Shiny` to be interactive and reactive. I use `rtweet` to scrape twitter data (more on `rtweet` here: https://rtweet.info/) and use `syuzhet` to perform sentiment analysis (more on `syuzhet` here: https://www.rdocumentation.org/packages/syuzhet/versions/1.0.4/topics/get_nrc_sentiment). Aside of some geospatial analysis and mapping tools, a large part of the core functionality of this project is built in `dplyr` and `ggplot2`.  

### Note on the Data
#### The #Chowkidar Campaign
The csv file: https://drive.google.com/file/d/1cSUnWV-dQK0XgBfJGkhHJNX_6uc1JDgK/view?usp=sharing
#### What is it?
This data is a mixed sample of the most popular and most recent one hundred and eight thousand tweets made in English from the last three days (as of 20 March, 2019, 10:07 pm EST) on the Bharatiya Janata Party's #MainBhiChowkidar campaign. 


### The Workflow
There is one main file that powers the app: `app.R` in `/lok_sabha/`. (github.com/b-hemanth/lok_sabha_public/lok_sabha/app.R) There are two other R script files in this same folder, namely: `helpers.R` and `static.R`. `helpers.R` contains much of the preprocessing for the app. It reads in the data, cleans it, does a lot of the text-mining, and does some preliminary sentiment analysis. It pushes out some `.Rds` files and dataframes that are then used in `static.R` to produce the static images. These are those plots that do not employ reactive variables and are not interactive on the final interface. Finally, `../lok_sabha/static/` is the folder that contains the static images produced in the R script files. These static images are then rendered in the Shiny App.

Note: __BEFORE RUNNING THE STATIC, you must switch the datafile in helpers.R to include the directory.__
