#!/bin/bash
while read line
do
    uid=`echo $line | awk -F '{' 'print $(NF-1)' | awk -F ',' '{print $1}'
    target_info=`echo $line | grep -o '"cur":.*"pre":{.*}}}' | awk -F '"cur":|,"pre":' '{print $2, $3}' `
    echo $target_info | akw -F ',| ' '{
        for(i=1;i<NF/2;i++) {
            print $i, $(NF/2+i)
        }}' | awk -F '"|:| ' '{
            if(NF==8){
                id=$2
                cur=$4
                pre=$8
            } else {
                type=$2
                id=$5
                cur=$7
                pre=$14
            }
            printf "%s\t%s\t%s\t%s\t%s\t%s", $uid, $type, $id, $pre, $cur, ($cur-$pre)
            }'
done

cat user_data_change_log_2019080207.log | 
    grep -o '"cur":.*"pre":{.*}}}' | 
    awk -F '"cur":|,"pre":' '{print $2, $3}' | 
    awk -F ',| ' '{for(i=i;i<NF/2;i++){print $i,$(NF/2+i)}}' | 
    awk -F '"|:| ' '{if(NF==8){print $type,$2,$4,$8}else{print $2,$5,$7,$14;type=$2}}'| head
