#!/bin/bash

cd ~/Documents/github/sdavidsson90/timetracking/

while getopts iour OPTIONS; do
  case ${OPTIONS} in
    i)
      echo "Checkin in"
      Rscript actions/checkin.R
      tail -n 5 daily.csv 
      ;;
    o)
      echo "Checkout"
      Rscript actions/checkout.R
      tail -n 5 daily.csv 
      ;;
    u)
      echo "Update..." 
      Rscript actions/fix.R
      tail -n 5 daily.csv 
      ;;
    r)
      echo "Report"
      ;;
  esac
done
