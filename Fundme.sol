// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;
//interfaces compile down to an ABI; an ABI - application binary interface tells solidity and other langauges how it can interact with another contract
//anytime we interact with a contract we need an ABI
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//we are going to import safemath to check our math -- can use the zepplin or chainlink library, not needed for less that 0.8
// import "@chainlink/contracts/src/v0.7/vendor/SafeMathChainlink.sol";

contract FundMe {
    //attaching the library to any uint256 because im using a version behind 0.8 this will check for any overflows
    // - using SafeMathChainlink for uint256;
    //lets keep track of who sent us what, by setting up a mapping - initally received an error when setting the mapping inside the function
    mapping(address => uint256) public addressToAmountFunded;
    //is immediately executed once the contract is deployed
    address[] public funders;
    address public owner;
    //i tried to declare as public
    constructor(){
        owner = msg.sender;
    }
    //we want a contract that will accept payment, this can be done with the 'payable' keyword
    function fund() public payable {
        //we want to ensure they send at least $50 - first initialize the variable
        uint256 minimumUSD = 50 * 10 ** 18;
        // then we want to stop exrcuting if they dont send the transaction, we can use 'if' but require is used conventionally
        require(getConversionRate(msg.value)>= minimumUSD, "less than $50 ngmi"); // we can also use a revert error message after the size parameter appending ,"example"
        //whenever we call the function we are calling the mapping which displays their value
            addressToAmountFunded[msg.sender] += msg.value;
            //we want to transact in different currencies, eth in the token but in the USD denomination
            //blockchains can add values and reach consensus bc math is universial, and determinstic, they cannot agree on what random numbers are OR call api's, because they can all at different times
        funders.push(msg.sender);
    }
    // get version where we find the version of the interface
    function getVersion() public view returns(uint256){
        // just like interacting with variables and structs, we define type, name, and then what the pricefeed is and return the version
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    //this returns 5 variables, a tuple is a list of potentially different types
    function getPrice() public view returns(uint256){
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);  
       //made the parameters of the getRoundData = to new type and returned one type from the interface
       //crying about unused variables so i replaced the tuple call with commas
       (,int256 answer,,,) = priceFeed.latestRoundData();
       //must typecast because answer is an int not an uint, additionally we can multuiple the answer to make it more visually appealing but it uses more gas
       return uint256(answer * 1000000000);

    }
    // 1000000000
    //createfunction that converts the value of the transaction sent to usd
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        //grab new variable from function but we wont change the actual function, it returns a high value that we have to divide because its too large
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 100000000000000000;
        
        return ethAmountInUsd;
    }
    //modiifers are used to change the behaviour of functions in this case we want to withdraw to an admin account
    modifier onlyOwner{
    //before we pay out we check for ownership of contract // if we switch accounts in envinroment or through metamask while we withdraw from a different account that deployed the contract
        require(msg.sender == owner);
        _;
    }
    //we sent the contract money but there is no way to get it back
    function withdraw() payable public{
        
        //transfer is the function that can send eth from one wallet to another
        //this refers to the contract we are currently in-- address is the address of 'this'
        //address is not payable by default so i cast it as payable

        (payable(msg.sender)).transfer(address(this).balance);
        //this would allow anybody to withdraw the funds from the contract
        //require msg.sender = owner

        //reset everyones balance using for loop
        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funder funders
        }
    }
    
}
