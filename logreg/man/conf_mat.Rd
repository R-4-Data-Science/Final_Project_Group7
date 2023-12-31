% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conf_mat.R
\name{conf_mat}
\alias{conf_mat}
\title{Confusion Matrix}
\usage{
conf_mat(pred, resp)
}
\arguments{
\item{pred}{A \code{matrix}(numeric) containing variables that will be used to predict the response.}

\item{resp}{A \code{vector}(numeric) containing values that represent a response variable.}
}
\value{
A \code{matrix} that gives the confusion matrix which represents the performance of the logistic regression run in this package.
}
\description{
This function will create a "confusion matrix" using a cut-off value for prediction at 0.5. It will also print the Prevalence, Accuracy, Sensitivity, Specificity, False Discovery Rate, and Diagnostic Odds Ratio metrics when run which can be calculated by values within the matrix.
}
\examples{
mydata <- read.csv("expenses.csv")
mydata$sex <- factor(mydata$sex, levels = c("male","female"), labels = c(0,1))
mydata$smoker <- factor(mydata$smoker, levels = c("yes","no"), labels = c(1,0))
mydata$region_northeast <- ifelse(mydata$region=="northeast",1,0)
mydata$region_northwest <- ifelse(mydata$region=="northwest",1,0)
mydata$region_southeast <- ifelse(mydata$region=="southeast",1,0)
mydata$region_northeast <- ifelse(mydata$region=="northeast",1,0)
mydata$region_northwest <- ifelse(mydata$region=="northwest",1,0)
mydata$region_southeast <- ifelse(mydata$region=="southeast",1,0)
mydata <- mydata[,-6]
mydata <- as.matrix(mydata)
mydata <- as.numeric(mydata)
mydata <- matrix(mydata, ncol=9)
X <- mydata[, c(1:4,6:9)]
Y <- mydata[, 5]
conf_mat(pred = X, resp = Y)
}
\author{
Yizhong Zhang, Alexander Miller
}
