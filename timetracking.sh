#!/bin/bash

# ===================================
#
#    Timetracking
#    Author: Sighvatur Sveinn Davisson (2024)
#
#    Description:
#    Sources a series of actions to create timestamps in a timetracking log.
#    Report generation depends on R-libraries: openxlsx, dplyr. 
#    The rest is base-R.
# 
#    Usage: $ timetracking <i|o|l|e|r|d|w>
#    -i    Create entry in "checkin" field
#    -o    Create entry in "checkout" field
#    -l    Print log.csv
#    -e    Open 'log.csv' for editing
#    -r    Generate reports/*
#    -d    Print reports/daily.csv
#    -w    Print reports/weekly.csv
#
# ===================================

cd $(dirname $0)

while getopts ioerldw OPTIONS; do
  case ${OPTIONS} in
    i)
      Rscript actions/checkin.R 2>/dev/null && \
      echo -en "\033[1mCheckin          Checkout         Hours\033[0m\n" && \
      tail -n +2 log.csv | tail -n 10
      ;;
    o)
      Rscript actions/checkout.R 2>/dev/null && \
      echo -en "\033[1mCheckin          Checkout         Hours\033[0m\n" && \
      tail -n +2 log.csv | tail -n 10 || \
      echo "'log.csv' does not exist - try checking in with '-i'"
      ;;
    e)
      if [ -f "log.csv" ]; then
        nvim log.csv || vim log.csv
      else
        echo "'log.csv' does not exist! Try checking in with '-i'"
      fi
      ;;
    r)
      Rscript actions/report.R  2>/dev/null && \
      echo "Successfully generated reports in directory 'reports'" || \
      if [ ! -f "log.csv" ]; then
        echo "'log.csv' does not exist! Try checking in with '-i'"
        exit 1
      elif [[ $(tail -n 1 log.csv|wc -m|tr -d ' ') -lt 20 ]] ; then
        echo "Failed to generate reports! Don't forget to complete your latest entry with the '-o' flag"
        exit 1
      fi
      ;;
    l)
      head -n 1 log.csv 2>/dev/null && \
      tail -n +2 log.csv | tail -n 10 2>/dev/null || \
      echo "'log.csv' does not exist! Try checking in with '-i'"
      exit 1
      ;;
    d)
      head -n 1 reports/daily.csv 2>/dev/null && \
      tail -n +2 reports/daily.csv | tail -n 10 || \
      echo -e "'daily report' does not exist! Try generating reports with '-r'"
      exit 1
      ;;
    w)
      head -n 1 reports/weekly.csv 2>/dev/null && \
      tail -n +2 reports/weekly.csv | tail -n 10 || \
      echo -e "'weekly report' does not exist! Try generating reports with '-r'"
      exit 1
      ;;
  esac
done
