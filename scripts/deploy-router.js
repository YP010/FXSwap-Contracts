const { ethers } = require('hardhat');

async function deploy() {
   [account] = await ethers.getSigners();
   deployerAddress = account.address;
   console.log(`Deploying contracts using ${deployerAddress}`);

   //Deploy Router (passing Factory and WFX Address)
   const router = await ethers.getContractFactory('FXSwapV2Router02');
   const routerInstance = await router.deploy(
      "0x9E229BE3812228454499FAf771b296bedFe8c904", //factoryInstance.address
      "0x80b5a32E4F032B2a058b4F29EC95EEfEEB87aDcd" //WFX Address
   );
   await routerInstance.deployed();

   console.log(`Router V02 deployed to :  ${routerInstance.address}`);

   //Deploy Multicall (needed for Interface)
   const multicall = await ethers.getContractFactory('Multicall');
   const multicallInstance = await multicall.deploy();
   await multicallInstance.deployed();

   console.log(`Multicall deployed to : ${multicallInstance.address}`);
}

deploy()
   .then(() => process.exit(0))
   .catch((error) => {
      console.error(error);
      process.exit(1);
   });