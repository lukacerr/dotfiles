#!/bin/bash

case "$1" in
    /*) path="$1" ;;
    *) path="/org/freedesktop/UPower/devices/$1" ;;
esac

print_data()
{
    info=$(upower -i $path)
    percentage=$(echo "$info" | awk '/percentage/ {print $2}')
    state=$(echo "$info" | awk '/state/ {print $2}')
    echo "{\"path\":\"${path}\",\"percentage\":\"${percentage}\",\"state\":\"${state}\"}"
}

print_data $1

upower -m | while read line; do
  mpath=$(echo "$line" | awk '{print $NF}')
  if [[ $mpath == $path ]]; then
    print_data
  fi
done
