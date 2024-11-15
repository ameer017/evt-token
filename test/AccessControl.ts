import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Access Controlled Token Test", function () {
    const contractFixture = async () => {
        const [owner] = await hre.ethers.getSigners();

        const AccessControlledToken = await hre.ethers.getContractFactory("AccessControlledToken");
        const accessControl = await AccessControlledToken.deploy();

        return { accessControl, owner };
    };

    it("Should mint as admin", async function () {

        const { accessControl } = await loadFixture(
            contractFixture
        );

        const addr1 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
        const addr2 = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"

        const newAdmin = await accessControl.addAdmin(addr1);
        await newAdmin.wait();
        const newAdmin2 = await accessControl.addAdmin(addr2);
        await newAdmin2.wait();

        const testMint = await accessControl.mint(addr1, 100);
        await testMint.wait();
        const testMint2 = await accessControl.mint(addr2, 100);
        await testMint2.wait();

        const userBalance = await accessControl.balanceOf(addr1);
        const userBalance2 = await accessControl.balanceOf(addr2);
        expect(userBalance).to.equal(100);
        expect(userBalance2).to.equal(100);
    });

    it("Should not mint as non admin", async function () {

        const { accessControl } = await loadFixture(
            contractFixture
        );

        const addr = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"

        const mint = await accessControl.mint(addr, 100);
        await mint.wait();

        const userBalance = await accessControl.balanceOf(addr);
        expect(userBalance).to.revertedWith("Only admins can call this function");
    });



    it("Should check balance as non-admin", async function () {
        const { accessControl, owner } = await loadFixture(
            contractFixture
        );

        const addr1 = "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65"

        const admin = await accessControl.addAdmin(addr1);
        await admin.wait();

        const testMint = await accessControl.mint(addr1, 100);
        await testMint.wait();

        await accessControl.connect(owner).balanceOf(addr1);
    });

    it("Should transfer as non-admin", async function () {

        const { accessControl, owner } = await loadFixture(
            contractFixture
        );

        const addr = "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc"
        await accessControl.connect(owner).transfer(addr, 100);
        const balance = await accessControl.balanceOf(addr);
        expect(balance).to.equal(100);
    });
});