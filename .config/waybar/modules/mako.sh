#!/bin/bash

makoctl history | jq -r '
    .data[0] | reverse |
    map(
        "----------\n\n" +
        "### \(.summary.data) (\(.["app-name"].data))\n" +
        "\(.body.data // "No body")\n"
    ) | join("\n")
'

read
