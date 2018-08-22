#!/usr/bin/env bash
ROOT_DIR=`pwd`

# step 1: init
. scripts/init.sh
action=$1

# step 2: set your own variables
contract="info"        # contract file's and folder's base name
accountaddr="contracts111"     # account who set the contract code to the chain
issuer="boss"               # token issuer


# step 3: bios boot and create accounts;
if [ "${action}" == '' ];then
    . scripts/boot.sh

    for name in ${accountaddr} boss inita initb initc initd bigboss11111 contract5111; do
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
        $cleos push action ${accountaddr} createupdate '["inita", "https://www.website-a1.com", "https://www.website.com/logo.png", "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","memo"]' -p inita@active
        $cleos push action ${accountaddr} createupdate '["inita", "https://www.website-a2.com", "https://www.website.com/logo.png", "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","memo"]' -p inita@active
        $cleos push action ${accountaddr} createupdate '["initb", "https://www.website-b1.com", "https://www.website.com/logo.png", "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","memo"]' -p initb@active
        $cleos push action ${accountaddr} createupdate '["initb", "https://www.website-b2.com", "https://www.website.com/logo.png", "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","memo"]' -p initb@active
        $cleos get table ${accountaddr} ${accountaddr} info
        $cleos get table ${accountaddr} ${accountaddr} info


        $cleos push action ${accountaddr} remove '["inita"]' -p inita@active
        $cleos push action ${accountaddr} remove '["initb"]' -p initb@active
        $cleos get table ${accountaddr} ${accountaddr} info
        $cleos get table ${accountaddr} ${accountaddr} info

    }
    test_update

    set +x
fi
