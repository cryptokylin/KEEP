/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */

#include "info.hpp"

void contracts::createupdate( account_name    owner,
                        account_name    contract,
                        string          website,
                        string          logo,
                        string          whitepaper,
                        string          github,
                        string          src_zip,
                        string          memo) {

    require_auth( owner );

    eosio_assert( website.size() <= 50, "website has more than 70 bytes" );
    eosio_assert( logo.size() <= 100, "logo url has more than 100 bytes" );
    eosio_assert( whitepaper.size() <= 100, "whitepaper url has more than 100 bytes" );
    eosio_assert( github.size() <= 100, "github url has more than 100 bytes" );
    eosio_assert( src_zip.size() <= 100, "src_zip url has more than 100 bytes" );
    eosio_assert( memo.size() <= 300, "memo has more than 300 bytes" );

    information info_t( _self, owner);

    auto existing = info_t.find( contract );

    if ( existing == info_t.end()){
        info_t.emplace( owner, [&]( auto& r ){
            r.contract = contract;
            r.website = website;
            r.logo = logo;
            r.whitepaper = whitepaper;
            r.github = github;
            r.src_zip = src_zip;
            r.memo = memo;
        });
    } else{
        info_t.modify( existing, 0, [&]( auto& r ) {
            r.contract = contract;
            r.website = website;
            r.logo = logo;
            r.whitepaper = whitepaper;
            r.github = github;
            r.src_zip = src_zip;
            r.memo = memo;
        });
    }
}

void contracts::remove( account_name owner, account_name contract ) {

    require_auth( owner );

    information info_t( _self, owner);

    auto existing = info_t.find( contract );
    info_t.erase( existing );
}

EOSIO_ABI( contracts, (createupdate)(remove))
