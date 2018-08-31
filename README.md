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

createupdate 用于创建记录，若记录已存在，则更新该记录，参数如下：   

| name  | type  | example  | limit | notes |
|---|---|---|---|---|
| contract    | account_name  | `contract1111`                                | required               |  |
| website     | string  | `https://www.website.com`                           | required, 100 char max |  |
| logo_256    | string  | `https://www.website.com/logo_256.png`              | required, 100 char max |  |
| brief_intro | string  | `project's brief introduction`			          | required, 500 char max |  |
| github      | string  | `https://github.com/repo/project`                   | required, 100 char max |  |
| white_paper | string  | `QmdjFPtN93VkrCVsQ8YuAeubUCPKx8sozDzoCPsbVycRZC`    | required, == 46 char   |  |
| src_zip     | string  | `QmV6EiBVyFCXSM3FJqRVJrQwUxLE5fwDjydusbxxJgQcj9`    | required, == 46 char   |  |
| extension   | string  | see below       | optional, 500 char max |  |


extension 字段是一个以`|`分割的包含多个`key=value`的字符串，用于包含附加信息，项目方应尽量提供以下信息：

| name  |  example  |  notes |
|---|---|---|
| contract 	| `contractname`		                 |  |
| telegram 	| `https://t.me/cryptokylin`		     |  |
| steemit 	| `https://steemit.com/@eosio`	         |  |
| twitter 	| `https://twitter.com/EOS_io`	         |  |
| wechat 	| `EOSIO-foo`				  		     |  |


示例命令
```
# register project contract information to cryptokylin1

contract=contract1111
website=https://www.website.com
logo_256=https://www.website.com/logo_256.png
brief_intro="brief intro"
github="https://github.com/repo/project"
white_paper="QmdjFPtN93VkrCVsQ8YuAeubUCPKx8sozDzoCPsbVycRZC"
src_zip="QmV6EiBVyFCXSM3FJqRVJrQwUxLE5fwDjydusbxxJgQcj9"
telegram="https://t.me/cryptokylin"
steemit=https://steemit.com/@eosio
twitter="https://twitter.com/EOS_io"
wechat="EOSIO-foo"

extension="telegram=${telegram}|steemit=${steemit}|twitter=${twitter}|wechat=${wechat}"
str="[ \"${contract}\",\"${website}\",\"${logo_256}\",\"${brief_intro}\",\"${github}\",\"${white_paper}\",\"${src_zip}\",\"${extension}\" ]"

cleos push action ${accountaddr} createupdate "$str" -p contract1111@active

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

##### 2.1.1 和宪法的关系

[Thomas Cox：第XI条 - EOS.IO宪法草案 - 开发者和智能合同许可](https://forums.eosgo.io/discussion/747/article-xi-v0-3-0-draft-eos-io-constitution-developers-and-smart-contract-licenses)

> **Purpose**
>
> *Defines when a Member is a Developer. Establishes obligation of a Developer to provide a License and one or more Ricardian Contracts, and to name an Arbitration Forum for their software.*
> 

**目的**

定义什么程度的成员才是开发人员。设定开发人员有义务提供许可证、李嘉图合约（一个或多个），并为他们的开发软件任命一个仲裁法庭。




>  **[Article VII - Open Source](https://github.com/EOS-Mainnet/governance/blob/master/eosio.system/eosio.system-clause-constitution-rc.md#article-vii---open-source)**

>  Each Member who makes available a smart contract on this blockchain shall be a Developer. Each Developer shall offer their smart contracts via a free and open source license, and each smart contract shall be documented with a Ricardian Contract stating the intent of all parties and naming the Arbitration Forum that will resolve disputes arising from that contract.


**第七条 - 开源**

每个在此区块链上提供智能合约的成员均为开发人员，每个开发者都应提供免费的，开源的许可证的智能合约，每份智能合约应记录在一分描述各方意图的李嘉图协议中，名命名仲裁论坛来解决合同引起的争议

##### 2.1.2 原理

从法律合同到机器代码
在，我们将法律合同和机器代码视为一个连续统一体。 在一个极端的法律文本，纯粹用于人类消费，在另一个，计算机可执行机器代码。 在它们之间是不同的表示和抽象，在灵活性，有意模糊性，计算严谨性以及法律或计算机专家的创作和理解的简易性之间进行不同的权衡。

当一个人在连续体中向右移动（朝向链码）时，人们朝着法律文本的结构化表示移动，最终通过编译器到达可以在计算机芯片的中央处理单元（CPU）上执行的机器代码。

李嘉图条款描述了特定行为的预期结果。 它也可用于在发件人和合同之间建立条款。





##### 2.1.3 李嘉图协议使用过程

参考：[ What is a Ricardian Contract? eosio.stackexchange ](https://eosio.stackexchange.com/questions/1054/what-is-a-ricardian-contract/1064)

![](https://i.imgur.com/2J2Lqoy.png)


http://iang.org/papers/ricardian_contract.html

#### 2.2 格式和样本

##### 2.2.1  `ricardian_clauses` 李嘉图条款
- 位于`合约名.abi`
- 作为单独的一个第一级对象
- 作为通用条款，用于指定智能合约相关方的权责

```
"version": “”,
"types": [],
"structs": [],
"actions": [],
"ricardian_clauses": [],
"abi_extensions": []
```

>  例子: [hello.abi](https://github.com/EOSIO/eos/blob/master/contracts/hello/hello.abi)

```
"ricardian_clauses": [{
      "id": "保修",
      "body": "保修.保修。本合同的调用方应及时、熟练地履行本合同项下的义务，EOS.IO 的Blockchain Block Producers应当运用知识和建议来执行符合EOS规定的普遍可接受的服务标准。\n\n"
    },{
       "id": "不做恶"
       "body": "承诺不使用合约漏洞获取利益或损害其他人的合法权益，若发生此类情况，相关方愿意承担相当责任。 \n\n"
	},{
       "id": "信息披露"
       "body": "承诺公开的源码与链上部署的二进制代码保持一致 \n\n"
	},{
      "id": "名称",
      "body": "违约。下列任何一项的发生均构成本合同项下的重大违约: \n\n"
    },{
      "id": "补救措施",
      "body": "补救措施。除依法享有的任何和所有其他权利外，如果一方因未充分履行本合同的任何条款、期限或条件而违约，另一方可以向违约方发出书面通知，终止本合同。本通知应充分详细说明违约的性质。收到该通知的一方应立即被解除该合同，本合同自动终止。\n\n"
    },{
      "id": "不可抗力",
      "body": "不可抗力。如果本合同或本合同项下的任何义务因任何一方无法合理控制的原因而被阻止、限制或干扰(“不可抗力”)，如果一方未能履行其义务，另一方立即书面通知该等事件，则该条款援引的一方的义务应在该事件所必要的范围内暂停。“不可抗力”一词应包括但不限于上帝、火灾、爆炸、故意破坏、风暴或其他类似的事件、命令或军事或民事当局行为，或国家紧急情况、叛乱、暴动或战争、罢工、停工、停工或供应失败。被免除方应在情况下采取合理努力，避免或消除不履行的原因，并在消除或停止不履行的情况下，以合理的速度进行履行。如果一方或其雇员、官员、代理人或关联方犯下、遗漏或造成的行为或不作为，应被视为在该方的合理控制范围内。 \n  \n"
    },{
      "id": "纠纷解决",
      "body": "解决争议的方式。因本合同而产生的或与本合同有关的任何争议或异议，均由本协议规定的EOS.IO Blockchain规则进行仲裁解决。仲裁员的裁决是终局的，任何有适当管辖权的法院都可以作出判决。\n\n"
    },{
      "id": "整个协议",
      "body": "整个协议。本合同包含双方的全部协议，无论任何其他协议，不论是口头的还是书面的及其他承诺或条件。本合同取代双方之前的任何书面或口头协议。 \n\n"
    },{
      "id": "可分割性",
      "body": "可分割性。如果本合同的任何条款因任何原因被认为无效或不可执行，其余条款将继续有效和可执行。如果法院发现本合同的任何条款无效或不可执行，但通过限制该条款，该条款将变得有效和可执行，那么该条款将被视为书面的、解释性的和有限执行的。\n\n"
    },{
      "id": "修正案",
      "body": "修正案。本合同经双方协商一致，可以以书面形式修正或修改。\n\n"
    },{
      "id": "适用法律",
      "body": "适用法律。本合同应按照衡平法原则解释。 \n\n"
    },{
      "id": "通知",
      "body": "通知。任何通知或通信要求或允许在本合同项下应当充分的可验证的电子邮件地址或递送等其他一方书面公开提供的电子邮件地址,或者通过blockchain发表为提供这种类型的通知在广播合同上。 \n"
    },{
      "id": "放弃合同权利",
      "body": "放弃合同权利。任何一方未能执行本合同的任何条款，不应被解释为放弃或限制该方随后执行并强制严格遵守本合同各项条款的权利。 \n\n"
    },{
      "id": "仲裁员对胜诉方的费用",
      "body": "仲裁员向胜诉方支付的费用。在本协议项下产生的任何诉讼或与本协议有效性有关的任何单独诉讼中，双方应支付仲裁初始成本的一半，胜诉方应获得合理的仲裁员费用和成本。\n\n"
    },{
      "id": "结构和解释",
      "body": "结构和解释。要求对drafter进行构造或解释的规则被取消。该文件应视为双方共同起草的文件。 \n\n"
    },{
        "id": "纠纷解决",
        "body": "因本合同引起的或与本合同有关的任何争议，应根据EOS核心仲裁论坛的争议解决规则，由一名或多名根据EOS章程规则指定的仲裁员最终解决。 \n \n"
    }
  ],
```

##### 2.2.2 和action 执行方的约定：`ricardian_contract`
- 位于`合约名.abi`
- 作为附属object定义在`actions` 中
- 用于指定action执行方的的权责

```
{
  "name": "XXX", 			//合同中定义的action名称
  "type": "XXX", 			//ABI中描述的隐式struct的名称
  "ricardian_contract": "" 	//与此操作关联的可选ricardian 条款，用于描述本action预期的功能。
}
```



##### 2.2.3 `<智能合约名称>-<Action名称>-rc.md`

- markdown形式的单独文件
- 对 abi中的每一条action的 ricardian_contract，独立创建一个markdown 文档

例子参考：[eosio.wps.regproposer-rc.md](https://github.com/EOS-BP-Developers/wps-backend/blob/master/contracts/eosio.wps/abi/eosio.wps-regproposer-rc.md)

> `{{regproposer}}`行动的目的是将一个帐户登记为向EOS Worker Proposal System提交提案的责任方。
> 
> 我，`{{提议者}`，在此证明只提交我个人作为团队成员参与的建议。
> 
> 我，`{提议者}}`，同意只提交旨在使EOS生态系统受益的建议。
> 
> 我，`{{提议者}}`，承诺提供关于我将提交给EOS工人建议系统的建议的正确和真实的信息。如果我得知我可能在提案中提供了任何不正确的信息，或者如果我提供了任何信息，我将尽快更新该提案，只要我有能力这样做。
> 
> 我，`{{提交者}}`，同意并承诺将我的建议可能收到的任何资金分发给有关各方，如我的建议书中所概述的那样。我证明我的建议包括了所有现有利益的有关细节，并声明了任何和所有利益冲突。
> 
> 我，`{{提议者}}`，在此证明我提供的关于我自己的信息是准确的。
> 
> 我，`{{提议者}}`，同意我在将来提交的任何建议都符合标准提案清单的标准，这是我所知的。
> 
> 如果我的建议不符合公开发表的建议清单，同意我的建议可能被否决。
> 
> 如果我不满足任何或一些在建议路线图中概述的可交付成果/里程碑，我同意我的建议可能会被否决。



##### 2.2.4 `<智能合约名称>_rc.md`

参考 [hello_rc.md](https://github.com/EOSIO/eos/blob/master/contracts/hello/hello_rc.md)

- markdown 版本的单独文件 
- 现行  `ricardian_clauses` 李嘉图条款
- 每一个智能合约只有一个ricardian_clauses



#### 2.3 建议文件位置及结构

```
- <智能合约名称>
	- include
    - src
    - abi
        - 智能合约.abi
        - <智能合约名称>_rc.md
        - <智能合约名称>-<Action名称1>-rc.md
        - <智能合约名称>-<Action名称2>-rc.md
        - <智能合约名称>-<Action名称3>-rc.md
    - CMakeLists.txt
    - ReadMe.md
```

> 参考: https://github.com/EOSIO/eosio.contracts




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



