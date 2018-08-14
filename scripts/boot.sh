#!/usr/bin/env bash

. init.sh >/dev/null 2>&1

set -x

init(){
    docker rm nodeos -f 1>/dev/null 2>&1
    docker run -d -v ${ROOT_DIR}/contracts:/mycts --name nodeos ${IMAGE_MAINNET} nodeosd.sh -e -p eosio \
        --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin \
        --contracts-console --max-transaction-time 1000

    docker exec nodeos nohup /opt/eosio/bin/keosd --http-server-address=127.0.0.1:8900 --unlock-timeout 1000000 > /dev/null 2>/dev/null &
    sleep 1 && $cleos wallet create > /dev/null
    $cleos wallet import  --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

    sleep 1 && $cleos set contract eosio /opt/eosio/bin/data-dir/contracts/eosio.bios -p eosio
}
init


create_system_account(){
    for account in eosio.token eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.vpay eosio.bpay
    do
      echo -e "\n creating $account \n";
      $cleos create account eosio ${account} EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV;
    done
}
create_system_account


deploy_token_and_msig_contract(){
    $cleos set contract eosio.token /opt/eosio/bin/data-dir/contracts/eosio.token -p eosio.token
    $cleos set contract eosio.msig /opt/eosio/bin/data-dir/contracts/eosio.msig -p eosio.msig
}
deploy_token_and_msig_contract


create_and_issue_eos_token(){
    $cleos push action eosio.token create '["eosio", "10000000000.0000 EOS"]' -p eosio.token
    $cleos push action eosio.token issue  '["eosio", "1000000000.0000 EOS", "memo"]' -p eosio
}
create_and_issue_eos_token


set_msig_privilege(){
    $cleos push action eosio setpriv '{"account": "eosio.msig", "is_priv": 1}' -p eosio
}
set_msig_privilege


deploy_system_contract(){
    $cleos set contract eosio /opt/eosio/bin/data-dir/contracts/eosio.system -x 1000 -p eosio
}
deploy_system_contract


set +x







