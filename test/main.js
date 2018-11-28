var GNS = artifacts.require("GNS");

contract('GNS', function() {

    /*
    "name"
    "name1"
    "name2"
    -------create valid---------
    "name",0x0000000003313233
    "name",0x0000000003312e33
    "name",0x0000000003714233
    "name1",0x0000000003714233
    "name",0x01ffffffaa
    "name",0x01ffbbffaa
    "name",0x02ffbbffaaffbbffaaffbbffaaffbbffaa
    "name",0x03313233
    "name",0x03313333
    -------filter valid---------
    "name",0x00
    "name",0x01
    "name",0x02
    "name",0x03
    "name1",0x00
    "name2",0x00
    ---------removing-----
    "name",5
    "name",0x01ffbbffaa
    ---------invalid---------
    "na.me",0x0000000003313233
    "name",0x00000000033132
    "name",0x01ffffaa
    "name",0x02ffbbffaaffbbffaaffbbffaaffbbff
    "name",0x03
    "name22",5
    */

    it("create, find, remove records", async () => {
        const gns = await GNS.deployed();

        await gns.createRecord("name",0x0000000003313233);
        await gns.createRecord("name",0x0000000003312e33);
        await gns.createRecord("name",0x0000000003714233);
        await gns.createRecord("name",0x01ffffffaa);
        await gns.createRecord("name",0x01ffbbffaa);
        await gns.createRecord("name",0x02ffbbffaaffbbffaaffbbffaaffbbffaa);
    });

    it("access test", async () => {
    });


    it("Amount of gas used", async () => {
    });

});