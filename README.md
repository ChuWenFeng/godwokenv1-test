# GodWoken v1
GodWoken v1 添加对以太坊交易签名格式和EIP712格式的支持来更好的兼容Metamask钱包，更好的兼容构建于以太坊智能合约和dapp。EIP712是一个对类型结构数据进行hash和签名的标准，以允许用户在签名时确认要签名的内容是什么，提高用户签名时的安全性。
在polyjuice支持了对eth地址或合约地址到gw_script_hash的一对一映射。
优化了withdrawal-lock，可提高sudt从godwoken提款到ckb的效率。
移除GodWoken对POA的依赖，(猜测)为支持其它共识算法做准备。出块时间可调给了GodWoken更大的灵活性对网络吞吐量做出调整。
GodWoken v1 增强对EVM及其上部署的智能合约或Dapp的兼容性以期望达到完全兼容以太坊生态，降低从以太坊移植到godwoken的成本。降低了在godwoken上部署智能合约和使用跨链的成本。

## Quick start godwoken v1
```sh
git clone -b compatibility-changes --depth=1 https://github.com/RetricSu/godwoken-kicker.git kicker
cd kicker
make init
make start
```

## Run contract test
```sh
npx hardhat test --network gw_devnet_v1
```

