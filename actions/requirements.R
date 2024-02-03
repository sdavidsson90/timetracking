# --
Sys.setlocale("LC_TIME","da_DK.UTF-8")

log_filepath <- "log.csv"

create_log_file <- function() {
  if ( !file.exists(log_filepath) ) { writeLines(text = "checkin;checkout;hrs", con = log_filepath) }
}


create_report_files <- function() {
  message <- "Generate reports with the '-r' flag"
  if ( !file.exists("reports") ) { dir.create("reports") }
  if ( !file.exists("reports/daily.csv") ) { writeLines(message, "reports/daily.csv") }
  if ( !file.exists("reports/weekly.csv") ) { writeLines(message, "reports/weekly.csv") }
  if ( !file.exists("reports/year.csv") ) { writeLines(message, "reports/year.csv") }
}


timestamp <- function() { format(Sys.time(), "%Y-%m-%d %H:%M") }

read_log <- function() { read.csv2(log_filepath) }

write_log <- function(log) { write.csv2(x = log, file = log_filepath, row.names = FALSE, quote = FALSE) }


sec_to_hm <- function(wrk_sec) {
  sign = ifelse(wrk_sec < 0, "-", "")
  wrk_sec = ifelse(wrk_sec < 0, wrk_sec * -1, wrk_sec)
  hours   = as.integer(wrk_sec / 60 / 60)
  minutes = round((wrk_sec - hours * 60 * 60 ) / 60)
  hours   = formatC(hours,   width = 2, flag = 0)
  minutes = formatC(minutes, width = 2, flag = 0)
  paste0(sign, hours, ":", minutes)
}

# Same as previous but nicer for parsing balances
sec_to_hm_x <- function(wrk_sec) {
  sign = ifelse(wrk_sec < 0, "-", "+")
  wrk_sec = ifelse(wrk_sec < 0, wrk_sec * -1, wrk_sec)
  hours   = as.integer(wrk_sec / 60 / 60)
  minutes = round((wrk_sec - hours * 60 * 60 ) / 60)
  hours   = formatC(hours,   width = 2, flag = 0)
  minutes = formatC(minutes, width = 2, flag = 0)
  paste0(sign, hours, ":", minutes)
}
