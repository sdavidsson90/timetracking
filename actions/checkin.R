# --
source('actions/requirements.R')

create_log_file()

# --
log <- read_log()

# -- Create new entry with checkin timestamp
entry <- data.frame(checkin  = timestamp(), checkout = "", hrs  = "")
log   <- rbind(log, entry)

# --
write_log(log)
