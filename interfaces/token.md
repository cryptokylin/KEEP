
## token kind contract interface standard

### 1. open source
Token contracts must be open source, if third-party libraries are used, their source code of the corresponding version must be provided with your contract's source code.

### 2. `asset` data struct
  - In token contracts, you must use `asset` data structure which defined in [asset.hpp](https://github.com/EOSIO/eos/blob/master/contracts/eosiolib/asset.hpp) to represent user's token. you can't use your custom defined data structure to represent user's token, because this leads to a lot of incompatibility.  
  - symbol name must be capitalized english alphabet, and should not be longer than 7 characters.
  
### 2. actions
Token contracts must contain below actions and corresponding parameters:  

  - transfer  
    All assets related to the transfer must be checkable on the chain, such as asset transfer, transaction fee costs, etc.
    ``` 
    void transfer( account_name from,
                   account_name to,
                   asset        quantity,
                   string       memo );
    ```

### 3. tables
token contracts must contain below tables, 
and each table must contain at least the corresponding fields and use the same primary_key() listed blow.

   - the table name of `struct account` must be **accounts** , such as defined in [eosio.token.hpp](https://github.com/EOSIO/eos/blob/master/contracts/eosio.token/eosio.token.hpp#L54)  
   - table `accounts`'s code must be `_self` and scope must be the token balance `owner`, such as defined in [eosio.token.cpp](https://github.com/EOSIO/eos/blob/master/contracts/eosio.token/eosio.token.cpp#L88)  
   - the table name of `struct currency_stats` must be **stat**, such as defined in [eosio.token.hpp](https://github.com/EOSIO/eos/blob/master/contracts/eosio.token/eosio.token.hpp#L55)  
   - table `stat`'s code must be `_self` and scope must be the token symbol name `sym`, such as defined in [eosio.token.cpp](https://github.com/EOSIO/eos/blob/master/contracts/eosio.token/eosio.token.cpp#L20)  
  
  table structs
  ``` 
  struct account {
      asset    balance;

      uint64_t primary_key()const { return balance.symbol.name(); }
  };

  struct currency_stats {
      asset          supply;
      asset          max_supply;
      account_name   issuer;

      uint64_t primary_key()const { return supply.symbol.name(); }
  };

  ```
### 4. advice
It's better that token contracts be independent of business logic contracts. when a business logic contract need token operation, it should send action to token contract's abi interface to transfer token.
