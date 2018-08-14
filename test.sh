#!/usr/bin/env bash

# step 1: init
. scripts/init.sh
action=$1

# step 2: set your own variables
contract="info"        # contract file's and folder's base name
accountaddr="info"     # account who set the contract code to the chain
issuer="boss"               # token issuer


# step 3: bios boot and create accounts;
if [ "${action}" == '' ];then
    . scripts/boot.sh

    for name in ${accountaddr} boss inita initb initc initd; do
        new_account ${name}
    done
fi



# step 4: build, modify abi file and deploy contract.
if [[ "${action}" == "" || "${action}" == "deploy" ]]; then
    . ./build.sh
    $cleos set contract  ${accountaddr} /mycts/${contract} -p ${accountaddr}
fi

# ================================== Step 5: Test ==================================
if [ "${action}" == 'test' ]; then
    set -x

    test_update(){
        $cleos push action ${accountaddr} update '["inita","account11", "www.abc.com", "www.github.com","ipfs","image-id","script"]' -p inita@active
        $cleos push action ${accountaddr} update '["inita","account12", "www.abc.com", "www.github.com","ipfs","image-id","script"]' -p inita@active
        $cleos push action ${accountaddr} update '["initb","account21", "www.abc.com", "www.github.com","ipfs","image-id","script"]' -p initb@active
        $cleos push action ${accountaddr} update '["initb","account22", "www.abc.com", "www.github.com","ipfs","image-id","script"]' -p initb@active
        $cleos get table ${accountaddr} inita info
        $cleos get table ${accountaddr} initb info


        $cleos push action ${accountaddr} remove '["inita","account11"]' -p inita@active
        $cleos get table ${accountaddr} inita info
    }
    test_update



    set +x
fi