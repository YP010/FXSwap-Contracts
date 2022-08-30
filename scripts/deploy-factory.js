const { ethers } = require('hardhat');

async function deploy() {
   [account] = await ethers.getSigners();
   deployerAddress = account.address;
   console.log(`Deploying contracts using ${deployerAddress}`);

   //Deploy Factory
   const factory = await ethers.getContractFactory('FXSwapV2Factory');
   const factoryInstance = await factory.deploy(deployerAddress);
   await factoryInstance.deployed();

   console.log(`Factory deployed to : ${factoryInstance.address}`);
}

deploy()
   .then(() => process.exit(0))
   .catch((error) => {
      console.error(error);
      process.exit(1);
   });