#!bin/bash

getLogFiles() {
    find -type f -name 'user_data_change_log_*.log'
}

files='getLogFiles'

for (file in files) {
    cat file | head
}