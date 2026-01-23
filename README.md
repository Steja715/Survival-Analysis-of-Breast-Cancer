# 🧬 Survival Analysis: Chemotherapy Efficacy in Breast Cancer
![R](https://img.shields.io/badge/Language-R-blue) ![BioStats](https://img.shields.io/badge/Focus-Biostatistics-green) ![Status](https://img.shields.io/badge/Status-Complete-success)

> **Project Abstract:** This study employs Cox Proportional Hazards models and Kaplan-Meier estimation to evaluate the impact of chemotherapy on patient survival, adjusting for covariates like tumor size, hormone levels, and age.

---

## 📊 1. Multi-Variable Analysis (Forest Plot)
*This visualization summarizes the Hazard Ratios (HR) for all clinical variables included in the model.*

![Forest Plot](Forest_plot.png)

### 🧐 Detailed Interpretation
> **Key Finding:** The Forest Plot reveals that **Age** and **Tumor Grade** are significant predictors of mortality ($p < 0.001$).
> * **Chemotherapy Effect:** The HR for chemotherapy is 0.97 (CI: 0.83 - 1.14), crossing the vertical line of 1.0. This suggests that, in this specific dataset, chemotherapy **did not** show a statistically significant independent survival benefit when controlling for other factors.
> * **Tumor Size:** Larger tumors (>50mm) more than double the risk of death (HR = 2.30) compared to small tumors.

---

## 📉 2. Survival Probability (Kaplan-Meier Curve)
*A temporal view of patient survival probability over 20 months.*

![Kaplan Meier Curve](Kaplan_meier.png)

### 🧐 Detailed Interpretation
> **Clinical Insight:** The survival curves for the Chemotherapy group (Green) and No-Chemotherapy group (Orange) overlap significantly throughout the study period.
> * **Log-Rank Test:** The p-value of **0.43** confirms there is no significant difference in survival rates between the two groups in this sample.
> * **Risk Drop-off:** Both groups show a steeper decline in survival probability within the first 5-10 months.

---

## 🛠 3. Model Diagnostics (Validity Check)
*Ensuring the statistical assumptions of the Cox Model are met.*

![Schoenfeld Test](Schofieldtest_rplot.png)

### 📐 Technical Note
> **Schoenfeld Residuals Test:**
> * The global test ($p < 0.05$) indicates a violation of the **Proportional Hazards assumption**.


---

## 💻 Statistical modelling
| Tool | Purpose |
| :--- | :--- |
| **R Language** | Statistical Computation |
| **Survival / Survminer** | Kaplan-Meier & Cox Modeling |
| **Ggplot2** | High-quality Visualization |
