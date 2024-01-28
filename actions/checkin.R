# --
source('actions/requirements.R')

# --
daily <- read.csv2("daily.csv")

# --
checkin  <- format(Sys.time(), "%Y-%m-%d %H:%M")
entry <- data.frame(checkin  = checkin, checkout = NA, hrs  = NA)
daily <- rbind(daily, entry)

# --
write.csv2(daily, "daily.csv", row.names = FALSE)
