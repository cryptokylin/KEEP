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
#    . ./build.sh
    $cleos set contract  ${accountaddr} /mycts/${contract} -p ${accountaddr}
fi

# ================================== Step 5: Test ==================================
if [ "${action}" == 'test' ]; then
    set -x

    test_update(){
        $cleos push action ${accountaddr} createupdate '["inita", "https://www.website-a1.com", "https://www.website.com/logo.png", "brief intro" ,"https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","key1=value1|key2=value2|key3=value3"]' -p inita@active
        $cleos push action ${accountaddr} createupdate '["initb", "https://www.website-b1.com", "https://www.website.com/logo.png", "brief intro" ,"https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","key1=value1|key2=value2|key3=value3"]' -p initb@active

        $cleos get table ${accountaddr} ${accountaddr} info

        $cleos push action ${accountaddr} createupdate '["inita", "https://www.website-a2.com", "https://www.website.com/logo.png", "brief intro" ,"https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","key1=value1|key2=value2|key3=value3"]' -p inita@active
        $cleos push action ${accountaddr} createupdate '["initb", "https://www.website-b2.com", "https://www.website.com/logo.png", "brief intro" ,"https://github.com/repo/project", "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","key1=value1|key2=value2|key3=value3"]' -p initb@active

        $cleos get table ${accountaddr} ${accountaddr} info


        $cleos push action ${accountaddr} remove '["inita"]' -p inita@active
        $cleos push action ${accountaddr} remove '["initb"]' -p initb@active
        $cleos get table ${accountaddr} ${accountaddr} info

        
        contract=inita
        website=https://www.website-a1.com
        logo_256=https://www.website.com/logo.png
        brief_intro="brief intro"
        github="https://github.com/repo/project"
        white_paper="QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7"
        src_zip="QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7"

        telegram="https://t.me/cryptokylin"
        steemit=https://steemit.com/@eosio
        twitter="https://twitter.com/EOS_io"
        wechat="EOSIO-foo"

        extension="telegram=${telegram}|steemit=${steemit}|twitter=${twitter}|wechat=${wechat}"

        str="[ \"${contract}\",\"${website}\",\"${logo_256}\",\"${brief_intro}\",\"${github}\",\"${white_paper}\",\"${src_zip}\",\"${extension}\" ]"

        $cleos push action ${accountaddr} createupdate "$str" -p inita@active


    }
    test_update

    set +x
fi
