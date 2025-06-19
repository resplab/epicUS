Payoffs
================

# Overview

This document outlines the steps taken to determine input values for the
payoff module.

## Step 1: Estimating annual COPD medication costs

Annual COPD medication costs were estimated using two components:

1.  **Inhaler unit cost by drug class**
    - Prices were obtained from published literature and (DOI:
      10.1513/AnnalsATS.202008-1082RL). Prices of SABA and LAMA were
      estimated from Figure 2A as these prices were not reported in the
      text.
    - It was assumed that one inhaler is used per month per drug class,
      resulting in 12 inhalers annually.  
    - Annual cost per drug class (2018 Costs USD) was calculated as:  
      `Annual Cost = Inhaler Unit Price × 12`
2.  **Real-world dispensing frequency based on proportion of days
    covered (PDC)**
    - PDC estimates were used to adjust the annual inhaler count per
      drug class.  
    - Sources for PDC data include:
      - **Mannino et al., 2022** (DOI: 10.1016/j.rmed.2022.106807)
      - **Slade et al., 2021** (DOI: 10.1186/s12890-021-01612-5)
      - **Bengtson et al., 2018** (DOI: 10.1177/1753466618772750)

#### Dispense frequency per year (adjusted via PDC)

**Mannino et al., 2022:**  
- **ICS + LAMA + LABA**: PDC = 0.66  
→ Estimated number of inhalers per year: `0.66 × 12 = 7.92`

**Slade et al., 2021:**  
- **LAMA + LABA**: PDC = 0.44  
→ Estimated number of inhalers per year: `0.44 × 12 = 5.28`  
- **LAMA**: PDC = 0.37  
→ Estimated number of inhalers per year: `0.37 × 12 = 4.44`

**Bengtson et al., 2018:**  
- **SABA**: The study reported an average of 1 fill per month  
→ Estimated number of inhalers per year: `12`

**Note:** Real-world prescription fill data inherently accounts for
non-adherence. Therefore, the adherence parameter in EPIC will be set to
1 to avoid double-counting non-adherence effects.

| Drug Class | Monthly Cost (USD) | Dispenses/Year | Estimated Annual Cost (USD) |
|:---|---:|---:|---:|
| ICS + LAMA + LABA | 296.11 | 7.92 | 2,345.19 |
| LAMA | 210.00 | 4.44 | 932.40 |
| LAMA+LABA | 218.05 | 5.28 | 1,151.30 |
| SABA | 36.00 | 12.00 | 432.00 |

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

## Step 3: Estimating exacerbation costs by severity

The exacerbation module assigns costs to events based on severity:
**Mild**, **Moderate**, **Severe**, and **Very Severe**. These estimates
were derived from U.S.-based healthcare cost studies and represent
per-event direct medical costs.

The following references were used:

- **Dalal et al. 2011** (DOI: 10.1016/j.rmed.2010.09.003) — 2008 Costs
  USD  
- **Bogart et al. 2020** (DOI: 10.37765/ajmc.2020.43157) — 2017 Costs
  USD

| Exacerbation Severity | Definition | Cost (USD) |
|:---|:---|---:|
| Mild | ED visit (Dalal et al. 2011) | 606 |
| Moderate | No hospitalization (Bogart et al. 2020) | 2,107 |
| Severe | Inpatient hospitalization (Bogart et al. 2020) | 22,729 |
| Very Severe | ICU + intubation (Dalal et al. 2011) | 44,909 |

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

## Step 5: Estimating costs for GP visit and diagnostic spirometry

**GP visits**.  
Medicare pays providers approximately \$89 and \$125 for a 99214 visit
in a typical outpatient setting (Source:
<https://college.acaai.org/wp-content/uploads/2024/07/2025-Proposed-RVUs-and-Reimbursement-for-Allergy.pdf>).
A midpoint of \$107 was used (2025 cost)

**Spirometry**. 
CMS CPT code 94060 was used which equates to \$41 (2025 Costs USD)
