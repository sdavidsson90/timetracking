# --------------------------------------------------
library(dplyr)
source('actions/requirements.R')
if ( !file.exists("reports") ) { dir.create("reports") }

# --------------------------------------------------
# -- Daily
read_log_arithmetic() %>%
  group_by(date, day) %>%
  summarise(
    worked_seconds = sum(worked_seconds),
    ) %>%
  ungroup() %>%
  mutate(
    expected_workday_seconds = ifelse(day == "sat" | day == "sun", 0, ((37 * 60 * 60) / 5)),
    balance_daily = worked_seconds - expected_workday_seconds,
    balance_cumulative = cumsum(balance_daily)
  ) %>%
  transmute(
    date,
    day,
    work_hours = sec_to_hm(worked_seconds),
    balance_daily = prepend_plus(sec_to_hm(balance_daily)),
    balance_cumulative = prepend_plus(sec_to_hm(balance_cumulative)),
  ) %>%
  write.csv2("reports/daily.csv", row.names = FALSE, quote = FALSE)

# --------------------------------------------------
# -- Weekly
read_log_arithmetic() %>%
  group_by(week) %>%
  summarise(
    worked_seconds = sum(worked_seconds)
  ) %>%
  ungroup() %>%
  mutate(
    work_week_seconds   = 37 * 60 * 60,
    balance             = worked_seconds - work_week_seconds,
    balance_cummulative = cumsum(balance),
  ) %>%
  transmute(
    week,
    worked_hours = sec_to_hm(worked_seconds),
    balance      = prepend_plus(sec_to_hm(balance)),
    balance_cummulative = prepend_plus(sec_to_hm(balance_cummulative)),
  ) %>%
  write.csv2("reports/weekly.csv", row.names = FALSE, quote = FALSE)

# --------------------------------------------------
# -- Yearly
daily <- read.csv2("reports/daily.csv") %>% mutate(date = as.Date(date))

start_of_year <- as.Date(paste0(format(Sys.time(), "%Y"), "-01-01"))
end_of_year   <- as.Date(paste0(format(Sys.time(), "%Y"), "-12-31"))

data.frame(date = seq(start_of_year, end_of_year, by = "day")) %>%
  full_join(daily, by = "date") %>%
  mutate(day = substr(tolower(weekdays(as.Date(date))), 1, 3)) %>%
  openxlsx::write.xlsx(file = "reports/yearly.xlsx")
