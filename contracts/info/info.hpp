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
    void createupdate(account_name contract,
                     string website,
                     string logo,
                     string whitepaper,
                     string github,
                     string src_zip,
                     string memo);

    /// @abi action
    void remove( account_name contract );

private:

    /// @abi table
    struct info {
        account_name    contract;
        string          website;        // official website.
        string          logo;           // logo link.
        string          whitepaper;     // whitepaper link.
        string          github;         // project github address.
        string          src_zip;        // c++ source code and build.sh compression package address.
        string          memo;

        uint64_t primary_key()const { return contract; }
    };

    typedef eosio::multi_index<N(info), info> information;
};
