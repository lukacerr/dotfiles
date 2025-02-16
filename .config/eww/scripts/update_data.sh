#!/bin/bash

build_obj()
{
  echo "{\"tag\":\"$1\",\"icon\":\"$2\",\"upCommand\":\"$3\",\"count\":$4}"
}

# TODO: Firmware updates
# Example -> $(build_obj 'Name' 'Icon' 'update command' $(count_function),
# Then add it to the "objs" array below
zypper=$(build_obj 'Zypper' ' ' 'sudo zypper dup --no-recommends' $(sudo zypper lu | grep 'v  |' | wc -l))
flatpak=$(build_obj 'Flatpak' ' ' 'flatpak update' $(flatpak remote-ls --updates --columns=description | wc -l))
objs=("$zypper" "$flatpak") # "$your_new"

# # # # # # # # # # # # # # # # # # # # # # # # #
# You probably don't want to touch from here :) #
# # # # # # # # # # # # # # # # # # # # # # # # #

has_updates=0
for obj in "${objs[@]}"; do
  if [[ $obj != *'"count":0'* ]]; then
    has_updates=1
    break
  fi
done

if [[ $has_updates -eq 1 ]]; then
  json=$(IFS=,; echo "[${objs[*]}]")
  echo "$json"
else 
  echo '[{"tag":"No","icon":"󰚰","upCommand":"up","count":-1}]'
fi
