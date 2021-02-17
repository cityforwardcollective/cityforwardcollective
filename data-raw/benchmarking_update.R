library(tidyverse)
library(wisconsink12)
library(broom)
library(caret)
library(usethis)

# Most Recent Year

wi_rc <- make_wi_rc(exclude_milwaukee = FALSE) %>%
  mutate(per_nw = 1 - per_white) %>%
  left_join(., schools %>% select(dpi_true_id, school_year, milwaukee_indicator, lowest_enrolled_grade, highest_enrolled_grade)) %>%
  modify_at(c("lowest_enrolled_grade", "highest_enrolled_grade"), factor, levels = c("PK",
                                                                                     "K3",
                                                                                     "K4",
                                                                                     "KG",
                                                                                     as.character(seq(from = 1, to = 12, by = 1))), ordered = TRUE)

wi_hs <- wi_rc %>%
  filter(school_year == "2018-19") %>%
  mutate(hs = ifelse(lowest_enrolled_grade %in% c("9", "10", "11", "12"), "HS", "Not HS"),
         adjusted_ed = ifelse(report_card_type == "Private - Choice Students",
                              (per_ed * school_enrollment) / (school_enrollment / per_choice),
                              per_ed))

train.control <- trainControl(method = "cv", number = 10)
wi_mod_black_hisp <- train(sch_ach ~ per_ed + per_b_aa + per_hisp_lat + per_swd + grade_band, data = wi_hs %>% filter(school_year == "2018-19" & !is.na(sch_ach)),
                           method = "lm", trControl = train.control)

data <- wi_hs %>%
  filter(school_year == "2018-19" & !is.na(sch_ach))

mod_aug <- augment_columns(x = wi_mod_black_hisp, data = data)

skinny_aug_black <- mod_aug %>%
  mutate(adjusted_ed = ifelse(report_card_type == "Private - Choice Students",
                              (adjusted_ed * school_enrollment) / (school_enrollment / per_choice),
                              adjusted_ed),
         grades = paste(lowest_enrolled_grade, highest_enrolled_grade, sep = "-")) %>%
  select(dpi_true_id, school_name, sch_ach, grades, adjusted_ed, per_ed, per_b_aa, per_hisp_lat, per_swd, .fitted, .resid,
         milwaukee_indicator, adjusted_ed) %>%
  arrange(desc(.resid)) %>%
  mutate(school_rank = row_number())

# Previous Year

wi_hs <- wi_rc %>%
  filter(school_year == "2017-18") %>%
  mutate(hs = ifelse(lowest_grade %in% c("9", "10", "11", "12"), "HS", "Not HS"),
         adjusted_ed = ifelse(report_card_type == "Private - Choice Students" & !is.na(per_choice),
                              (per_ed * school_enrollment) / (school_enrollment / per_choice),
                              per_ed))

wi_mod_black2 <- lm(sch_ach ~ per_ed + per_b_aa + per_hisp_lat + per_swd + grade_band, data = wi_hs %>% filter(!is.na(sch_ach)))

data2 <- wi_hs %>%
  filter(school_year == "2017-18" & !is.na(sch_ach))

mod_aug2 <- augment_columns(x = wi_mod_black2, data = data2)

skinny_aug_black2 <- mod_aug2 %>%
  mutate(adjusted_ed = ifelse(report_card_type == "Private - Choice Students",
                              (adjusted_ed * school_enrollment) / (school_enrollment / per_choice),
                              adjusted_ed),
         grades = paste(lowest_enrolled_grade, highest_enrolled_grade, sep = "-")) %>%
  select(dpi_true_id, school_name, sch_ach, grades, adjusted_ed, per_ed, per_b_aa, per_swd, .fitted, .resid) %>%
  arrange(desc(.resid)) %>%
  mutate(school_rank = row_number()) %>%
  select(dpi_true_id, "last_year" = .resid)


final_w_score <- skinny_aug_black %>%
  left_join(., skinny_aug_black2) %>%

  # if no score last year, imput "average score" of 0
  # i.e. zero residual

  mutate(Score = ifelse(is.na(last_year), .resid * 2 / 3, ((.resid * 2) + last_year) / 3))

fit_avg <- mean(final_w_score$Score, na.rm = TRUE)
fit_sd <- sd(final_w_score$Score, na.rm = TRUE)

final_w_score <- final_w_score %>%
  mutate(sigmas = ifelse(Score < fit_avg - 2 * fit_sd, 1,
                         ifelse(Score < fit_avg - fit_sd, 2,
                                ifelse(Score < fit_avg, 3,
                                       ifelse(Score < fit_avg + fit_sd, 4,
                                              ifelse(Score < fit_avg + 2 * fit_sd, 5, 6)))))) %>%
  arrange(desc(sigmas), desc(Score))

benchmarking_update <- final_w_score %>%
  left_join(., schools %>%
              filter(school_year == "2018-19") %>%
              select(dpi_true_id, school_year, accurate_agency_type, broad_agency_type))

use_data(benchmarking_update, overwrite = TRUE)
