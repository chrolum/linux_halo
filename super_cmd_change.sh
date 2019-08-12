#!/bin/bash
log_file="user_data_change_log_2019080207.log"

grep 'cur' $log_file > log.stat.tmp
echo -n "" > pre.tmp #uid type id pre
echo -n "" > cur.tmp #uid type id cur
echo 'check point: flow file'
cat log.stat.tmp | while read line
do
    uid=`echo $line | awk -F 'uid_info...' '{print $2}' | awk -F ',' '{print $1}'`
    #pre infomation for a line
    echo $line | awk -F 'content..|..data_type|uid_info..' '{print $2}' | 
        awk -F 'cur..|."pre' '{print $2}' | 
        awk -F '},' '{for(i=1;i<=NF;i++){print $i}}' | 
        awk -F ':{' '{print $1, $2}' | 
        sed 's/{//g' | sed 's/"//g' | sed 's/,/ /g' | 
        awk -v u=$uid '{for(idx=2;idx<=NF;++idx){print u,$1,$idx}}' | sed 's/:/ /g' | sed 's/}//g' >> cur.tmp
    
    #curr infomation for a line and output the last column
    echo $line | awk -F 'content..|..data_type|uid_info..' '{print $2}' | 
        awk -F '"pre..|...data_type' '{print $2}' | 
        awk -F '},' '{for(i=1;i<=NF;i++){print $i}}' | 
        awk -F ':{' '{print $1, $2}' | 
        sed 's/{//g' | sed 's/"//g' | sed 's/,/ /g' | 
        awk '{for(idx=2;idx<=NF;++idx){print $idx}}' | sed 's/:/ /g' | sed 's/}//g' | awk '{print $2}' >> pre.tmp 
done
echo 'check point: end loop'
# combine the pre and cur infomation
paste cur.tmp pre.tmp | tr -s [:blank:] | tr '\t' ' ' > res.tmp

# unfited change infomation
grep 'cur' user_data_change_log_2019080207.log | 
    awk -F '"content..|..cur":' '{print $2}'| 
    grep -o '\[\[.*]]'| 
    sed 's/in [0-9]* sec//g' | sed 's/\[//g' | 
    tr -d [a-z] | sed 's/}//g'| sed 's/,/ /g' | sed 's/"//g' | sed 's/://g' | sed 's/{//g' | 
    tr -s [:space:] > change.dirty.tmp

# clean change infomations
cat change.dirty.tmp | awk '{for(i=3;i<=NF;i+=3){print $(i-2),$(i-1),$i}}' | awk 'if($1!=94){print $3}' > change.clean.tmp

# final combination
paste res.tmp change.clean.tmp | tr -s [:blank:] | tr '\t' ' '> res


    
