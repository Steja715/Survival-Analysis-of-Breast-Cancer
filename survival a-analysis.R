# ==============================================================================
# COMPREHENSIVE SURVIVAL ANALYSIS: ROTTERDAM BREAST CANCER COHORT
# This script covers KM-Estimation, Log-Rank Testing, Cox Regression, and PH Diagnostics
# ==============================================================================

# 1. LOAD LIBRARIES
library(tidyverse)
library(survival)
library(survminer)

# 2. DATA PREPARATION
df <- survival::rotterdam

# We use Overall Survival (OS) as the primary endpoint
# Time = dtime (days), Event = death (1=event, 0=censored)
df <- df %>%
  mutate(
    status = death,
    os_years = dtime / 365.25,
    chemo = factor(chemo, labels = c("No Chemo", "Chemo")),
    hormon = factor(hormon, labels = c("No Hormonal", "Hormonal")),
    grade = factor(grade)
  )

# Create the Survival Object (The foundation of all survival analysis)
surv_obj <- Surv(time = df$os_years, event = df$status)

# ------------------------------------------------------------------------------
# 3. NON-PARAMETRIC ANALYSIS: KAPLAN-MEIER ESTIMATION
# ------------------------------------------------------------------------------

# A. Overall Survival (Pooled)
fit_total <- survfit(surv_obj ~ 1, data = df)

# B. Survival Probability at Specific Time Points (e.g., 5-year and 10-year OS)
summary(fit_total, times = c(5, 10))

# C. Kaplan-Meier Curve by Chemotherapy Status
fit_chemo <- survfit(surv_obj ~ chemo, data = df)

# This will display the graph in your RStudio Plots window
km_plot <- ggsurvplot(
  fit_chemo, data = df,
  pval = TRUE,             # Log-Rank Test result
  conf.int = TRUE,         # Confidence intervals
  risk.table = TRUE,       # Number at risk table
  surv.median.line = "hv", # Shows median survival time
  legend.labs = c("No Chemo", "Chemo"),
  palette = c("#E69F00", "#56B4E9"),
  title = "Kaplan-Meier Estimates for Overall Survival",
  ggtheme = theme_bw()
)
print(km_plot)

# ------------------------------------------------------------------------------
# 4. SEMI-PARAMETRIC ANALYSIS: COX PROPORTIONAL HAZARDS MODEL
# ------------------------------------------------------------------------------

# Multivariate Cox model adjusting for all clinical factors
cox_model <- coxph(surv_obj ~ chemo + hormon + size + nodes + grade + age + er + pgr, data = df)

# Display Hazard Ratios and Significance
summary(cox_model)

# Visualize HR with a Forest Plot
forest_p <- ggforest(cox_model, data = df, main = "Hazard Ratios (95% CI)")
print(forest_p)

# ------------------------------------------------------------------------------
# 5. MODEL DIAGNOSTICS: TESTING THE PH ASSUMPTION
# ------------------------------------------------------------------------------

# The Schoenfeld Residual Test
# This checks if the Hazard Ratio stays constant over time (The "PH Assumption")
ph_test <- survival::cox.zph(cox_model)
print(ph_test) # If Global p < 0.05, the assumption is violated

# Plotting the Schoenfeld Residuals
# Look for a flat line around 0 to confirm the assumption holds
resid_plot <- ggcoxzph(ph_test)
print(resid_plot)

# ------------------------------------------------------------------------------
# 6. EXPORTING RESULTS FOR GITHUB PORTFOLIO
# ------------------------------------------------------------------------------

# Save Kaplan-Meier Plot
png("Kaplan_Meier_Curve.png", width = 900, height = 700, res = 120)
print(km_plot)
dev.off()

# Save Forest Plot
png("Forest_Plot_Hazard_Ratios.png", width = 1000, height = 800, res = 120)
print(forest_p)
dev.off()

# Save Schoenfeld Diagnostic Plot
png("Schoenfeld_Residuals.png", width = 900, height = 900, res = 120)
print(resid_plot)
dev.off()

cat("\n--- Analysis Complete. 3 Professional Graphs Saved to Directory ---")