#####################
# load libraries
# set wd
# clear global .envir
#####################

# remove objects
rm(list=ls())
# detach all libraries
detachAllPackages <- function() {
  basic.packages <- c("package:stats", "package:graphics", "package:grDevices", "package:utils", "package:datasets", "package:methods", "package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:", search()))==1, TRUE, FALSE)]
  package.list <- setdiff(package.list, basic.packages)
  if (length(package.list)>0)  for (package in package.list) detach(package,  character.only=TRUE)
}
detachAllPackages()

# load libraries
pkgTest <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[,  "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg,  dependencies = TRUE)
  sapply(pkg,  require,  character.only = TRUE)
}

install.packages("stargazer")
library(stargazer)
# here is where you load any necessary packages
# ex: stringr
lapply(c("car"),  pkgTest)
install.packages("car")
library(car)
data("Prestige")
df <- Prestige
help(Prestige)
# set wd for current folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Q1 a
df$professional <- ifelse(df$type == "prof", 1, 0) 
head(df)

#Q1 b
model1 <- lm(prestige ~ income * professional, data = df)
summary(model1)
stargazer(model1, 
          type = "latex",
          title = "Level of prestige based on income, professionals, and their interaction",
          column.labels = "Coefficients",
          covariate.labels = c("income", "professional", "income:professional"),
          dep.var.labels = "prestige")

#Q1 c
#prestige = 21.14 + 0.003(income) + 37.78(professional) - 0.002(income x professional)
# non professional(0): prestige = 21.14 + 0.003(income)
# professional(1): prestige = 58.92 + .001(income)

#Q1 f 
# professional: prestige = 58.92 + .001(1,000)
# approx 1 unit increase rather than .001 

#Q2 a
assigned_coef <- 0.042
assigned_se <- 0.016
adjacent_coef <- 0.042
adjacent_se <- 0.013
n <- 131
k <- 2
degfree <- n - k - 1

t_value_1 <- assigned_coef/assigned_se
#2.625
p_value_1 <- 2 * (1-pt(abs(t_value_1), degfree))
#0.00972002

#Q2 b
t_value_2 <- adjacent_coef/adjacent_se
#3.230769
p_value_2 <- 2 * (1-pt(abs(t_value_2), degfree))
#0.00156946

#Q2 d
R2 <- 0.094
f_stat <- (R2/(k-1)) / ((1- R2)/(n-k))
p_f_test <- pf(f_stat, df1 = k, df2 = n-k-1)
#0.9999947
