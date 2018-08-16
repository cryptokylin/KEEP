# eosip-contract

本文目的是提供EOS智能合约上线流程的最佳实践，促进项目方的智能合约通过各个交易所、钱包、区块链浏览器的认可并公示。

为达到上述目的，合约应满足如下条件（Checklist）：

### 1. 注册基本信息
基本信息包括:
- 合约账户
- 项目官网
- logo连接 
- 白皮书连接 
- github地址
- 合约文件压缩包地址 
- 备注信息

说明:
1. 按照EOS账户命名规则，合约账户长度为1-12个字符，字符范围为a-z,1-5和小数点。  
2. logo连接用于方便第三方公示网站展示项目logo。  
3. 合约文件压缩包中除包含c++源文件外，还必须包含一个脚本文件`build.sh`，此脚本文件用于第三方下载此压缩包并解压后，可以快速编译此合约。  
压缩命令统一为`zip contract.zip ${contract_folder}`，这样第三方可以统一用`unzip ${contract_folder}`命令进行解压。  
为了验证链上wasm文件是对应的c++源文件编译得到的，在build.sh中必须使用docker进行编译，我们建议统一使用镜像 eosio/eos-dev 进行编译。  
build.sh脚本中必须包含image_name，image_version，image_id，以方便第三方进行自动化处理，
并且 `docker run` 命令中必须使用 `image_id` 指定镜像，不能使用image_name:image_version的方式，
因为可以更新镜像而不改变版本号，只有image_id能唯一确定具体的镜像。  
docker run 命令之后可以再增加对 abi文件修改的命令。  

build.sh模板如下
``` 
image_name=eosio/eos-dev
image_version=v1.1.1
image_id=8fa0988c81cc
contract='info'
docker run --rm -v `pwd`:/scts ${image_id} bash -c "cd /scts \
        && eosiocpp -o ${contract}.wast ${contract}.cpp \
        && eosiocpp -g ${contract}.abi ${contract}.cpp"
```

项目方可以将合约文件压缩包放置在 github、自己的官网、IPFS网络，以方便第三方获取并进行验证。

4. 在合约中注册、更新、删除信息
管理此注册信息的合约账户为contracts111，此合约有两个方法:createupdate 和 remove
createupdate 用于创建记录，若记录已存在，则更新该记录，参数如下   

| 名称  | 类型  | 示例  | 限制 | 说明 |
|---|---|---|---|---|
| owner     | account_name  | teamleader11                        | <=12个字符  | 本条记录的管理者 |
| contract  | account_name  | contract1111                        | <=12个字符  |部署合约的账户 |
| website   | string  | `https://www.website.com`                 | <=50个字符  |  |
| logo      | string  | `https://www.website.com/logo.png`        | <=100个字符 |  |
| whitepaper| string  | `https://www.website.com/whitepaper.pdf`  | <=100个字符 |  |
| github    | string  | `https://github.com/repo/project`         | <=100个字符 |  |
| src_zip   | string  | 见下文                                     | =46个字符 |  |
| memo      | string  |                                           | <=300个字符 | 一段文字 |


src_zip 示例：  
如果压缩包在官网: `例如: https://www.website.com/src.zip`  
如果在github，则需要注意是raw文件地址: `例如: https://raw.githubusercontent.com/account/repo/master/src.zip`  
如果再IPFS网络:`例如: QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7`  

示例命令
```
cleos push action contracts111 createupdate '["teamleader11","contract1111",\
    "https://www.website.com", "https://www.website.com/logo.png", \
    "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", \
    "https://www.website.com/src.zip","memo"]' -p teamleader11@active
```

remove 用于删除一条记录，参数如下 
  
| 名称  | 类型  | 示例  | 限制 | 说明 |
|---|---|---|---|---|
| owner     | account_name  | teamleader11  | <=12个字符 | 本条记录的管理者 |
| contract  | account_name  | contract1111  | <=12个字符  |部署合约的账户 |

示例命令
```
cleos push action contracts111 remove '["teamleader11","contract1111"]' -p teamleader11@active
```

### 2. 通过第三方安全团队的审核
1. 溢出审计
2. 权限控制审计
    - 权限漏洞审计
    - 权限过大审计
3. 安全设计审计
    - 硬编码地址安全
    - 显现编码安全
    - 异常校验审计
    - 类型安全审计
4. 性能优化审计
5. 设计逻辑审计


### 3. resign权限  
项目方自行决定是否resign权限，以及将权限resign给谁。 
 
如果想彻底放弃升级权限，则resign权限给 EOS1111111111111111111111111111111114T1Anm，命令如下:
``` 
cleos push action eosio updateauth '{"account": "${account}", "permission": "active", "parent": "owner",\
    "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], \
    "waits": [], "accounts": []}}' -p ${account}@active
    
cleos push action eosio updateauth '{"account": "${account}", "permission": "owner", "parent": "",\
    "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], \
    "waits": [], "accounts": []}}' -p ${account}@owner      
```

### 4. 接口规范
目前接口规范正在逐步制定中，我们也真诚希望任何对此感兴趣的开发者贡献力量，如下是部分接口规范。

[token类合约接口规范](https://github.com/cryptokylin/KEEP/blob/master/interfaces/token.md)