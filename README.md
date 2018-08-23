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
压缩命令统一为`zip ${contract_folder}.zip ${contract_folder}`，即压缩包名字为合约文件夹名字加".zip"后缀，因此第三方可以统一用`unzip ${contract_folder}.zip`命令进行解压。  
另外，合约中主cpp文件名需要和合约文件夹同名。  
为了验证链上wasm文件是对应的c++源文件编译得到的，在build.sh中必须使用docker进行编译，我们建议统一使用镜像 `eosio/eos-dev` 进行编译。  
build.sh脚本中必须包含`image_name`，`image_version`，`image_id`，以方便第三方进行自动化处理，
并且 `docker run` 命令中必须使用 `image_id` 指定镜像，不能使用`image_name:image_version`的方式，
因为可以更新镜像而不改变版本号，只有image_id能唯一确定具体的镜像。  
`docker run` 命令之后可以再增加对 abi 文件修改的命令。  

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
管理此注册信息的合约账户为`cryptokylin1`（EOS主网）。  
您也可以在Kylin测试网进行测试，Kylin测试网上合约账户是`contracts111`。  
此合约有两个方法:createupdate 和 remove。  

createupdate 用于创建记录，若记录已存在，则更新该记录，参数如下   

| 名称  | 类型  | 示例  | 限制 | 说明 |
|---|---|---|---|---|
| contract  | account_name  | contract1111                        | <=12个字符  |部署合约的账户 |
| website   | string  | `https://www.website.com`                 | <=50个字符  |  |
| logo      | string  | `https://www.website.com/logo.png`        | <=100个字符 |  |
| whitepaper| string  | `https://www.website.com/whitepaper.pdf`  | <=100个字符 |  |
| github    | string  | `https://github.com/repo/project`         | <=100个字符 |  |
| src_zip   | string  | `QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7` | <=100个字符 |  |
| memo      | string  |                                           | <=300个字符 | 一段文字 |


示例命令
```
# register project contract information to cryptokylin1
cleos push action cryptokylin1 createupdate '["contract1111",\
    "https://www.website.com", "https://www.website.com/logo.png", \
    "https://www.website.com/whitepaper.pdf","https://github.com/repo/project", \
    "QmdTg15kLsDzHHPAH5mdyhXTPJoAeuGyYbb8imKc54h6m7","memo"]' -p contract1111@active
    
# get registered contract information.   
cleos get table cryptokylin1 cryptokylin1 info -L contract1111
```

remove 用于删除一条记录，参数如下 

| 名称  | 类型  | 示例  | 限制 | 说明 |
|---|---|---|---|---|
| contract  | account_name  | contract1111  | <=12个字符  |部署合约的账户 |

示例命令
```
cleos push action cryptokylin1 remove '["contract1111"]' -p contract1111@active
```

### 2 包含适当的李嘉图合约

#### 2.1 概述

**重要性：**

[Thomas Cox：第XI条 - EOS.IO宪法草案 - 开发者和智能合同许可](https://forums.eosgo.io/discussion/747/article-xi-v0-3-0-draft-eos-io-constitution-developers-and-smart-contract-licenses)

> **Purpose**
>
> *Defines when a Member is a Developer. Establishes obligation of a Developer to provide a License and one or more Ricardian Contracts, and to name an Arbitration Forum for their software.*
> 

**目的**

定义什么程度的成员才是开发人员。设定开发人员有义务提供许可证、李嘉图合约（一个或多个），并为他们的开发软件任命一个仲裁法庭。

> [Article VII - Open Source](https://github.com/EOS-Mainnet/governance/blob/master/eosio.system/eosio.system-clause-constitution-rc.md#article-vii---open-source)

>  **Article VII - Open Source**

>  Each Member who makes available a smart contract on this blockchain shall be a Developer. Each Developer shall offer their smart contracts via a free and open source license, and each smart contract shall be documented with a Ricardian Contract stating the intent of all parties and naming the Arbitration Forum that will resolve disputes arising from that contract.
>
>
>
>

**第七条 - 开源**

每个在此区块链上提供智能合约的成员均为开发人员，每个开发者都应提供免费的，开源的许可证的智能合约，每份智能合约应记录在一分描述各方意图的李嘉图协议中，名命名仲裁论坛来解决合同引起的争议


**李嘉图协议使用过程**

参考：[ What is a Ricardian Contract? eosio.stackexchange ](https://eosio.stackexchange.com/questions/1054/what-is-a-ricardian-contract/1064)

![](https://i.imgur.com/2J2Lqoy.png)


http://iang.org/papers/ricardian_contract.html

#### 2.2 样本

[Hello Ricardian Contract](https://github.com/EOSIO/eos/blob/master/contracts/hello/hello_rc.md)

```
"ricardian_clauses": [{
      "id": "Warranty",
      "body": "WARRANTY. The invoker of the contract action shall uphold its Obligations under this Contract in a timely and workmanlike manner, using knowledge and recommendations for performing the services which meet generally acceptable standards set forth by EOS.IO Blockchain Block Producers.\n\n"
    },{
      "id": "Default",
      "body": "DEFAULT. The occurrence of any of the following shall constitute a material default under this Contract: \n\n"
    },{
      "id": "Remedies",
      "body": "REMEDIES. In addition to any and all other rights a party may have available according to law, if a party defaults by failing to substantially perform any provision, term or condition of this Contract, the other party may terminate the Contract by providing written notice to the defaulting party. This notice shall describe with sufficient detail the nature of the default. The party receiving such notice shall promptly be removed from being a Block Producer and this Contract shall be automatically terminated. \n  \n"
    },{
      "id": "Force Majeure",
      "body": "FORCE MAJEURE. If performance of this Contract or any obligation under this Contract is prevented, restricted, or interfered with by causes beyond either party's reasonable control (\"Force Majeure\"), and if the party unable to carry out its obligations gives the other party prompt written notice of such event, then the obligations of the party invoking this provision shall be suspended to the extent necessary by such event. The term Force Majeure shall include, without limitation, acts of God, fire, explosion, vandalism, storm or other similar occurrence, orders or acts of military or civil authority, or by national emergencies, insurrections, riots, or wars, or strikes, lock-outs, work stoppages, or supplier failures. The excused party shall use reasonable efforts under the circumstances to avoid or remove such causes of non-performance and shall proceed to perform with reasonable dispatch whenever such causes are removed or ceased. An act or omission shall be deemed within the reasonable control of a party if committed, omitted, or caused by such party, or its employees, officers, agents, or affiliates. \n  \n"
    },{
      "id": "Dispute Resolution",
      "body": "DISPUTE RESOLUTION. Any controversies or disputes arising out of or relating to this Contract will be resolved by binding arbitration under the default rules set forth by the EOS.IO Blockchain. The arbitrator's award will be final, and judgment may be entered upon it by any court having proper jurisdiction. \n  \n"
    },{
      "id": "Entire Agreement",
      "body": "ENTIRE AGREEMENT. This Contract contains the entire agreement of the parties, and there are no other promises or conditions in any other agreement whether oral or written concerning the subject matter of this Contract. This Contract supersedes any prior written or oral agreements between the parties. \n\n"
    },{
      "id": "Severability",
      "body": "SEVERABILITY. If any provision of this Contract will be held to be invalid or unenforceable for any reason, the remaining provisions will continue to be valid and enforceable. If a court finds that any provision of this Contract is invalid or unenforceable, but that by limiting such provision it would become valid and enforceable, then such provision will be deemed to be written, construed, and enforced as so limited. \n\n"
    },{
      "id": "Amendment",
      "body": "AMENDMENT. This Contract may be modified or amended in writing by mutual agreement between the parties, if the writing is signed by the party obligated under the amendment. \n\n"
    },{
      "id": "Governing Law",
      "body": "GOVERNING LAW. This Contract shall be construed in accordance with the Maxims of Equity. \n\n"
    },{
      "id": "Notice",
      "body": "NOTICE. Any notice or communication required or permitted under this Contract shall be sufficiently given if delivered to a verifiable email address or to such other email address as one party may have publicly furnished in writing, or published on a broadcast contract provided by this blockchain for purposes of providing notices of this type. \n"
    },{
      "id": "Waiver of Contractual Right",
      "body": "WAIVER OF CONTRACTUAL RIGHT. The failure of either party to enforce any provision of this Contract shall not be construed as a waiver or limitation of that party's right to subsequently enforce and compel strict compliance with every provision of this Contract. \n\n"
    },{
      "id": "Arbitrator's Fees to Prevailing Party",
      "body": "ARBITRATOR'S FEES TO PREVAILING PARTY. In any action arising hereunder or any separate action pertaining to the validity of this Agreement, both sides shall pay half the initial cost of arbitration, and the prevailing party shall be awarded reasonable arbitrator's fees and costs.\n  \n"
    },{
      "id": "Construction and Interpretation",
      "body": "CONSTRUCTION AND INTERPRETATION. The rule requiring construction or interpretation against the drafter is waived. The document shall be deemed as if it were drafted by both parties in a mutual effort. \n  \n"
    }
  ],
```



#### 2.3 权力和义务

若在智能合约中包含李嘉图合约，否则默认会执行当前版本的宪法

#### 2.4 相关资料

若想更多了解李嘉图合约，可参考有EOShenzhen翻译的相关材料:

[关于李嘉图协议的hello合约](shorturl.at/biGM9)



### 3. 通过第三方安全团队的审核
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



### 4. resign权限  
项目方自行决定是否resign权限，以及将权限resign给谁。 

#### 4.1 完全放弃修改权限

如果想彻底放弃升级权限，则resign权限给 EOS1111111111111111111111111111111114T1Anm，命令如下:
``` 
cleos push action eosio updateauth '{"account": "${account}", "permission": "active", "parent": "owner",\
    "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], \
    "waits": [], "accounts": []}}' -p ${account}@active
    
cleos push action eosio updateauth '{"account": "${account}", "permission": "owner", "parent": "",\
    "auth":{"threshold": 1, "keys": [{"key":"EOS1111111111111111111111111111111114T1Anm","weight":1}], \
    "waits": [], "accounts": []}}' -p ${account}@owner      
```

#### 4.2 把修改权限交给producer

```
cleos set account permission $CONTRACT active '{ "threshold": 1, "keys": [{ "key": "$PUBLIC_KEY_OF_CONTRACT", "weight": 1 }], "accounts": [{ "permission": { "actor":"$CONTRACT","permission":"eosio.prods" }, "weight":1 }] }' active -p $CONTRACT

cleos set account permission $CONTRACT owner '{ "threshold": 1, "keys": [{ "key": "$PUBLIC_KEY_OF_CONTRACT", "weight": 1 }], "accounts": [{ "permission": { "actor":"$CONTRACT","permission":"eosio.prods" }, "weight":1 }] }' owner -p $CONTRACT
```



### 5. 接口规范

目前接口规范正在逐步制定中，我们也真诚希望任何对此感兴趣的开发者贡献力量，如下是部分接口规范。

[token类合约接口规范](https://github.com/cryptokylin/KEEP/blob/master/interfaces/token.md)



