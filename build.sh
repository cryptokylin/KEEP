#!/usr/bin/env bash

#set -x
# step 1: init
. scripts/init.sh

# step 2: set your own variables
contract="info"        # contract file's and folder's base name

# step 2: build, modify abi file
modify_abi(){
    abi_file=${contract}.abi

    cd ${ROOT_DIR}/contracts/${contract}
    jq 'del(.____comment)'  ${abi_file} | \
    sed 's/"type": "name"/"type": "account_name"/g' | \
    jq ' .types = [{"new_type_name":"account_name","type": "name"}]'  > tmp.abi && mv tmp.abi ${abi_file}
    cd -
}

#build_contract_locally ${contract}
build_contract_docker ${contract} v1.1.1
modify_abi

#set +x