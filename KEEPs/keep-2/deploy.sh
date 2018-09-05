#!/usr/bin/env bash

#set -x

c_name=nodeostmp
api_mainnet="https://api.eosstore.co"
api_kylinnet="http://api.kylin.eoseco.com"

docker rm ${c_name} -f 1>/dev/null 2>&1
docker run  -v `pwd`/contracts:/scts  --name ${c_name} eosio/eos sleep 100000 &
cleos="docker exec ${c_name} cleos"
sleep 3 && $cleos wallet create 1>/dev/null 2>&1 && sleep 1


if [ "$1" == "getcode" ];then
    $cleos -u ${api_mainnet}  get code cryptokylin1
    $cleos -u ${api_kylinnet}  get code contracts111
fi


if [[ "$1" == "mainnet" || "$1" == "" ]];then
    echo -n "请输入主网cryptokylin1私钥:" && read -s ps_cryptokylin1 && echo
    $cleos wallet import --private-key ${ps_cryptokylin1}
    $cleos -u ${api_mainnet}  set contract cryptokylin1 /scts/info -p cryptokylin1
fi


if [[ "$1" == "testnet" || "$1" == "" ]];then
    echo -n "请输入测试网contracts111私钥:" && read -s ps_contracts111 && echo
    $cleos wallet import --private-key ${ps_contracts111}
    $cleos -u ${api_kylinnet} set contract contracts111 /scts/info -p contracts111
fi

docker rm ${c_name} -f 1>/dev/null 2>&1




set +x

