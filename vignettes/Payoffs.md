Payoffs
================

# Overview

This document outlines the steps taken to determine input values for the
payoff module.

## Step 1: Estimating annual COPD medication costs

To estimate the annual cost of COPD medications, the following two
components were used:

1.  **Average monthly GoodRx prices**
    - Based on the average price of the most commonly prescribed
      inhalers within each drug class  
    - All prices reflect 2025 USD
2.  **Real-world annual prescription fill frequency**
    - Derived from the following published sources:
      - **Mannino et al., 2022** (DOI: 10.1016/j.rmed.2022.106807)
      - **Bengtson et al., 2018** (DOI: 10.1177/1753466618772750)

#### Dispense frequency per year

**Mannino et al. 2022:**

- ICS + LAMA + LABA: 6.1  
- ICS-containing regimens: 5.3  
- LAMA-containing regimens: 5.2  
- LABA-containing regimens: 5.5

**Bengtson et al. 2018:**

- SABA: 12.0

#### Assumptions for combination therapies

For combination therapies not explicitly categorized, the midpoint of
class dispensing frequencies was used:

- ICS + LABA: 5.4  
- LAMA + LABA: 5.35

Note: The real-world prescription fill data inherently reflects
non-adherence,thus the adherence parameter in EPIC will be set to 1 to
avoid double-adjusting for adherence

| Drug Class | Monthly Cost (USD) | Dispenses/Year | Estimated Annual Cost (USD) |
|:---|---:|---:|---:|
| ICS + LAMA + LABA | 653 | 6.10 | 3,983.3 |
| ICS+LABA | 227 | 5.40 | 1,225.8 |
| LAMA | 334 | 5.20 | 1,736.8 |
| LAMA+LABA | 420 | 5.35 | 2,247.0 |
| SABA | 31 | 12.00 | 372.0 |

Estimated Annual COPD Inhaler Costs by Drug Class

## Step 2: Estimating COPD-related background costs by GOLD stage

COPD-related background costs were estimated using data from Wallace et
al 2019 (DOI: 10.18553/jmcp.2019.25.2.205) Table 3, specifically the row
labeled “COPD-related costs, all patients”. Background costs were
calculated by subtracting the costs of **Inpatient Care**, **Emergency
Room (ER) Visits**, and **Pharmacy** from the **Total COPD-related
Medical Costs** (2016 Costs USD).

| GOLD Stage | Total COPD-related Medical Costs | Inpatient | ER Visits | Pharmacy | Background Cost (USD) |
|:---|---:|---:|---:|---:|---:|
| GOLD I | 5,945 | 3,853 | 186 | 592 | 1,314 |
| GOLD II | 6,978 | 4,449 | 144 | 1,101 | 1,284 |
| GOLD III | 10,751 | 6,277 | 193 | 2,000 | 2,281 |
| GOLD IV | 18,070 | 12,139 | 534 | 2,479 | 2,918 |

COPD-related Background Costs by GOLD Stage

## Step 3: Estimating exacerbation costs by severity

The exacerbation module assigns costs to events based on severity:
**Mild**, **Moderate**, **Severe**, and **Very Severe**. These estimates
were derived from U.S.-based healthcare cost studies and represent
per-event direct medical costs.

The following references were used:

- **Dalal et al. 2011** (DOI: 10.1016/j.rmed.2010.09.003) — 2008 Costs
  USD  
- **Bogart et al. 2020** (DOI: 10.37765/ajmc.2020.43157) — 2017 Costs
  USD

| Exacerbation Severity | Definition | Cost (USD) |
|:---|:---|---:|
| Mild | ED visit (Dalal et al. 2011) | 606 |
| Moderate | No hospitalization (Bogart et al. 2020) | 2,107 |
| Severe | Inpatient hospitalization (Bogart et al. 2020) | 22,729 |
| Very Severe | ICU + intubation (Dalal et al. 2011) | 44,909 |

Per-Event COPD Exacerbation Costs by Severity

## Step 4: Estimating costs for smoking cessation

According to the MMWR study (DOI: 10.15585/mmwr.mm7329a1) the most
commonly used smoking cessation pharmacotherapies among individuals
attempting to quit were as follows:

- **Nicotine patch**: 19.6%  
- **Nicotine gum/lozenge**: 18.4%  
- **Nicotine spray/inhaler**: 1.0%  
- **Varenicline**: 9.6%  
- **Bupropion**: 6.4%

### Reweighted to assume 100% uptake:

- **Nicotine patch**: (19.6 / 55.0) × 100 ≈ 35.6%  
- **Nicotine gum/lozenge**: (18.4 / 55.0) × 100 ≈ 33.5%  
- **Nicotine spray/inhaler**: (1.0 / 55.0) × 100 ≈ 1.8%  
- **Varenicline**: (9.6 / 55.0) × 100 ≈ 17.5%  
- **Bupropion**: (6.4 / 55.0) × 100 ≈ 11.6%

### Estimated 3-month cost of smoking cessation therapy

Cost estimates were derived from GoodRx (2025 Costs USD) for 3 months of
smoking cessation therapy:

- **Nicotine patch**: \$71  
- **Nicotine gum/lozenge**: \$35  
- **Nicotine spray/inhaler**: \$550  
- **Varenicline**: \$402  
- **Bupropion**: \$25

Using the reweighted proportions, the weighted average cost for 3 months
of smoking cessation pharmacotherapy was calculated as:

**Average cost**: \$120.15

| Pharmacotherapy        | Reweighted Proportion (%) | Cost (USD) |
|:-----------------------|:--------------------------|-----------:|
| Nicotine Patch         | 35.6                      |      71.00 |
| Nicotine Gum/Lozenge   | 33.5                      |      35.00 |
| Nicotine Spray/Inhaler | 1.8                       |     550.00 |
| Varenicline            | 17.5                      |     402.00 |
| Bupropion              | 11.6                      |      25.00 |
| Average (weighted)     | –                         |     120.15 |

Smoking Cessation Therapy Use and Cost Estimates

## Step 5: Estimating costs for GP visit and diagnostic spirometry

**GP visits**.  
Medicare pays providers approximately \$89 and \$125 for a 99214 visit
in a typical outpatient setting (Source:
<https://college.acaai.org/wp-content/uploads/2024/07/2025-Proposed-RVUs-and-Reimbursement-for-Allergy.pdf>).
A midpoint of \$107 was used (2025 cost)

**Spirometry**. CMS CPT code 94060 was used which equates to \$41 (2025
Costs USD)
