library(epicUS)
library(tidyverse)
library(dplyr)
library(tidyr)
library(testthat)


# test_that("RMSE of population age groups RMSE is within a range ", {


#   USSimulation <- read_csv("../../data-raw/USSimulation.csv")

#   settings <- get_default_settings()
#   settings$record_mode <- 0
#   settings$n_base_agents <- settings$n_base_agents
#   init_session(settings = settings)

#   input <- get_input()
#   time_horizon <- 56
#   input$values$global_parameters$time_horizon <- time_horizon



#   run(input = input$values)
#   output <- Cget_output_ex()
#   terminate_session()


#   epic_popsize_age <- data.frame(year = seq(2015, by = 1, length.out = time_horizon),
#                                  output$n_alive_by_ctime_age)
#   colnames(epic_popsize_age)[2:ncol(epic_popsize_age)] <- 1:(ncol(epic_popsize_age) - 1)
#   epic_popsize_age <- epic_popsize_age[, -(2:40)]
#   epic_popsize_age_long <- epic_popsize_age %>%
#     pivot_longer(!year, names_to = "age", values_to = "EPIC_popsize") %>%
#     mutate(age=as.integer(age))


#   validate_pop_size_scaled <- USSimulation %>%
#     rename(US_popsize = value) %>%
#     left_join(epic_popsize_age_long, by = c("year", "age")) %>%
#     mutate(EPIC_output_scaled = ifelse(year == 2015, US_popsize, NA))


#   total_epic_by_year <- validate_pop_size_scaled %>%
#     group_by(year) %>%
#     summarise(total_EPIC_output = sum(EPIC_popsize, na.rm = TRUE)) %>%
#     arrange(year) %>%
#     mutate(growth_rate = total_EPIC_output / lag(total_EPIC_output))


#   df_with_growth <- validate_pop_size_scaled %>%
#     left_join(total_epic_by_year, by = "year") %>%
#     arrange(year, age) %>%
#     group_by(age) %>%
#     mutate(
#       EPIC_output_scaled = ifelse(year == 2015, US_popsize, NA),
#       EPIC_output_scaled = replace_na(EPIC_output_scaled, first(US_popsize)) *
#         cumprod(replace_na(growth_rate, 1))
#     )


#   df_summed_ranges <- df_with_growth %>%
#     mutate(
#       age_group = case_when(
#         age >= 40 & age <= 59 ~ "40-59",
#         age >= 60 & age <= 79 ~ "60-79",
#         age >= 80 ~ "80+"
#       )
#     ) %>%
#     group_by(year, age_group) %>%
#     summarise(total_EPIC_population = sum(EPIC_output_scaled, na.rm = TRUE),
#               total_US_population = sum(US_popsize, na.rm = TRUE))

#   rmse_per_range <- df_summed_ranges %>%
#     group_by(age_group) %>%
#     summarise(
#       rmse = sqrt(mean((total_EPIC_population - total_US_population)^2, na.rm = TRUE)),
#       .groups = "drop"
#     )


#   # Assert that RMSE for 40-59 is less than 12 million
#   rmse_40_59 <- rmse_per_range$rmse[rmse_per_range$age_group == "40-59"]
#   expect_true(rmse_40_59 < 8 * 10^6, info = paste("RMSE for age group 40-59 is not below 12 million:", rmse_40_59))

#   # Assert that RMSE for 60-79 is less than 22 million
#   rmse_60_79 <- rmse_per_range$rmse[rmse_per_range$age_group == "60-79"]
#   expect_true(rmse_60_79 < 15 * 10^6, info = paste("RMSE for age group 60-79 is not below 22 million:", rmse_60_79))

#   # Assert that RMSE for 80+ is less than 16 million
#   rmse_80_plus <- rmse_per_range$rmse[rmse_per_range$age_group == "80+"]
#   expect_true(rmse_80_plus < 15 * 10^6, info = paste("RMSE for age group 80+ is not below 16 million:", rmse_80_plus))
# })












