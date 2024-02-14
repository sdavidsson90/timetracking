# --------------------------------------------------
Sys.setlocale("LC_TIME","en_CA.UTF-8")

# --------------------------------------------------
timestamp <- function() { format(Sys.time(), "%Y-%m-%d %H:%M") }

# --------------------------------------------------
read_log <- function() { read.csv2("log.csv") }

read_log_arithmetic <- function() {
  read_log() %>%
  dplyr::transmute(
    checkin  = as.POSIXct(checkin,  format = "%Y-%m-%d %H:%M"),
    checkout = as.POSIXct(checkout,  format = "%Y-%m-%d %H:%M"),
    date     = format(checkin, format = "%Y-%m-%d"),
    day      = substr(tolower(weekdays(as.Date(date))), 1, 3),  # move this down
    week     = as.numeric(format(checkin, "%W")),
    worked_seconds = as.numeric(checkout) - as.numeric(checkin),
  ) %>%
  na.omit()
}

write_log <- function(log) { write.csv2(x = log, file = "log.csv", row.names = FALSE, quote = FALSE) }

# --------------------------------------------------
date_to_sec <- function(date) { as.numeric(as.POSIXct(date,  format = "%Y-%m-%d %H:%M")) }

sec_to_hm <- function(sec) {
    sign    = ifelse(sec < 0, "-", "")
    sec     = ifelse(sec < 0, sec * -1, sec)
    hours   = as.integer(sec / 60 / 60)
    minutes = round((sec - hours * 60 * 60 ) / 60)
    hours   = formatC(hours,   width = 2, flag = 0)
    minutes = formatC(minutes, width = 2, flag = 0)
    paste0(sign, hours, ":", minutes)
}

prepend_plus <- function(x) { ifelse( nchar(x) == 5, paste0("+", x), paste0("", x)) }
