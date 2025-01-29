#!/bin/bash

data=$(curl -s "wttr.in/?format=j1" | jq .current_condition[0] || echo "{}") 
icon="❓"

if [[ $data != "{}" ]]; then 
  weather_desc=$(echo "$data" | jq -r '.weatherDesc[0].value')
  case "$weather_desc" in
  "ERROR") icon="󰃤" ;;
  "Clear"|"Sunny") icon="☀️" ;;
  "Partly cloudy") icon="⛅" ;;
  "Cloudy"|"Overcast") icon="☁️" ;;
  "Mist"|"Fog"|"Haze") icon="🌫️" ;;
  "Patchy rain possible"|"Light rain") icon="🌦️" ;;
  "Moderate rain"|"Heavy rain"|"Rain") icon="🌧️" ;;
  "Thunderstorm") icon="⛈️" ;;
  "Snow"|"Light snow") icon="🌨️" ;;
  "Blizzard") icon="❄️" ;;
  *) icon="❓" ;; 
  esac
fi

echo "{\"data\": $data, \"icon\": \"$icon\"}"


