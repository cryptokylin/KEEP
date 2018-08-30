
## token kind contract interface standard

### 1. open source
Token contracts must be open source, if third-party libraries are used, their source code of the corresponding version must be provided.


### 2. actions
this kind of contracts must contain below actions and corresponding parameters:  
``` 
void transfer( account_name from,
               account_name to,
               asset        quantity,
               string       memo );
```

### 3. tables
this kind of contracts must contain below tables, 
and each table must contain at least the corresponding fields and use the same primary_key() listed blow.

the table name of `struct account` must be **accounts** ;  
the table name of `struct currency_stats` must be **stat** ;  

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
