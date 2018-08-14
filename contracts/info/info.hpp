/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */
#pragma once

#include <eosiolib/asset.hpp>
#include <eosiolib/eosio.hpp>

#include <string>

using std::string;

class contracts : public eosio::contract {
public:
    contracts( account_name self ):contract(self){}

    /// @abi action
    void update( account_name    owner,
                 account_name    contract,
                 string          website,
                 string          github,
                 string          src_ipfs,
                 string          image_id,
                 string          build_script );

    /// @abi action
    void remove( account_name owner, account_name contract );

private:

    /// @abi table
    struct info {
        account_name    contract;
        string          website;        // official website.
        string          github;         // project github address.
        string          src_ipfs;       // source c++ code compression package ipfs address.
        string          image_id;       // eosio/eos-dev image id, which used to compile the source code.
        string          build_script;   // build script which use eosio/eos-dev to build the source code.

        uint64_t primary_key()const { return contract; }
    };

    typedef eosio::multi_index<N(info), info> information;
};
