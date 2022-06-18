##!/bin/bash

cache_directory=~/.config/v2ray_helper
cache_path=$cache_directory/cache

function normalParse(){
    declare -A subscribe
    subscribe=(
        [subscribe_name]='your_subscribe_url'   #替换成机场的url,名字随意
    )

    #select subscibe
    for node in ${!subscribe[@]}
    do
        printf "[%b] %b\n" "${node}" "${subscribe[${node}]}"
    done

    read -p "select a subscribe > " node
    if [ -z "$node" ] || [ -z ${subscribe[$node]} ]; then

       echo -e "\033[31m bad subscribe name\033[0m" >&2
       exit

    fi

    #decode format
    vmess_str=$(curl -s ${subscribe[${node}]} | base64 -di | sed '/^[^v]/d') #sed "/^(?!vmess)/d" sed不支持断言
    vmess_arr=(${vmess_str//'vmess://'/})
    for i in ${!vmess_arr[@]}
    do
        #printf "%b\n" "${vmess_arr[$i]}"
        vmess_arr[$i]=$(base64 -di <<< ${vmess_arr[$i]} | tr -d ' ') 
    done

    #select connection
    for i in ${!vmess_arr[@]}
    do
        read address name < <(echo $(jq -r '.add, .ps' <<< "${vmess_arr[i]}"))
        printf "%b\t%b\t%b\n"\
            "$i"\
            "$name"\
            "$(curl -s --connect-timeout 2 -o /dev/null -w "%{time_connect}" "$address")" 
    done

    read -p "select a connection > " index
    if [ -z $index ] || [[ ! $index =~ ^[0-9]+$ ]] || [ $index -gt ${#vmess_arr[@]}  ]  ; then

       echo -e "\033[31m bad connection index\033[0m" >&2
       exit
    fi

    #extract keypoint to config.json
    read address port id < <(echo $(jq -r '.add, .port, .id' <<< "${vmess_arr[index]}"))

    [ -d $cache_directory ] || mkdir $cache_directory
    touch "$cache_path"
    printf "%s %s %s" $address $port $id > $cache_path

    injectToConfig $address $port $id
    v2ray -config ./config.json
}


function injectToConfig(){
    jq --arg address "$1" --arg port "$2" --arg id "$3"\
        '.outbounds[0].settings.vnext[0].address=$address 
        | .outbounds[0].settings.vnext[0].port=($port|tonumber)
        | .outbounds[0].settings.vnext[0].users[0].id=$id' < ./config.json | sponge ./config.json
}


function useCache(){
    if [ -e "$cache_path" ]; then
        cache=($(cat "$cache_path")) 
        #printf "%b\n" "${cache[@]}"
        injectToConfig ${cache[0]} ${cache[1]} ${cache[2]}
        v2ray -config ./config.json
        exit
    else
        normalParse
    fi
}



[ $# -gt 0 ] || useCache

while getopts nc flag

do
    case "${flag}" in
          n) 
              normalParse
              ;;
          c)  cat "$cache_path"
     esac
done


