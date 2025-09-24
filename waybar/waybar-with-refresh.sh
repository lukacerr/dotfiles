#!/bin/bash

while true; do
	killall waybar
  waybar &
  sleep $1
  echo init
done
