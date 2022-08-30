### FX Swap Contracts

## Install Dependencies
`yarn`

## Compile Contracts using Hardhat
- Add fxcore network in `hardhat.config.js`:
```
networks: {
    fxcore: {
      url: "https://fx-json-web3.functionx.io:8545",
      chainId: 530,
      accounts: [`0x${privateKey}`]    
    }
}
```
- Add compiler versions `0.5.16` and `0.6.6` in `hardhat.config.js`:
```
    compilers: [
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
```
- npx hardhat compile

## Deploy Contracts using Hardhat
- npx hardhat run deploy-factory.js --network fxcore
- Add the Factory and WFX address as constructor arguments inside `deploy-router.js` deployment script
- npx hardhat run deploy-router.js --network fxcore
