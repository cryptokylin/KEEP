#!/usr/bin/env bash

contract='info'

# image name: eosio/eos-dev
# image version: v1.1.1
# image id: 8fa0988c81cc
docker run --rm -v `pwd`:/scts 8fa0988c81cc bash -c "cd /scts \
        && eosiocpp -o ${contract}.wast ${contract}.cpp \
        && eosiocpp -g ${contract}.abi ${contract}.cpp"

jq 'del(.____comment)'  ${contract}.abi | \
sed 's/"type": "name"/"type": "account_name"/g' | \
jq ' .types = [{"new_type_name":"account_name","type": "name"}]'  > tmp.abi && mv tmp.abi  ${contract}.abi