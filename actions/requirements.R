# --------------------------------------------------
Sys.setlocale("LC_TIME","en_CA.UTF-8")

# --------------------------------------------------
timestamp <- function() { format(Sys.time(), "%Y-%m-%d %H:%M") }

# --------------------------------------------------
read_log <- function() { read.csv2("log.csv") }

read_log_arithmetic <- function() {
  read_log() %>%
    transmute(
      checkin  = as.POSIXct(checkin,  format = "%Y-%m-%d %H:%M"),
      checkout = as.POSIXct(checkout,  format = "%Y-%m-%d %H:%M"),
      date     = format(checkin, format = "%Y-%m-%d"),
      day      = substr(tolower(weekdays(as.Date(date))), 1, 3),  # move this down
      week     = as.numeric(format(checkin, "%W")),
      worked_seconds = as.numeric(checkout) - as.numeric(checkin),
      expected_workday_seconds = ifelse(day == "sat" | day == "sun", 0, ((37 * 60 * 60) / 5)),
    )
}

write_log <- function(log) { write.csv2(x = log, file = "log.csv", row.names = FALSE, quote = FALSE) }

# --------------------------------------------------
date_to_sec <- function(date) { as.numeric(as.POSIXct(date,  format = "%Y-%m-%d %H:%M")) }

date_to_sec <- function(date) { as.numeric(as.POSIXct(date,  format = "%Y-%m-%d %H:%M")) }
sec_to_hm <- function(wrk_sec) {
  sign    = ifelse(wrk_sec < 0, "-", "")
  wrk_sec = ifelse(wrk_sec < 0, wrk_sec * -1, wrk_sec)
  hours   = as.integer(wrk_sec / 60 / 60)
  minutes = round((wrk_sec - hours * 60 * 60 ) / 60)
  hours   = formatC(hours,   width = 2, flag = 0)
  minutes = formatC(minutes, width = 2, flag = 0)
  paste0(sign, hours, ":", minutes)
}

prepend_plus <- function(x) { ifelse(substring(x, 1, 1) == "-", paste0("", x), paste0("+", x)) }
