# eosip-contract

本文目的是提供EOS智能合约上线流程的最佳实践，促进项目方的智能合约通过各个交易所、钱包、区块链浏览器的认可并公示。

为达到上述目的，合约应尽量满足如下条件（Checklist）：
1. 开源  
   - 需提供项目的github地址
2. 可验证  
   - 将合约源文件( *.hpp, *.cpp )打包，上传到ipfs网络，并记录ip地址  
   - 提供`git commit`编号
   - 提供其具体使用的`eosio/eos-dev`版本号和image id。
   - 提供编译命令。
3. 通过第三方安全团队的审核
   审计内容至少包括
   - 溢出审计
   - 权限控制审计（是否有超级权限，地址锁定，控制转动额度）
4. resign权限  
   项目方自行决定是否resign权限，以及将权限resign给谁。  
   如果想彻底放弃升级权限，则resign权限给 EOS1111111111111111111111111111111114T1Anm
5. 项目方是否公开白皮书
6. 合约实现是否与白皮书一致  
7. 将如下信息注册到`contracts111`合约。
   - 合约账户
   - 项目官网
   - 白皮书
   - 项目github地址
   - 源文件压缩包ipfs地址
   - eos-dev image id
   - 编译脚本ipfs地址


#### resign
``` 
cleos push action eosio updateauth '{"account": "${account}", "permission": "active", "parent": "owner", "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], "waits": [], "accounts": []}}' -p ${account}@active
cleos push action eosio updateauth '{"account": "${account}", "permission": "owner", "parent": "",       "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], "waits": [], "accounts": []}}' -p ${account}@owner      
```

#### 注册合约信息
```
cleos push action contracts111 update '["<owner account>","<contract account>", "<official website>", "<github address>","<source file ipfs address>","<docker image id>","build script ipfs address"]' -p <owner account>@active
```