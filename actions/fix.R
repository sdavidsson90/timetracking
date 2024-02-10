# --------------------------------------------------
source('actions/requirements.R')

# --------------------------------------------------
log <- read_log()

# --------------------------------------------------
log$hrs <- date_to_sec(log$checkout) - date_to_sec(log$checkin)
log$hrs <- sec_to_hm(log$hrs)
log$hrs[log$hrs == 'NANA:NA'] <- ""

# --------------------------------------------------
write_log(log)
