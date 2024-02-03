# --
pacman::p_load(dplyr)

source('actions/requirements.R')

if( !is.na(read.csv2('log.csv')[1, 'checkout']) ) {
  create_report_files()
}

# -- 
# Transform to prepare for arithmetic operations
log_arithmetic <- read_log() %>%
  transmute(
    checkin  = as.POSIXct(checkin,  format = "%Y-%m-%d %H:%M"),
    checkout = as.POSIXct(checkout, format = "%Y-%m-%d %H:%M"),
    week     = as.numeric(format(checkin, "%W")),
    date     = format(checkin, format = "%Y-%m-%d"),
    worked_seconds = as.numeric(checkout) - as.numeric(checkin),
)

# -- 
# Daily report
log_arithmetic %>%
  group_by(date) %>%
  summarise(
    worked_seconds   = sum(worked_seconds),
    work_day_seconds = (37 * 60 * 60) / 5,
    balance_daily    = worked_seconds - work_day_seconds,
    ) %>%
  mutate(
    balance_cumulative = cumsum(balance_daily),
  ) %>%
  transmute(
    date,
    day = substr(tolower(weekdays(as.Date(date))), 1, 3),
    work_hours = sec_to_hm(worked_seconds),
    balance_daily = sec_to_hm_x(balance_daily),
    balance_cumulative = sec_to_hm_x(balance_cumulative),
  ) %>%
  write.csv2("reports/daily.csv", row.names = FALSE, quote = FALSE)


# --
# Weekly report
log_arithmetic %>%
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
    balance      = sec_to_hm_x(balance),
    balance_cummulative = sec_to_hm_x(balance_cummulative),
  ) %>%
  write.csv2("reports/weekly.csv", row.names = FALSE, quote = FALSE)

# --
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

year %>% write.csv2("reports/year.csv", row.names = FALSE, quote = FALSE)
year %>% openxlsx::write.xlsx(file = "reports/year.xlsx")
