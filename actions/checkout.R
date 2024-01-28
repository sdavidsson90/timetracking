# -- 
source('actions/requirements.R')

# --
daily <- read.csv2("daily.csv")

# --
daily[nrow(daily), "checkout"] <- format(Sys.time(), "%Y-%m-%d %H:%M")

# -- 
checkin_sec  <- as.numeric(as.POSIXct(daily[nrow(daily), "checkin"]))
checkout_sec <- as.numeric(as.POSIXct(daily[nrow(daily), "checkout"]))
difference <- checkout_sec - checkin_sec
daily[nrow(daily), "hrs"] <- sec_to_hm(difference)

# --
write.csv2(daily, "daily.csv", row.names = FALSE)
