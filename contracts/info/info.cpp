/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */

#include "info.hpp"

void contracts::createupdate( account_name contract,
                              string website,
                              string logo_256,
                              string brief_intro,
                              string github,
                              string white_paper,
                              string src_zip,
                              string extension) {

    require_auth( contract );

    eosio_assert( website.size() <= 100, "website has more than 100 bytes" );
    eosio_assert( logo_256.size() <= 100, "logo url has more than 100 bytes" );
    eosio_assert( brief_intro.size() <= 500, "brief_intro has more than 500 bytes" );
    eosio_assert( github.size() <= 100, "github url has more than 100 bytes" );
    eosio_assert( white_paper.size() == 46, "white_paper ipfs address must be 46 bytes" );
    eosio_assert( src_zip.size() == 46, "src_zip ipfs address must be 46 bytes" );
    eosio_assert( extension.size() <= 500, "extension has more than 500 bytes" );

    information info_t( _self, _self);

    auto existing = info_t.find( contract );

    if ( existing == info_t.end()){
        info_t.emplace( contract, [&]( auto& r ){
            r.contract = contract;
            r.website = website;
            r.logo_256 = logo_256;
            r.brief_intro = brief_intro;
            r.github = github;
            r.white_paper = white_paper;
            r.src_zip = src_zip;
            r.extension = extension;
            r.version = 1;
        });
    } else{
        info_t.modify( existing, 0, [&]( auto& r ) {
            r.website = website;
            r.logo_256 = logo_256;
            r.brief_intro = brief_intro;
            r.github = github;
            r.white_paper = white_paper;
            r.src_zip = src_zip;
            r.extension = extension;
            r.version += 1;
        });
    }
}

void contracts::remove( account_name contract ) {

    require_auth( contract );

    information info_t( _self, _self);

    auto existing = info_t.find( contract );
    info_t.erase( existing );
}

EOSIO_ABI( contracts, (createupdate)(remove))
