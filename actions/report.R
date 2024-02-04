# --------------------------------------------------
library(dplyr)
source('actions/requirements.R')

if ( !file.exists("reports") ) { dir.create("reports") }

# --------------------------------------------------
# Daily report
read_log_arithmetic() %>%
  na.omit() %>%
  group_by(date, day) %>%
  summarise(
    worked_seconds   = sum(worked_seconds),
    balance_daily    = worked_seconds - expected_workday_seconds,
    ) %>%
  mutate(
    balance_cumulative = cumsum(balance_daily),
  ) %>%
  transmute(
    work_hours = sec_to_hm(worked_seconds),
    balance_daily = prepend_plus(sec_to_hm(balance_daily)),
    balance_cumulative = prepend_plus(sec_to_hm(balance_cumulative)),
  ) %>% 
  write.csv2("reports/daily.csv", row.names = FALSE, quote = FALSE)


# --------------------------------------------------
# Weekly report
read_log_arithmetic() %>%
  na.omit() %>%
  group_by(week) %>%
  summarise(
    worked_seconds = sum(worked_seconds)
  ) %>%
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
# Overview of year
daily <- read.csv2("reports/daily.csv") %>%
  mutate(date = as.Date(date))

year <- data.frame(
  date = seq(
    as.Date(paste0(format(Sys.time(), "%Y"), "-01-01")),
    as.Date(paste0(format(Sys.time(), "%Y"), "-12-31")),
    by = "day"
  )
)

year <- full_join(year, daily, by = "date") %>%
  mutate( day = substr(tolower(weekdays(as.Date(date))), 1, 3) )

year %>% openxlsx::write.xlsx(file = "reports/year.xlsx")
