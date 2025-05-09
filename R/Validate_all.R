library(tidyverse)
library(epicUS)
library(ggthemes)
library(scales)
library(ggplot2)
library(dplyr)
library(tidyr)

# Load US population validation targets
USSimulation <- read_csv("data-raw/USSimulation.csv")
USlifetables <- read_csv("data-raw/USLifeTables.csv", col_names = FALSE) %>% mutate(across(everything(), as.numeric))

# Load EPIC and configure settings
settings <- get_default_settings()
settings$record_mode <- 0
settings$n_base_agents <- 1e6
init_session(settings = settings)

input <- get_input()
time_horizon <- 26
input$values$global_parameters$time_horizon <- time_horizon
input$values$agent$p_bgd_by_sex <- as.matrix(USlifetables)

# Set growth rate calibration
input$values$agent$l_inc_betas <- c(-3.5,0.002,0.00001)

#smoking status
input$values$smoking$logit_p_never_smoker_con_not_current_0_betas<-t(as.matrix(c(intercept = 4.85, sex = 0, age = -0.06, age2 = 0,
                                                                                 sex_age = 0,sex_age2 = 0, year = -0.02)))

#COPD prevalence
input$values$COPD$logit_p_COPD_betas_by_sex <- cbind(male = c(intercept = -4.15189, age = 0.033070   , age2 = 0, pack_years = 0.025049   ,
                                                       current_smoking = 0, year = 0, asthma = 0),
                                              female = c(intercept = -4.28486, age = 0.027359   , age2 = 0, pack_years = 0.030399   ,
                                                         current_smoking = 0, year = 0, asthma = 0))

#COPD exacberbations
input$values$exacerbation$ln_rate_betas <- t(as.matrix(c(intercept = 0.9, female = 0, age = 0.04082 * 0.1, fev1 = -1.5, smoking_status = 0.7, gold1 = 0.3 , gold2 = -0.3 , gold3 = 0.08 , gold4 = -0.35 , diagnosis_effect = 0)))

input$values$exacerbation$logit_severity_betas = t(as.matrix(c(intercept1 = -3.609, intercept2 = 2.002, intercept3 = 4.408, female = -0.764,
                                                        age = -0.007, fev1 = 0.98, smoking_status = 0.348, pack_years = -0.001 , BMI = 0.018)))

#Adherence to medication
input$values$medication$medication_adherence <- 0.5

#COPD medication cost
input$values$medication$medication_costs <- c(None=0,SABA=133.8*input$values$medication$medication_adherence, LABA=0, SABA_LABA=0,
                                      LAMA=3050.4*input$values$medication$medication_adherence, LAMA_SABA=0,
                                      LAMA_LABA=5150.4*input$values$medication$medication_adherence, LAMA_LAMA_SABA=0,
                                      ICS=0, ICS_SABA=0, ICS_LABA=0, ICS_LABA_SABA=0, ICS_LAMA=0, ICS_LAMA_SABA=0,
                                      ICS_LAMA_LABA=7913.6*input$values$medication$medication_adherence, ICS_LAMA_LABA_SABA=0)

#Background cost
input$values$cost$bg_cost_by_stage=t(as.matrix(c(N=0, I=1738.28*1.0528, II=1698.59*1.0528, III=3017.52*1.0528, IV=3860.2*1.0528)))

#Exacerbation cost
input$values$cost$exac_dcost=t(as.matrix(c(mild=59.71*1.0528,moderate=942.23*1.0528,severe=10546.6*1.0528, verysevere=30228.64*1.0528)))

# Run EPIC simulation
run(input = input$values)
output <- Cget_output_ex()
terminate_session()

#smoking status
smokingstatus<- output$n_smoking_status_by_ctime

# Calculate row-wise sums
row_sums <- rowSums(output$n_smoking_status_by_ctime)

# Convert each cell to proportion of row total
output$n_smoking_status_by_ctime_proportion <- output$n_smoking_status_by_ctime / row_sums

# create dataframe
output$n_smoking_status_by_ctime_proportion <- as.data.frame(output$n_smoking_status_by_ctime_proportion)

# Add a Year column
output$n_smoking_status_by_ctime_proportion$Year <- 2015:2040

# Reshape data
smokingstatus <- pivot_longer(output$n_smoking_status_by_ctime_proportion,
                        cols = c("V1", "V2", "V3"),
                        names_to = "Status",
                        values_to = "Proportion")

smokingstatus$Status <- recode(smokingstatus$Status,
                               V1 = "Never Smoker",
                               V2 = "Current Smoker",
                               V3 = "Former Smoker"
)

poster_colors <- c(
  "Never Smoker" = "#003f5c",      # deep navy
  "Current Smoker" = "#ffa600",    # coral orange
  "Former Smoker" = "#66c2ff"      # light blue
)

#label
ggplot(smokingstatus, aes(x = Year, y = Proportion, color = Status)) +
  geom_line(linewidth = 1.5) +
  geom_point(size = 3) +
  scale_color_manual(values = poster_colors) +
  scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1)) +
  scale_x_continuous(breaks = c(seq(2015, 2040, by = 5))) +
  labs(
    title = "Smoking Status Trends Over Time",
    subtitle = "Smoking status from 2015-2040",
    x = "Year",
    y = "Proportion of Population",
    color = "Smoking Status",
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    axis.line = element_line(color = "black", linewidth = 0.8),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 12, margin = margin(b = 4)),
    legend.key.height = unit(1.2, "lines")
  )

# COPD prevalence

COPDprevalence_ctime_age<-output$n_COPD_by_ctime_age
COPDprevalence_ctime_age<-as.data.frame(output$n_COPD_by_ctime_age)
totalpopulation<-output$n_alive_by_ctime_age

#Prevalence by age 40-59 dataframe
alive_age_40to59 <- rowSums(output$n_alive_by_ctime_age[1:26, 40:59])
COPD_age_40to59 <-rowSums(output$n_COPD_by_ctime_age[1:26, 40:59])
prevalenceCOPD_age_40to59 <- COPD_age_40to59 / alive_age_40to59
print(prevalenceCOPD_age_40to59)

# Plot prevalence 40-59
plot_prevalence_40to59<- data.frame(
  Year = 2015:2040,
  Prevalence = prevalenceCOPD_age_40to59
)

ggplot(plot_prevalence_40to59, aes(x = Year, y = Prevalence)) +
  geom_line(linewidth = 1.5, color = "#003f5c") +           # Deep navy
  geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +   # Light blue
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1),
    limits = c(0, 0.10),
    breaks = seq(0, 0.10, by = 0.01)
  ) +
  scale_x_continuous(breaks = seq(2015, 2040, by = 5)) +
  labs(
    title = "COPD Prevalence Over Time (Age 40–59)",
    subtitle = "Estimated proportion of population with COPD (2016–2040)",
    x = "Year",
    y = "Prevalence (%)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    axis.line = element_line(color = "black", linewidth = 0.8),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

#Prevalence by age 60-79

alive_age_60to79 <- rowSums(output$n_alive_by_ctime_age[1:25, 60:79])
COPD_age_60to79 <-rowSums(output$n_COPD_by_ctime_age[1:25, 60:79])
prevalenceCOPD_age_60to79 <- COPD_age_60to79 / alive_age_60to79
print(prevalenceCOPD_age_60to79)

# Plot prevalence 60-79
plot_prevalence_60to79<- data.frame(
  Year = 1:25,
  Prevalence = prevalenceCOPD_age_60to79
)

ggplot(plot_prevalence_60to79, aes(x = Year, y = Prevalence)) +
  geom_line(size = 1.2, color = "blue") +
  geom_point(size = 2, color = "darkblue") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "COPD Prevalence Over Time (Age 60-79)",
    x = "Year",
    y = "Prevalence (%)"
  ) +
  theme_minimal()

#Prevalence by age 80+

alive_age_over80 <- rowSums(output$n_alive_by_ctime_age[1:25, 80:111])
COPD_age_over80  <-rowSums(output$n_COPD_by_ctime_age[1:25, 80:111])
prevalenceCOPD_age_over80  <- COPD_age_over80  / alive_age_over80
print(prevalenceCOPD_age_over80)

# Plot prevalence 80+
plot_prevalence_over80 <- data.frame(
  Year = 1:25,
  Prevalence = prevalenceCOPD_age_over80
)

ggplot(plot_prevalence_over80, aes(x = Year, y = Prevalence)) +
  geom_line(size = 1.2, color = "blue") +
  geom_point(size = 2, color = "darkblue") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "COPD Prevalence Over Time (Age 80+)",
    x = "Year",
    y = "Prevalence (%)"
  ) +
  theme_minimal()

# Check for gender distribution to match Tilert et al 2013 (doi:10.1186/1465-9921-14-103)

alive_sex <- output$n_alive_by_ctime_sex
COPD_sex <- output$n_COPD_by_ctime_sex
prevalenceCOPD_sex <- COPD_sex / alive_sex
prevalenceCOPD_sex<-as.data.frame (prevalenceCOPD_sex)

# Check for exacerbations

## Calculate number of exacerbations
exacerbations<-output$n_exac_by_ctime_severity
colnames(exacerbations) <- c("Mild", "Moderate", "Severe", "Very Severe")

## Calculate number of individuals alive in population with COPD
alive_COPD<- output$n_COPD_by_ctime_sex # do this because there is no output for n_alive only
alive_COPD<- rowSums(output$n_COPD_by_ctime_sex[1:25, 1:2])

## Calculate proportion of excerbations within COPD patients
exacerbation_proportion <- exacerbations[, c("Mild", "Moderate", "Severe", "Very Severe")]/ as.vector(alive_COPD)

## Calcuate/change to percentage of exacerbations within COPD patients
exacerbation_percent <- exacerbation_proportion
exacerbation_percent[, c("Mild", "Moderate", "Severe", "Very Severe")] <-
  exacerbation_percent[, c("Mild", "Moderate", "Severe", "Very Severe")] * 100

## Calculate number of exacerbations by GOLD stage
exacerbations_GOLD<-output$n_exac_by_ctime_GOLD
COPD_prevalence_GOLD<- output$n_COPD_by_ctime_severity

COPD_prevalence_GOLD<- COPD_prevalence_GOLD[, -1]
colnames(exacerbations_GOLD)<- c("GOLD 1", "GOLD 2", "GOLD 3", "GOLD 4")
exacerbation_proportion_GOLD <- exacerbations_GOLD[, c("GOLD 1", "GOLD 2", "GOLD 3", "GOLD 4")] / as.vector(COPD_prevalence_GOLD)

# Exacerbations in patients without COPD
alive<- output$n_alive_by_ctime_sex # do this because there is no output for n_alive only
alive<- rowSums(output$n_alive_by_ctime_sex[1:25, 1:2])

## Calculate proportion of excerbations for general population patients
exacerbation_proportion_general <- exacerbations[, c("Mild", "Moderate", "Severe", "Very Severe")] / as.vector(alive)
exacerbation_rate_per100k<- exacerbation_proportion_general * 100000
exacerbation_rate_hosp_per100k <- exacerbation_rate_per100k[, "Severe"]
exacerbation_rate_hosp_per100k<-as.data.frame(exacerbation_rate_hosp_per100k)

# Rename the column
colnames(exacerbation_rate_hosp_per100k)[1] <- "Hospitalizations"
exacerbation_rate_hosp_per100k$Year <- 2015:2040

# Reorder columns so Year comes first
exacerbation_rate_hosp_per100k <- exacerbation_rate_hosp_per100k[, c("Year", "Hospitalizations")]



## plot data

library(ggplot2)

ggplot(exacerbation_rate_hosp_per100k, aes(x = Year, y = Hospitalizations)) +
  geom_line(linewidth = 1.2, color = "darkorange") +
  geom_point(size = 2, color = "black") +
  labs(
    title = "COPD Hospitalization Rate",
    x = "Year",
    y = "Rate per 100,000 persons"
  ) +
  theme_minimal()


library(ggplot2)

ggplot(exacerbation_rate_hosp_per100k, aes(x = Year, y = Hospitalizations)) +
  geom_line(linewidth = 1.5, color = "#003f5c") +  # Deep navy blue line
  geom_point(size = 3, color = "#66c2ff", stroke = 0.8) +  # Light blue points
  labs(
    title = "Annual COPD Hospitalization Rate",
    subtitle = "Rates per 100,000 persons from 2015-2040",
    x = "Year",
    y = "Rate per 100,000 persons",
  ) +
  scale_x_continuous(breaks = c(seq(2015, 2040, by = 5))) +
  scale_y_continuous(
    limits = c(0, 1000),
    breaks = seq(0, 1000, by = 100)
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black", linewidth = 0.8)
  )
