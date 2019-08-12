#!/bin/bash

raw_data=`cat data.log |awk -F 'uid=|&sid|&command=|],ret' '{print $2, $4}'| awk -F '&' '{print $1}'` | sort | head
