const SimpleToken = artifacts.require("./SimpleToken");
const truffleAssert = require('truffle-assertions');

contract("SimpleToken", (accounts) => {
    let simpleToken;

    before(async () => {
        simpleToken = await SimpleToken.deployed();
    });

    it("should assert true", async () => {
        assert.isTrue(true);
    });

    // Testing Pausable ********************

    it("Transfering tokens only when pausable", async () => {
        // Prepare / Act / Assert
        await truffleAssert.reverts(simpleToken.transfer(accounts[1], 100));
    });

    it("TransferFrom tokens only when pausable", async () => {
        // Prepare / Act / Assert
        await truffleAssert.reverts(simpleToken.transferFrom(accounts[0], accounts[1], 100));
    });


    it("Approve tokens only when pausable", async () => {
        // Prepare / Act / Assert
        await truffleAssert.reverts(simpleToken.approve(accounts[1], 100));
    });

    // Ending Pausable Tests ******************


    // Testing Ownership ********************

    it("Non owner cannot mint tokens", async () => {
        // Prepare / Act / Assert
        await truffleAssert.reverts(simpleToken.mint(100, accounts[1], {"from": accounts[1]}));
    });    

    it("Non owner cannot release token", async () => {
        // Prepare / Act / Assert
        await truffleAssert.reverts(simpleToken.release({"from": accounts[1]}));
    });    

    // Ending Ownership Tests ********************

    // Testing methods **********

    it("Owner mint succesfully tokens", async () => {
        
        // Prepare
        const expectedValue = 100;
        const expectedReceiver = accounts[1];

        // Act
        await simpleToken.mint(expectedValue, expectedReceiver);

        // Assert
        const valueToAssert = await simpleToken.balanceOf(expectedReceiver);

        assert.equal(expectedValue, valueToAssert);

    });

    it("Owner release token succesfully", async () => {

        // Prepare
        const expectedValue = false;

        // Act
        await simpleToken.release();
        
        // Assert
        const paused = await simpleToken.paused();
        assert.equal(expectedValue, paused);

        await simpleToken.pause();
    });

    it("Account1 transfers 55 tokens to account2", async () => {
        // Prepare
        const account1 = accounts[1];
        const account2 = accounts[2];

        const transferedValue = 55;
        const expectedAccount1Balance = await simpleToken.balanceOf(account1) - transferedValue;
        const expectedAccount2Balance = await simpleToken.balanceOf(account2) + transferedValue;
        
        await simpleToken.release();
        await simpleToken.mint(transferedValue, account1);

        // Act
        await simpleToken.transfer(account2, transferedValue, {"from": account1});

        // Assert
        const account1BalanceToAssert = await simpleToken.balanceOf(account1);
        const account2BalanceToAssert = await simpleToken.balanceOf(account2);
        
        assert.equal(expectedAccount1Balance, account1BalanceToAssert);
        assert.equal(expectedAccount2Balance, account2BalanceToAssert);
    });

    // Ending testing methods

    /*
    it("should return Test", async () => {
        const name = await test.getName();

        assert("Test" === name);
    });

    it("No contract owner can't change name", async () => {
        await truffleAssert.reverts(test.setName("ShouldFail", { 'from': accounts[1] }));

    });

    it("Contract owner can change name", async () => {
        const expectedName = "ChangeAllowed";
        await test.setName(expectedName, { "from": accounts[0] });

        const nameToAssert = await test.getName();

        assert.equal(expectedName, nameToAssert);
    });

    it("SetNameEvent is emited with right parameters when name its changed", async () => {
        const result = await test.setName('Test');
        
        truffleAssert.eventEmitted(result, 'SetNameEvent', (event) => {
             return event.evPram == 'Test'; 
            });
    });
    */
});