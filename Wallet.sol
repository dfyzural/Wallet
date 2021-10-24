pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
     */

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier checkOwnerAndAccept {

        require(msg.pubkey() == tvm.pubkey(), 100);

		tvm.accept();
		_;
	}


    function sendTransaction(address dest, uint128 value, bool bounce, bool payCommission) public pure checkOwnerAndAccept {
        uint16 flag; 
        if(payCommission){
            flag = 1;
        }else{
            flag = 0;
        }
        dest.transfer(value, bounce, flag);
    }

    function sendAll(address dest, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(0, bounce, 128);
    }

}
