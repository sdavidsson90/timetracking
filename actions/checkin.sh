if [ -f "log.csv" ]; then
  echo "$(date +"%Y-%m-%d %H:%M");;" >> log.csv
else
  echo 'checkin;checkout;hrs' >> log.csv
  echo "$(date +"%Y-%m-%d %H:%M");;" >> log.csv
fi
