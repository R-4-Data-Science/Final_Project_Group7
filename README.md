---
title: "```logreg``` Vignette"
author: "Yizhong Zhang"
date: "2023-11-29"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


Package name: ```logreg```

The ```logreg``` package is based on the github repository in the given online address.

Firstly, we need to install the package and library it. The following codes and output would show the package could be installed and library.

```{r install, message=FALSE, warning=FALSE, paged.print=FALSE}
devtools::install_github("R-4-Data-Science/Final_Project_Group7/logreg", force=TRUE)
```

```{r library, message=FALSE, warning=FALSE, paged.print=FALSE}
library(logreg)
```

The package ```logreg``` implements logistic regression using numerical optimization. The functions in this package allow for you to obtain the least squares estimators. This is used as a starting point for optimization, bootstrap confidence intervals for each predictor in the logistic regression, plot the fitted logistic curve to the responses, obtain a confusion matrix on the logistic regression and print metrics calculated from the matrix, and have the ability to plot the given metrics from 0.1 to 0.9. Before using the functions in the package, the data need to be pre-processed such that they are in the suitable formats. Below we show some examples of possible ways of pre-processing the data as well as how to use the main functions of the package.

### Data Pre-Processing

In this section we use data of a csv document that was collected on canvas. The name of the csv document is ```expenses```. In this document, we get the information of 
some persons such as their age and bmi, and their expenses in medical insurance. We have already know there is a strong linear relationship between these variables. Now, we want to know the relationship between the variable ```somker``` and the other all the variables. It is obvious that ```smoker``` is a binary variable. So we could use the logistic regression method to get this fitted model.

First of all, we need deal with data (The working directory is the author's directory, it would be different for different persons). We would show our data first:

```{r data_input}
setwd("C:/Users/张易中/Desktop")
mydata <- read.csv("expenses.csv")
head(mydata)
```

We decide to use the following simple functions to pre-process the data to the suitable formats (numeric matrix and numeric vector). In this process, the predictors matrix X and response vector Y are created. 

Note: The predictors matrix X is just from the data from the csv document. It doesn't contain the column of 1. But in the following function, they would create a new matrix which is the predictor X with the elements of 1 in the first colomn in order to get the intercept ```β_0``` in our fitted model.

```{r data_process}
mydata$sex <- factor(mydata$sex, 
                     levels = c("male","female"), labels = c(1,0))
mydata$smoker <- factor(mydata$smoker, levels = c("yes","no"), labels = c(1,0))
mydata$region_1 <- ifelse(mydata$region=="northeast",1,0)
mydata$region_2 <- ifelse(mydata$region=="northwest",1,0)
mydata$region_3 <- ifelse(mydata$region=="southeast",1,0)
mydata <- mydata[,-6]
head(mydata)
```

We decide to use the data to create our predictors ```X``` and responses ```Y```. The format of ```X``` and ```Y``` are numeric matrix.

```{r data_matrix}
mydata <- as.matrix(mydata)
mydata <- as.numeric(mydata)

mydata <- matrix(mydata, ncol=9)

X <- mydata[, c(1:4,6:9)]
Y <- mydata[, 5]

head(X)
head(Y)
```

The dimension of matrix ```X``` is 1338 $\times$ 8. The variables in matrix ```X``` are ```age```, ```sex```, ```bmi```, ```children```, ```charges```, ```region_northeast```, ```region_northwest``` and ```southeast```. The dimension of vector ```Y``` is 1338 $\times$ 1, The elements in matrix ```Y``` is whether the person is a smoker.

### Initial Estimate Value of β

The function ```init``` gives the starting value for the predictors of the logistic regression. The specific calculation uses the least squares formula given by $(X^TX)^{−1}X^Ty$. The estimated coefficient vector β
 which includes the independent variables plus the intercept. In this example, we get the estimated values of every elements in β and store them in vector ```init_beta_demo```. The first element is the intercept.
 
The input of this function is the predictor matrix and response vector. The row numbers of predictor and response should be equal to the number of our sample size. In this sample, it is 1338. The column number should be equal to the number of predicted variables in our model. In this example, it is 8.

```resp```: The binary response vector.

```pred```: The predictor matrix.

```{r init}
(init_beta_demo <- init(resp = Y, pred= X))
```

Now, we get the estimated vector β by least square method and we would use it to get the optimization of β by logistic regression method. The following functions are all used it as the initial value.

### Bootstrap Confidence Intervals

This function ```Boot_CI``` will conduct a bootstrap routine for each predictor or β value for the logistic regression. The method to get the fitted values of every elements of β is the get the minimum value of loss function given in the canvas. The estimate method of β by loss function is:

$$\hat{\beta }:=\underset{\beta}{argmin}\underset{n}{\sum}\left ( -y_{i}\cdot In(p_{i})-\left ( 1-y_{i} \right )In(1-p_{i}) \right )$$
where:

$$p_{i}:=\frac{1}{1 + exp(-(x_{i})^{T}\beta)}$$

and $y_{i}$ and $x_{i}$ represent the $i^{th}$ observation and row of the response and the predictors respectively. The following functions would all based on this logistic method.

In the function ```Boot_CI```, the user is able to choose the amount of bootstraps ```n``` to conduct as well as the confidence level ```α``` for the intervals.If the users don't choose the value of amounts of bootstraps ```n``` and ```α```, the default value of ```n``` and ```α``` would be 20 and 0.05. 

The inputs of this function are:

```resp```: The binary response vector.

```pred```: The predictor matrix.

```n```: The amount of bootstraps, the default value is 20.

```α```: The confidence interval level, the default value is 0.05.

```{r Boot}
Boot_CI_demo <- Boot_CI(pred= X, resp= Y)
Boot_CI_demo
```

Now, we get a matrix whose dimension is 9 $\times$ 2. The number of rows is 9 because the vector ```β``` has 9 elements, they are from ```β_0``` to ```β_8```. The first column is the lower bound of the confidence interval. The second column is the upper bound of the confidence interval. So this matrix is the 1−α confidence intervals for β.

We can run another example and in this situation we can define the value of ```n``` and ```α```.

```{r Boot_new}
Boot_CI_demo_new <- Boot_CI(pred= X, resp= Y, n =10, alpha = 0.5)
Boot_CI_demo_new
```

Now, we get another matrix which is the confidence interval where ```n```=10 and ```α```=0.5. This is the 0.5 confidence intervals for β with the number of bootstraps is 10.

### Fitted Logistic Curve

This function ```log_plot``` will plot the optimized logistic curve for the given data,  where the y-axis is the binary response y while the x-axis represents a sequence of values from the range of fitted values from the logistic regression. And in the plot, there is also a fitted logistic regression curved line to the responses. The color of the line is green. In this function, we only need to input two data, they are:

```resp```: The binary response vector.

```pred```: The predictor matrix.

Then, we would like to get the plot of our example with a fitted curve line.

```{r plot}
log_plot(pred= X, resp= Y)
```

Now, we get the plot of our example with the fitted curve line.

### Confusion Matrix

This function ```conf_mat``` will create a "confusion matrix" using a cut-off value for prediction at 0.5. It will also print out the ```Prevalence```, ```Accuracy```, ```Sensitivity```, ```Specificity```, ```False Discovery Rate```, and ```Diagnostic Odds Ratio``` metrics when run which can be calculated by values within the matrix. The matrix is 3x3 with values representing the performance of the logistic regression curve that we obtain.

The structure of our confusion matrix is:

|P+N|PP|PN|
|:---:|:---:|:---:|
|P  |TP|FN|
|N  |FP|TN|

The description of the elements in the matrix:

```P+N```: The total population of samples. In this example, the number is 1338.

```P```: The number of the responses whose value are 1.

```N```: The number of the responses whose value are 0.

```PP```: The number of the predicted responses whose values are greater than cut-off value.

```PN```: The number of the predicted responses whose values are smaller than cut-off value.

```TP```: The number of the situations where the responses are 1 and the predicted responses are greater than cut-off value.

```FN```: The number of the situations where the responses are 1 and the predicted responses are smaller than cut-off value.

```FP```: The number of the situations where the responses are 0 and the predicted responses are greater than cut-off value.

```TN```: The number of the situations where the responses are 0 and the predicted responses are smaller than cut-off value.

Based on the elements in the confusion matrix. We would also calculate and print out the certain metrics:```Prevalence```, ```Accuracy```, ```Sensitivity```, ```Specificity```, ```False Discovery Rate```, and ```Diagnostic Odds Ratio```.

The formula to calculate these metrics are:

$$Prevalence = \frac{P}{P+N}$$

$$Accuracy = ACC = \frac{TP+TN}{P+N} = \frac{TP+TN}{TP+TN+FP+FN}$$

$$Sensitivity = TPR =\frac{TP}{P} = \frac{TP}{TP+FN}$$

$$Specificity = TNR = \frac{TN}{N} =\frac{TN}{TN+FP}$$

$$False~Discovery~Rate = FDR = \frac{FP}{FP+TP}$$

$$Diagnostic~Odds~Ratio = DOR = \frac{LR+}{LR-}$$

where

$$LR+ = \frac{TPR}{FPR} = \frac{TP\times(FP+TN)}{(TP+FN)\times FP}$$

$$LR- = \frac{FNR}{TNR} = \frac{FN\times (TN+FP)}{(FN+TP)\times TN}$$

So we also use this example to calculate our confusion matrix and such metrics. The cut-off value is 0.5

```{r conf_mat}
conf_mat(pred = X, resp = Y)
```

So in this situation, we get our confusion matrix and all the required metrics. These matrix and metrics are all based on the cut-off value which is 0.5.

### Plot of Metrics

This function ```plot_metric``` conducts logistic regression on the given data and plots a given metric that visualizes the performance of the regression over a grid of cut-off values for prediction going from 0.1 to 0.9 with steps of 0.1

In this function, we also need input the predictors and responses. They are numeric matrix and numeric vector. We also have a "metric" option and we have six choices. 

```resp```: The binary response vector.

```pred```: The predictor matrix.

```metric```: The metric we want to plot. The choices are: metric = c("Prevalence", "Accuracy", "Sensitivity", "Specificity", "False Discovery Rate", "Diagnostic Odds Ratio")

Now, we could use the ```plot_metric``` function to plot the Prevalence.

```{r Prevalence}
plot_metric(resp=Y, pred=X, metric = "Prevalence")
```

We get this result because Prevalence=P/(P+N), and the values of P and N is the number of the actual responses whose value are 1 and 0. So in these all steps, the responses and predictors are not changed. So the value of Prevalence would be a constant in this plot.

Now, we could use the ```plot_metric``` function to plot the Accuracy.

```{r Accuracy}
plot_metric(resp=Y, pred=X, metric = "Accuracy")
```

In this plot, we could see the Accuracy increases first and then it decreases. When the cut-off value is 0.4, it reaches its maximum value which is about 0.96. Then it decreases and when the cut-off value is 0.7 it reaches its minimum value which is about 0.893. Finally it increases a little.

Now, we could use the ```plot_metric``` function to plot the Sensitivity.

```{r Sensitivity}
plot_metric(resp=Y, pred=X, metric = "Sensitivity")
```

We get this result because in this example, when the cut-off is smaller than 0.3, the value of ```FN``` is 0. And according to the formula: Sensitivity=TP/(TP+FN), when ```FN``` is 0, the value of Sensitivity should be 1. So in this situation, when cut-off value is smaller than 0.3, the Sensitivity is always 1. When the cut-off value is larger than 0.3, the Sensitivity decreases all the time and finally when the cut-off value is 0.9, it gets its minimum value which is about 0.52.

Now, we could use the ```plot_metric``` function to plot the Specificity.

```{r Specificity}
plot_metric(resp=Y, pred=X, metric = "Specificity")
```

According to the plot, we could see the value of Specificity increases all the time and finally when the cut-off value is 0.9, it reaches its maximum value which is about 0.99.

Now, we could use the ```plot_metric``` function to plot the False Discovery Rate.

```{r False_Discovery_Rate}
plot_metric(resp=Y, pred=X, metric = "False_Discovery_Rate")
```

According to the plot, we could see the value of False Discovery Rate nearly decreases all the time. However, when the cut-off value is 0.4, it increases a little, but then it still decreases. When the cut-off value is 0.1, it gets its maximum value which is about 0.23. When the cut-off value is 0.9, it gets its minimum value which is about 0.06.

Now, we could use the ```plot_metric``` function to plot the Diagnostic Odds Ratio.

```{r Diagnostic_Odds_Ratio}
plot_metric(resp=Y, pred=X, metric = "Diagnostic_Odds_Ratio")
```

We get this result because when the cut-off is smaller than 0.3, the value of ```FN``` is 0. And according to the formula: Diagnostic_Odds_Ratio=LR+/LR-, when ```FN``` is 0, the value of Diagnostic_Odds_Ratio should converge to infinite and does not exist. So in this situation, the value of Diagnostic_Odds_Ratio could get its value only when the cut-off value is larger than 0.3. When the cut-off value is larger than 0.3, the value of Diagnostic Odds Ratio decreases first but then increases a little at the point of 0.7. When the cut-off value is 0.7, it gets its minimum value which is about 50.


