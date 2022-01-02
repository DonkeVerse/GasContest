const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GasContest", function () {
  let GasContest = null;
  let owner = null;
  let addr1 = null;

  beforeEach(async function () {
    const dv = await ethers.getContractFactory("GasContest");
    [owner, addr1] = await ethers.getSigners();

    GasContest = await dv.deploy();
    await GasContest.deployed();
  });

  describe("mint", async function () {
    signingWallet = null;
    function signAddress(wallet, customer) {
      return wallet.signMessage(
        ethers.utils.arrayify(
          ethers.utils.defaultAbiCoder.encode(["bytes32"], 
                                              [ethers.utils.defaultAbiCoder.encode(["address"], [customer])])
        )
      );
    }

    beforeEach(async function () {
      signingWallet = addr1
      await GasContest.setPublicMintAddress(addr1.address);
    });

    it("should allow whitelisted users to mint if they pay enough ether", async function () {
      const signature1 = await signAddress(signingWallet, addr1.address);
      await expect(
        GasContest.connect(addr1).publicMint(signature1, {
          value: ethers.utils.parseEther("0.06"),
        })
      ).to.not.be.reverted;
      expect(await GasContest.ownerOf(1)).to.be.equal(addr1.address);

      await expect(
        GasContest.connect(addr1).publicMint(signature1, {
          value: ethers.utils.parseEther("0.06"),
        })
      ).to.not.be.reverted;
      expect(await GasContest.ownerOf(2)).to.be.equal(addr1.address);
    });
  });
});