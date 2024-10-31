#!/usr/bin/env bash
    
# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')
green=$(tput setaf 2)
red=$(tput setaf 1)
white=$(tput setaf 7)
    
echo Obtaining cipher list from $(openssl version).
    
for cipher in ${ciphers[@]}
do
  printf "${white}Testing %-40s${white}" $cipher
  result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
  if [[ "$result" =~ ":error:" ]] ; then
    error=$(echo -n $result | cut -d':' -f6)
    printf "${red}NO${red} ${white}$error${white}\n"
  else
    if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
      printf "${green}YES${green}\n"
    else
      echo UNKNOWN RESPONSE
      echo $result
    fi
  fi
  sleep $DELAY
done
