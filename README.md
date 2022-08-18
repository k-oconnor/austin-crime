
# Abstract

The purpose of this report is to predict whether or not a crime is
cleared by arrest, based on various demographic factors across Austin,
TX. To build our analysis, we utilize data from the Austin Police
Department and the U.S. Census Bureau, which includes information on
reported crimes and demographics by zip code. We employ logistic
regression, stepwise regression, random forest, gradient-boosted tree
models, and lasso to predict crime clearance status. From these models,
we select the gradient-boosted tree model as our best model with a
predictive accuracy greater than 85 percent when validated against
testing data.

# Introduction

Whether in a large city or a small town, crime is an unforunate, yet
ever-present, fact of society. While crime may be a constant reality,
unique social and demographic factors create asymmetry in the way crime
is both committed and penalized in a given city. Such is the case for
Austin, TX. As a large metropolitan area covering several zip codes,
each area of Austin has a unique composition of various social and
demographic factors, which ultimately influence the way crime is
penalized across Austin. While the type of crime committed has a clear
impact on the resulting repercussions, the location in which crime is
committed also seems to influence criminal consequences. It begs the
question of how much our social environment may skew legal decisions
that should, ideally, be objective and just.

The motivation of this study is to build a model that accurately
predicts the outcome of a criminal offense, based on the demographic
factors of a crime’s location. This type of predictive analysis can be
difficult, as no criminal offense is the same as another. Two crimes may
both be classified as “theft”, but one offense may have more clear
evidence of the crime than the other. Therefore, the consequences may
vary based on the specific details of each case. Some cases reside in a
more “gray area” of what the just consequence should be. It is these
cases that may be more susceptible to bias based on the demographics of
their environment, such as income and race. Without the granular detail
of each criminal offense, it can be hard to predict when these external
factors truly have an effect.

However, as more data regarding criminal action becomes publicly
available, it is increasingly important that we build predictive models
to understand the true magnitude of these external factors’ influence on
legal decisions. This paper is organized as follows. In Section 2, we
describe the data used for our analysis and provide some initial
visualizations. In Section 3, we present our statistical models, namely:
Logistic, Stepwise Selection, Random Forest, Gradient Boosting, and
Lasso. In Section 4 , we compare the performance of our models using
confusion matrices and select the best performing model. Finally, we
summarize our results and conclusions in Section 5.


# Data

## Subsetting geojson

The GeoJSON we found has the boundaries of every zipcode in Texas. We
subset this JSON based on the zipcodes included in our dataset.

# Data

## Summary and Description

<table>
<caption>
Figure (1) Data Dictionary
</caption>
<thead>
<tr>
<th style="text-align:left;">
Variable
</th>
<th style="text-align:left;">
Description
</th>
<th style="text-align:left;">
Type
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
clearance\_status
</td>
<td style="text-align:left;">
whether or not crime is cleared by arrest
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
zipcode
</td>
<td style="text-align:left;">
postal zipcode in Austin, TX
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
population\_density
</td>
<td style="text-align:left;">
people per square mile
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
median\_income
</td>
<td style="text-align:left;">
median income of postal zipcode
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
median\_home\_value
</td>
<td style="text-align:left;">
median home value of postal zipcode
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
prop\_white
</td>
<td style="text-align:left;">
proportion of postal zipcode that is white
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
<tr>
<td style="text-align:left;">
arrest\_rate
</td>
<td style="text-align:left;">
proportion of crimes cleared by arrest relative to total crimes
</td>
<td style="text-align:left;">
numeric
</td>
</tr>
</tbody>
</table>

The data used in this analysis is from the Austin Police Department
Crime Reports Data. This dataset only includes incidents during
2014-2015 that the Austin Police Department responded to and wrote a
report. One incident could have several offenses associated with it,
however, only the highest offense is recorded in the dataset. The
dataset includes information about the exact location, zipcode, time,
and particular offense for each incident. Additionally, this dataset
includes information about the clearance status for each recorded
offense. The clearance status defines how or whether a crime was solved
using three categories: Not cleared, Cleared by Exception, and Cleared
by Arrest. For our study, the ‘Cleared by Arrest’ category is our chosen
clearance status of interest. Therefore, we re-coded clearance status as
a binary indicator, where Cleared by Arrest is equal to one, and zero
otherwise. Additionally, we re-coded zipcode as a factor in order to
include each zipcode in our models while also maintaining
interpretability.

In addition to the Austin Police Department data, we used U.S. Census
Bureau data to collect demographic information for each zipcode in the
crime report dataset. Specifically, we gathered information about the
population density, median income, median home value, arrest rate, and
racial composition for each zipcode.

As an additional feature of interest, we create “arrest rate” as a new
feature in the dataset. Arrest rate is the proportion of crimes cleared
by arrest relative to the total number of crimes in each zip code. This
helps us understand which areas in Austin tend to be high arrest areas,
therefore adding predictive power to the likelihood a crime is cleared
by arrest based on its zip code. Also, as this feature is relatively
flat, we decided to z-score the arrest rate, so we can more easily
understand relative differences between different areas.

As a final step to create a data set for modeling, we include latitude
and longitude boundaries for each zip code of interest. This allows us
to visualize group trends in Austin by each zip code, and understand the
asymmetry of demographic factors in the Austin metropolitan. Figure 2
and Figure 3 show median income by zip code and median home value by zip
code, respectively. We can clearly see a correlation between income and
home value, with most high income and high valued homes on the west side
of Austin.

# Data

## Visualizing Zipcodes

![](Austin_Crime_files/figure-markdown_strict/Data%20Cleaning3-1.png)![](Austin_Crime_files/figure-markdown_strict/Data%20Cleaning3-2.png)![](Austin_Crime_files/figure-markdown_strict/Data%20Cleaning3-3.png)![](Austin_Crime_files/figure-markdown_strict/Data%20Cleaning3-4.png)

Figure 4 shows the proportion of the population that is white by zip
code. This plot shows a clear trend of a more white population on the
west side of Austin, and a more minority population on the east side.
When comparing this to Figure 2 and Figure 3, we can see that the west
side of Austin is wealthier and more white, while the east side is less
wealthy and less white. Do these trends correlate with arrest rates?

Figure 5 shows the average arrest rate by zip code. There does not
appear to be a clear trend of certain areas with high or low arrest
rates. However, one northwest zip code experiences a notably high arrest
rate. This particular area of Austin is relatively more white, but of
lower income status. However, this area has an extremely low population
density, and only a few observations of crimes, so we have to understand
that lower density areas with fewer observations may skew results in our
analysis. When ignoring outliers, it would appear that median income may
be one of the more important factors in determining the arrest rate. One
might conclude that community law enforcement budgets are shaped by the
prevailing wealth and taxes collected in those areas.

# Question: Does Race play a part in the prevailing arrest rate?

## A visualization

![](Austin_Crime_files/figure-markdown_strict/Ethnicity%20Effects-1.png)

Of high interest in today’s political landscape is the implications of
ethnicity in justice outcomes. What relationships does ethnicity have in
the prevailing arrest rate in a community? If you are white, is your
police report more likely to lead to an arrest? Figure 6, shows that, at
least in Austin, there does not appear to be a clear trend. To
understand whether or not there are outliers skewing results, the figure
also accounts for population density, measured in people per square
mile. We notice that there are several outliers in low density areas.
There appears to be no readily obvious trend.However, we will run some
models to see if such an assumption can be justified statistically.

# Models

## First Model: Logistic Regression

We started modeling by recoding dependent variable `clearance_status` to
take on the unit value if crime is cleared by arrest and zero otherwise.
Also, we dropped all nulls before creating a train/test split with 80
percent of the data going to the training set, while the remaining 20
percent ending up in the testing set data. In our analysis, we chose to
include population density, median income, median home price, white
population share, and arrest rate as independent variables. The
resulting model is  
 
*P*(*c**l**e**a**r**a**n**c**e* *s**t**a**t**u**s* = 1 ∣ *x*<sub>*i*, *t*</sub>) = *β*<sub>0</sub> + *β*<sub>1</sub>*p**o**p**u**l**a**t**i**o**n* *d**e**n**s**i**t**y*<sub>*i*, *t*</sub> + *β*<sub>2</sub>*m**e**d**i**a**n* *i**n**c**o**m**e*<sub>*i*, *t*</sub> + *β*<sub>3</sub>*m**e**d**i**a**n* *h**o**m**e* *v**a**l**u**e*<sub>*i*, *t*</sub> + *β*<sub>3</sub>*p**r**o**p* *w**h**i**t**e*<sub>*i*, *t*</sub> + *β*<sub>4</sub>*a**r**r**e**s**t* *r**a**t**e*<sub>*i*, *t*</sub>
  
  The results reveal that `arrest rate`, `median home price`, and
`white population share` are highly significant in predicting
`clearance_status`, so they should be included in the model. Then, out
of sample root mean square error (RMSE) is calculated as a measure of
the model’s out of sample performance. RMSE will be used to compare
across all models, and the lower, the better.

Each coefficient shows a ceteris paribus effect of every feature on
clearance status. For instance, $\_{prop : white}=-0.67 means that as
the share of the white population increases by 1 percent, the
probability of crime is cleared by arrest declines by 67 percentage
points, holding all other features constant.

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
RMSE
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Logit
</td>
<td style="text-align:right;">
2.031883
</td>
</tr>
</tbody>
</table>

## Second Model: Stepwise Selection

Although the logistic model is simple, it fails to capture
context-specific effects by ignoring interaction terms. Stepwise
selection computes the best set of variables by including main effects,
and pairwise interaction terms that result in the lowest RMSE. The
resulting model chosen by stepwise selection is  
 
*P*(*c**l**e**a**r**a**n**c**e* *s**t**a**t**u**s* = 1 ∣ *x*<sub>*i*, *t*</sub>) = *β*<sub>0</sub> + *β*<sub>1</sub>*p**o**p**u**l**a**t**i**o**n* *d**e**n**s**i**t**y*<sub>*i*, *t*</sub> + *β*<sub>2</sub>*m**e**d**i**a**n* *i**n**c**o**m**e*<sub>*i*, *t*</sub> + *β*<sub>3</sub>*m**e**d**i**a**n* *h**o**m**e* *v**a**l**u**e*<sub>*i*, *t*</sub> + *β*<sub>3</sub>*p**r**o**p* *w**h**i**t**e*<sub>*i*, *t*</sub> + *β*<sub>4</sub>*a**r**r**e**s**t* *r**a**t**e*<sub>*i*, *t*</sub> + *β*<sub>5</sub>*m**e**d**i**a**n* *h**o**m**e* *v**a**l**u**e* × *a**r**r**e**s**t* *r**a**t**e*
  
 

We notice an interaction term in our model. This term allows the effect
of a unit change in *m**e**d**i**a**n* *h**o**m**e* *v**a**l**u**e* to
depend on *a**r**r**e**s**t* *r**a**t**e*. The coefficient of this
interaction term measures the effect on clearance status of an
additional dollar of median home value is greater, by the amount
*β*<sub>5</sub>, for each additional percentage point increase in arrest
rate.

By including the interaction term, the model performance is enhanced.
RMSE declined from 2.0318 to 2.0254. Other models will be considered in
the following sections with the goal of reducing RMSE further.

    ## Start:  AIC=16842.09
    ## clearance_status ~ population_density + median_income + median_home_value + 
    ##     prop_white + arrest_rate
    ## 
    ##                                        Df Deviance   AIC
    ## + median_home_value:arrest_rate         1    16830 16814
    ## + population_density:median_home_value  1    16847 16831
    ## + median_income:median_home_value       1    16853 16837
    ## + median_income:arrest_rate             1    16854 16838
    ## + population_density:arrest_rate        1    16855 16839
    ## - median_income                         1    16830 16840
    ## <none>                                       16830 16842
    ## + population_density:prop_white         1    16859 16843
    ## + median_home_value:prop_white          1    16860 16843
    ## + prop_white:arrest_rate                1    16860 16844
    ## + population_density:median_income      1    16860 16844
    ## + median_income:prop_white              1    16860 16844
    ## - population_density                    1    16835 16845
    ## - median_home_value                     1    16841 16851
    ## - prop_white                            1    16841 16851
    ## - arrest_rate                           1    17788 17798
    ## 
    ## Step:  AIC=16843.81
    ## clearance_status ~ population_density + median_income + median_home_value + 
    ##     prop_white + arrest_rate + median_home_value:arrest_rate

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
RMSE
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Stepwise Selection
</td>
<td style="text-align:right;">
2.041833
</td>
</tr>
</tbody>
</table>

## Third Model: Random Forest

The next model performed is random forest. The highlight of tree is that
it automatically detect nonlinearities and interactions. So there is no
need to include interaction terms. The process involves resampling the
data with replacement 500 times and fitting a tree to each one. Then,
averaging the predictions of the 500 different trees. However, we can
reduce covariance between each tree by using only a subset of the
variables. Thus, the 500 trees are diversified and their predictions are
less correlated. By introducing more randomness to the process, we can
improve both accuracy and prevent over-fitting. The resulting RMSE is
0.3522 which is a significant improvement from the logistic model or
stepwise selection.

Figure \[figure number here\] presents a variable importance plot. It
shows that excluding zip code would increase mean square error (MSE) by
26 percent, suggesting that zip code should be included in the model.
The process of the calculation involves comparing out-of-bag performance
of the model when using the correct zip code versus permuting the zip
code for all observations.
<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
RMSE
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Random Forest
</td>
<td style="text-align:right;">
0.3522422
</td>
</tr>
</tbody>
</table>

## Fourth Model: Gradient Boosting

Similarly to the random forest model in the previous section, boosting
combines many decision trees where each tree is fitted to the residual
of the previous tree. However, the fit in each round will be scaled down
to constrain it from explaining the full variation in the data. The
resulting estimate is the sum of all crushed trees in each round. The
highlight of the gradient boosting technique is that it keeps each tree
in the ensemble from overfitting just like when random forest restricts
the number of features to prevent overfitting.

Boosting requires choosing three main hyper parameters: (1) Number of
trees: 500, (2) Shrinkage Parameter: 0.01, and (3) Interaction Depth: 4

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
RMSE
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Gradient Boosting
</td>
<td style="text-align:right;">
2.026836
</td>
</tr>
</tbody>
</table>

## Fifth Model: Lasso Model

![](Austin_Crime_files/figure-markdown_strict/Lasso-1.png)

![](Austin_Crime_files/figure-markdown_strict/Lasso2-1.png)


</tbody>
</table>
<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
RMSE
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Lasso
</td>
<td style="text-align:right;">
0.9011662
</td>
</tr>
</tbody>
</table>


## ROC Curve for best model by RMSEout

![](Austin_Crime_files/figure-markdown_strict/Validation_GBM-1.png) \#\#

## ROC Curve for the second best model by RMSEout

![](Austin_Crime_files/figure-markdown_strict/Validation_RF-1.png)

![](Austin_Crime_files/figure-markdown_strict/Variable%20Importance-1.png)

## Sanity-Check: Confusion Matrix for the logit model…

![](Austin_Crime_files/figure-markdown_strict/Sanity-Check%20-%20Logit%20Performance-1.png)
