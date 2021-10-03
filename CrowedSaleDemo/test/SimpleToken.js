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