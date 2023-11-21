
task('draw-random-number', 'Draw a random number')
    .addParam('contractaddress', 'The address of the vrf contract')
    .addParam('naffleid', 'The naffle id')
    .setAction(async (taskArgs, hre) => {
        const contractFactory = await hre.ethers.getContractFactory("NaffleVRF");
        const contractInstance = contractFactory.attach(taskArgs.contractaddress);
        const tx = await contractInstance.drawWinner(taskArgs.naffleid);
    });
