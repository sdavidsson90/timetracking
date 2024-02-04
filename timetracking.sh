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

if [ ! -f "log.csv" ] && [[ ! "${*}" = -i ]]; then
  echo "Log file does not exist! Try checking in with '-i'"
  exit 1
fi

print_log() {
  echo -en "\033[1mCheckin          Checkout         Hours\033[0m\n"
  tail -n +2 log.csv | tail -n 10
}

print_report() {
  head -n 1 reports/$1.csv 2>/dev/null && \
  tail -n +2 reports/$1.csv | tail -n 10 || \
  echo -e "${1^} report does not exist! Try checking out with '-o'"
  exit 1
}

while getopts iofeldw OPTIONS; do
  case ${OPTIONS} in
    i)
      bash actions/checkin.sh
      print_log
      ;;
    o)
      Rscript actions/checkout.R
      Rscript actions/report.R > /dev/null 2>&1 & disown
      print_log
      ;;
    f)
      Rscript actions/fix.R
      Rscript actions/report.R > /dev/null 2>&1 & disown
      print_log
      ;;
    e)
      nvim log.csv || vim log.csv
      ;;
    l)
      print_log
      ;;
    d)
      print_report daily
      ;;
    w)
      print_report weekly
      ;;
    ?)
      echo -e "\nInvalid option!"
      exit 1
      ;;
  esac
done
