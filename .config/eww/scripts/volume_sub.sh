#!/bin/bash

print_status() 
{
  value=$(amixer get Master | awk -F'[][]' '/%/ {print $2; exit}')
  status=$(amixer get Master | awk -F'[][]' '/%/ {print $4; exit}')
  echo "{\"value\":\"${value}\",\"status\":\"${status}\"}"
}

print_status

pactl subscribe | grep --line-buffered "sink" | while read -r _; do print_status; done
