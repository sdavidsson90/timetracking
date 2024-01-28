# --
if (!file.exists("daily.csv"))  {
  writeLines(text = '"checkin";"checkout";"hrs"', con = 'daily.csv')
}

# --
sec_to_hm <- function(wrk_sec) {
  sign = ifelse(wrk_sec < 0, "-", "")
  wrk_sec = ifelse(wrk_sec < 0, wrk_sec * -1, wrk_sec)
  hours   = as.integer(wrk_sec / 60 / 60)
  minutes = round((wrk_sec - hours * 60 * 60 ) / 60)
  hours   = formatC(hours,   width = 2, flag = 0)
  minutes = formatC(minutes, width = 2, flag = 0)
  paste0(sign, hours, ":", minutes)
}
