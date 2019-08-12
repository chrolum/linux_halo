#!/bin/bash

INDENTATION_SPACE_NUM=4
curr_indentation_num=0

json='{"1":2,"2":3,"3":{"4":{"4":{"3":{"2333":3}},"3":2}}}'

make_space() {
    space_n=INDENTATION_SPACE_NUM*curr_indentation_num
    space_s=`printf ' %.0s' {1..$space_n}`
    echo -n $space_s
}

for ((i=0; i<${#json}; i++)); do
    c=`echo "${json:$i:1}"`
    if [ $c = '}']
    then
        echo $c
        echo '' #new line
        curr_indentation_num+=1
        space_s=`make_space curr_indentation_num`
        echo -n $space_s #the curr + 1 indentation
    elif [ $c =',' ]
    then
        echo ''
        space_s=`make_space curr_indentation_num`
        echo -n $space_n
        echo $c
    elif [ $c = '}' ]
    then
        echo ''
        curr_indentation_num-=1
        space_s=`make_space curr_indentation_num`
        echo -n $space_n
        echo $c
    else
        echo $c
    fi
done
