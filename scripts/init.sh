#!/usr/bin/env bash

ROOT_DIR='/Users/song/Home/Golang/src/github.com/cryptokylin/KEEP/'

IMAGE_OFFICAL='eosio/eos'
IMAGE_MAINNET='eoslaomao/eos:mainnet-1.1.1'

cleos='docker exec nodeos cleos'
eosio_abigeneos='docker exec nodeos eosio-abigeneos'
eosio_launcher='docker exec nodeos eosio-launcher'
eosio_s2wasm='docker exec nodeos eosio-s2wasm'
eosio_wast2wasm='docker exec nodeos eosio-wast2wasm'


get_str(){
    echo $1 | cut -d'|' -f$2
}

get_pri(){
    get_str $1 1
}

get_pub(){
    get_str $1 2
}

rm_build_files(){
    rm *.wast *.wasm *.abi 2>/dev/null
}

rm_all_build(){
    cd ${ROOT_DIR} && rm */*/*.wasm && rm */*/*.wast && rm */*/*.abi
}

# usage: create_account account_name owner_key [active_key]
create_account(){
    $cleos system newaccount --stake-net "100.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS" eosio $1 $2 $3 -p eosio
}

import_key(){
    $cleos wallet import --private-key $1
}

create_account_and_import_key(){
    account=$1
    pub_key=`get_pub $2`
    pri_key=`get_pri $2`
    create_account ${account} ${pub_key}
    import_key ${pri_key}
}

new_account(){
    account=$1

    str=`cleos create key`
    pri_key=`echo $str | cut -d' ' -f 3`
    pub_key=`echo $str | cut -d' ' -f 6`

    create_account ${account} ${pub_key}
    import_key ${pri_key}
}

add_abi_types(){
    abi_file=$1
    jq ' .types = [{"new_type_name":"account_name","type": "name"}]' ${abi_file} > tmp.abi && mv tmp.abi ${abi_file}
}

build_contract_docker(){
    contract=$1

    version=$2
    if [ "$2" == "" ];then
        version='v1.1.4'
    fi

    cd ${ROOT_DIR}/contracts/${contract} && rm_build_files
    docker run --rm -v `pwd`:/scts eosio/eos-dev:${version} bash -c "cd /scts \
        && eosiocpp -o ${contract}.wast ${contract}.cpp \
        && eosiocpp -g ${contract}.abi ${contract}.cpp"
    cd -
}

build_contract_locally(){
    contract=$1

    cd ${ROOT_DIR}/contracts/${contract} && rm_build_files
    eosiocpp -o ${contract}.wast ${contract}.cpp
    eosiocpp -g ${contract}.abi  ${contract}.cpp
    cd -
}



