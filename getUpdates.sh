#!/bin/bash

#url="http://access-s.clide.cloud/files/climate_drivers/mjo/" 
text1="./mjo_page.html"
#text2="./webpage.html"
# Use curl to retrieve the webpage content
#url_webpage_content="$(curl -s "$url")"
saved_webpage1_content="$(cat -s "$text1")"
saved_webpage2_content="$(cat -s "$text2")"
# Define a regular expression pattern to match the date and time within <td> tags
date_pattern="([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} )" # dateFormat "2023-10-04 10:30 "

# Extract all the dates using grep and store them in an array
#dates=($(cat "$webpage_content" | grep -Po "$date_pattern" | sed -e 's/<[^>]*>//' | sed -e 's/<\/td>//g'))

text_dates=($(echo "$saved_webpage1_content" | grep -Po "$date_pattern"))
url_dates=($(echo "$saved_webpage2_content" | grep -Po "$date_pattern"))

format_dates_and_store() {
    local input_array=("$@")  # Store the passed array in a local variable
    local output_array=()     # Initialize an empty array for storing formatted values
    local i=0

    while [ $i -lt ${#input_array[@]} ]; do
        local date="${input_array[$i]}"
        local time="${input_array[$i+1]}"
        local formatted="${date} ${time}"
        output_array+=("$formatted")
        ((i+=2))
    done

    # Return
    echo "${output_array[@]}"
}

format_and_display() {
    formatted_dates=($(format_dates_and_store "${text_dates[@]}"))
    formatted_url=($(format_dates_and_store "${url_dates[@]}")) 

    # Check if both arrays have the same length
    if [ ${#formatted_dates[@]} -ne ${#formatted_url[@]} ]; then
        echo "Arrays have different lengths, cannot display side by side."
        return
    fi

    #echo "${formatted_url[@]}"
    #echo "${formatted_dates[@]}"

    for ((i = 0; i < ${#formatted_dates[@]}; i++)); do
        local date1="${formatted_dates[$i]}"
        local time1="${formatted_dates[$i+1]}"
        local date2="${formatted_url[$i]}"
        local time2="${formatted_url[$i+1]}"
        if [ "$date1 $time1" != "$date2 $time2" ]; then
            echo "$date1 $time1 | $date2 $time2 |: Modified :|"
        else 
            echo "$date1 $time1 | $date2 $time2 || Constant ||"
        fi
        #echo "$date1 $time1 | $date2 $time2"
        ((i++)) 
    done
}

format_and_display
