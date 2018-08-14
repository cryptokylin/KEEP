/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */

#include "info.hpp"

void contracts::update(account_name owner,
                       account_name contract,
                       string website,
                       string github,
                       string src_ipfs,
                       string image_id,
                       string build_script) {

    require_auth( owner );

    eosio_assert( website.size() <= 70, "website has more than 70 bytes" );

    information info_t( _self, owner);

    auto existing = info_t.find( contract );

    if ( existing == info_t.end()){
        info_t.emplace( owner, [&]( auto& r ){
            r.contract = contract;
            r.website = website;
            r.github = github;
            r.src_ipfs = src_ipfs;
            r.image_id = image_id;
            r.build_script = build_script;
        });
    } else{
        info_t.modify( existing, 0, [&]( auto& r ) {
            r.contract = contract;
            r.website = website;
            r.github = github;
            r.src_ipfs = src_ipfs;
            r.image_id = image_id;
            r.build_script = build_script;
        });
    }
}

void contracts::remove( account_name owner, account_name contract ) {
    require_auth( owner );
    information info_t( _self, owner);

    auto existing = info_t.find( contract );

    info_t.erase( existing );
}

EOSIO_ABI( contracts, (update)(remove))
