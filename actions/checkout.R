# --------------------------------------------------
source('actions/requirements.R')

# --------------------------------------------------
log <- read_log()

# --------------------------------------------------
log[nrow(log), "checkout"] <- timestamp()

checkin_sec  <- as.numeric(as.POSIXct(log[nrow(log), "checkin"]))
checkout_sec <- as.numeric(as.POSIXct(log[nrow(log), "checkout"]))
difference   <- sec_to_hm(checkout_sec - checkin_sec)

log[nrow(log), "hrs"] <- difference

# --------------------------------------------------
write_log(log)
