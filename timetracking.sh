#!/bin/bash

# ===================================
#
#    Timetracking
#    Author: Sighvatur Sveinn Davidsson (2024)
#
#    Description:
#    Sources a series of actions to create timestamps in a timetracking log.
#    Report generation depends on R-libraries: openxlsx, dplyr. The rest is
#    base-R and bash.
# 
#    Usage: $ timetracking <i|o|f|e|l|d|w>
#    -i    Create entry in "checkin" field log.csv
#    -o    Create entry in "checkout" field in log.csv
#    -f    Fix: Recalculate "hrs" field in log.csv
#    -l    Print log.csv
#    -e    Open log.csv for editing
#    -d    Print reports/daily.csv
#    -w    Print reports/weekly.csv
#
# ===================================

cd $(dirname $0)

BOLD=$(tput bold)
NORM=$(tput sgr0)

if [ ! -f "log.csv" ] && [[ ! "${*}" = -i ]]; then
  echo "Log file does not exist! Try checking in with '-i'"
  exit 1
fi

print_log() {
  echo "${BOLD}Checkin           Checkout          Hours${NORM}"
  awk -F ';' 'NR>2 {print $1, "", $2, "", $3}' < log.csv | tail -n 10
}

while getopts :iofeldw OPTIONS; do
  case ${OPTIONS} in
    i)
      bash actions/checkin.sh
      print_log
      ;;
    o)
      Rscript actions/checkout.R
      Rscript actions/reports.R > /dev/null 2>&1 & disown
      print_log
      ;;
    f)
      Rscript actions/fix.R > /dev/null 2>&1
      Rscript actions/reports.R  > /dev/null 2>&1 & disown
      print_log
      ;;
    e)
      nvim log.csv || vim log.csv 
      wait `pgrep vim` > /dev/null 2>&1
      Rscript actions/fix.R
      Rscript actions/reports.R  > /dev/null 2>&1 & disown
      print_log
      ;;
    l)
      print_log
      ;;
    d)
      echo "${BOLD}Date   Day  Worked  Balance  Cumulative${NORM}"
      awk -F ';' 'NR>1 { print substr($1, 6), "", $2, "", $3, "  ", $4, "    ", $5 }' < reports/daily.csv | tail -n 10
      ;;
    w)
      echo "${BOLD}W  Hours  Balance  Cumulative${NORM}"
      awk -F ';' 'NR>1 { print $1,"", $2, " ", $3, "    ", $4 }' < reports/weekly.csv | tail -n 10
      ;;
    ?)
      echo "Invalid option!"
      exit 1
      ;;
  esac
done
