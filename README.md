# 🧬 Survival Analysis: Evaluating Chemotherapy and Hormonal Therapy Efficacy in Breast Cancer
![R](https://img.shields.io/badge/Language-R-blue) ![Biostatistics](https://img.shields.io/badge/Field-Biostatistics-green) ![Status](https://img.shields.io/badge/Project-Complete-success)

## 📋 Project Summary
This research investigates the complex interplay between adjuvant systemic therapies—**Chemotherapy** and **Hormonal Therapy**—and long-term patient outcomes in a cohort of 2,982 breast cancer patients. While the primary focus is treatment efficacy, the study utilizes a multivariate framework to adjust for critical prognostic indicators including tumor size, lymph node involvement, and hormonal receptor status.

---

## 📉 1. Non-Parametric Survival Analysis (Kaplan-Meier)
The study first employed the Kaplan-Meier estimator to visualize the survival function $S(t)$, defined as the probability that a patient survives longer than time $t$.



![Kaplan Meier Curve](Kaplan_Meier_Curve.png)

### 🔍 Deep Dive Interpretation
* **Univariate Comparison ($p = 0.48$):** The Log-Rank test identifies no statistically significant survival difference between the treatment arms (Chemo vs. No Chemo) at this level.
* **Median Survival Estimation:** The median survival time—the point where 50% of the population remains alive—is approximately **11.1 years**, as indicated by the dashed vertical and horizontal lines.
* **Censoring Considerations:** The "Number at Risk" table highlights that as follow-up extends beyond 15 years, the sample size diminishes significantly (from 2,982 to 43), leading to wider 95% Confidence Intervals (CI) and increased sensitivity to late-stage events.

---

## 📊 2. Semi-Parametric Modeling (Cox Proportional Hazards)
To account for confounding and selection bias, a multivariate Cox PH model was constructed to estimate the **Hazard Ratio (HR)**, representing the instantaneous risk of death for one group relative to a reference group.



![Forest Plot](Forest_Plot_Hazard_Ratios.png)

### 🔍 Clinical & Statistical Insights
* **The Treatment Paradox:** * **Chemotherapy:** $HR = 1.04$ ($p = 0.615$).
    * **Hormonal Therapy:** $HR = 0.94$ ($p = 0.497$).
    * *Interpretation:* These results suggest **"Confounding by Indication."** In this dataset, high-risk patients were more likely to receive adjuvant therapy. The near-null HR indicates that these therapies effectively mitigated that higher baseline risk, bringing their survival probability in line with lower-risk patients who did not receive treatment.
* **Morphological Determinants:** * **Tumor Size:** Tumors $>50\text{mm}$ exhibit a **126% increase in the hazard of death** ($HR = 2.26, p < 0.001$) compared to the $\leq 20\text{mm}$ reference group.
    * **Lymph Nodes:** Every additional positive node is associated with a **8% increase in risk** ($HR = 1.08, p < 0.001$), emphasizing its role as a key prognostic biomarker.
* **Model Performance:** The model achieved a **Concordance Index (C-index) of 0.69**, indicating a strong ability to correctly rank the survival times of patient pairs based on their risk scores.

---

## 🛠 3. Advanced Diagnostics (Schoenfeld Residuals)
A critical component of this analysis was the validation of the **Proportional Hazards (PH) assumption**, which assumes that the effect of a covariate (HR) remains constant over time.



![Schoenfeld Test](Schoenfeld_Residuals.png)

### 🔍 Statistical Validation
* **Global Test Violation ($p < 0.001$):** The Schoenfeld test reveals a systemic violation of the PH assumption with a Global p-value of $5.121 \times 10^{-16}$.
* **Variable-Specific Drift:** Residual plots for variables like **age** and **nodes** show non-zero slopes, suggesting that their impact on the hazard of death is dynamic rather than static over the 20-year follow-up.
* **Technical Conclusion:** This diagnostic step signals that while the current model provides a robust average hazard, advanced modeling involving **stratified models** or **time-varying coefficients** would be the next step to capture the longitudinal risk profile.

---

## 💻 Tech Stack & Methodology
* **Implementation:** Developed in R, utilizing the `survival` and `survminer` ecosystems.
* **Dataset:** Rotterdam primary breast cancer cohort (n=2,982).
* **Methodology:** KM estimation for discovery; Cox PH for inference; Schoenfeld residuals for validation.
