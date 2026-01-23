# Survival analysis on cancer data from survival package in R


# Loading relevant directories


library(tidyverse)  #includes ggplot for data visualisation, dplyr for data manipulation
library(survival)
library(ggsurvfit)
library(survminer)

df <- survival::rotterdam   #dataset from survival package in R regarding Breast cancer data
head(df)
colnames(df)

#key columns for survival analysis
# 1. Cennsoring status: 1 = event happened, 0 = censored (or TRUE or FALSE)

unique(df$death)
df <- df %>% mutate(status = death)
head(df)

table(df$status)

# 2. Time to event (we can use either rtime or dtime)

df$rtime %>% head()

df <- df %>% mutate(rtime_yrs = rtime/365.25)   #converting the relapse time in years 
head(df)

# Create Survival Object

surv_obj <- Surv(time = df$rtime_yrs, event = df$status)
head(surv_obj)
s1 <- survfit(surv_obj~1, data = df)
# Create a survival curve
summary(s1)

# Kaplan Meier plots
km_curve <- ggsurvfit(s1, linewidth = 1) + labs(x= 'Years', y = 'Overall survival') + add_confidence_interval() + add_risktable() + scale_ggsurvfit() + coord_cartesian(xlim= c(0,8))



# Estimating X- year survival
# What is the probability of surviving beyond a certain number of years,x?

summary(s1, times = c(0, 0.5, 2, 5))$surv

km_curve + 
  geom_vline(xintercept = 5, linetype = 'dashed', colour = 'red', size =1) +
  geom_hline(yintercept = summary(s1, times = 5)$surv, linetype = 'dashed', colour = 'red', size =1)


# Estimating median survival time

s1

# log rank test

table(df$chemo)


s2 <- survfit(surv_obj ~ chemo, data = df)
ggsurvplot(s2, data = df,
           size = 1,
           palette = c('orange','green'),
           censor.shape = '|', censor.size =4, 
           conf.int = TRUE,
           pval = TRUE,
           risk.table = TRUE,
           risk.table.col = 'strata',
           legend.labs = list('0'='no chemo', '1'= 'chemo'),
           risk.table.height = 0.25,
           ggtheme = theme_bw())


# Now we can compute the test of the difference between survival curves using log ranks
# Comparing survival rtimes between groups aka log rank test

logrankres_chemo <- survdiff(Surv(rtime_yrs, status) ~ chemo, data = df)
logrankres_chemo


# Analysis of hormonal treatment

logrankres_hor <- survdiff(Surv(rtime_yrs, status) ~ hormon, data = df)
logrankres_hor


# Cox regression model
# Fitting of the model

cox_res <- coxph(Surv(rtime_yrs, status) ~ hormon + chemo + size + er + pgr + nodes + grade + age, data = df)
cox_res



# Get a summary of the model 
summary(cox_res)

# Cox model assumes that the HR between any two groups remains constant

test <- survival::cox.zph(cox_res)
test


# Plot the Schoenfeld residuals over time for each covariate

survminer::ggcoxzph(test, point.size = 0.1)  # if residuals are scattered around 0 with no pattern this suggests that proportional hazard assumptions is reasonable.



# forest plots 
# Visualise cox model results

ggforest(cox_res, data =df)




