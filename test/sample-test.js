const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ExampleContract", function () {

  let exampleContract;

  this.beforeAll(async () => {
    const ExampleContract = await ethers.getContractFactory("ExampleContract");
    exampleContract = await ExampleContract.deploy();
    await exampleContract.deployed();
  });

  it("Should get an item", async function () {


    const price = await exampleContract.price();

    expect(
      await exampleContract.mint(8764, {
        value: price,
      })
    ).to.emit(exampleContract, "Transfer");

    const item = await exampleContract.getItem(8764);
    
    console.log(item);

    expect(item).not.to.be.null();
    
  });

  

});
