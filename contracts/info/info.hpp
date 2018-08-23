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
                      string logo_256,
                      string brief_intro,
                      string github,
                      string white_paper,
                      string src_zip,
                      string extension);

    /// @abi action
    void remove( account_name contract );

private:

    /// @abi table
    struct info {
        account_name    contract;       // contract account.
        string          website;        // official website.
        string          logo_256;       // 256 * 256 logo pic link.
        string          brief_intro;    // project's brief introduction.
        string          github;         // project github address.
        string          white_paper;    // white paper link.
        string          src_zip;        // source code and build.sh compression package address.
        string          extension;      // extended information.
        uint32_t        version;

        uint64_t primary_key()const { return contract; }
    };

    typedef eosio::multi_index<N(info), info> information;
};
