
pragma solidity ^0.5.0;

contract Marketplace{
	
	string public name;

	uint public productCount=0;
	mapping(uint => Product) public products;




	struct Product{
		uint id;
		string name;
		uint price;
		address payable owner;
		bool purchased;
	}

	

	constructor() public {
		name="Marketplace";
	}

	event ProductCreated(
		uint id,
		string name,
		uint price,
		address payable owner,
		bool purchased
	);


	event ProductPurchased(
		uint id,
		string name,
		uint price,
		address payable owner,
		bool purchased
	);

	function createProduct(string memory _name, uint _price) public{
		//Require a valid name
		require(bytes(_name).length>0);


		//Require a valid price
		require(_price>0);	



		//Increment Product count
		productCount++;


		//Create product
		products[productCount]=Product(productCount, _name,_price, msg.sender, false);

		//trigger an event
		emit ProductCreated(productCount, _name,_price, msg.sender, false);
		
	}

	function purchaseProduct(uint _id) public payable{
		//Fetch the product
			Product memory _product=products[_id];

		//Fetch the owner
		address payable _seller= _product.owner;

		//Make sure product has valid id
		require(_product.id>0 && _product.id <=productCount);

		//Check there is enough ether in the transaction
		require(msg.value>=_product.price);


		//Require product is not purchased yet
		require(!_product.purchased);

		//Require seller is not buyer
		require(_seller != msg.sender);

		//Transfer ownership to the buyer
		_product.owner=msg.sender;
		
		//Mark product as purchased
		_product.purchased=true;
		
		//Update the product
		products[_id]=_product;

		//Pay the seller by sending them Ether
		address(_seller).transfer(msg.value);

		//Trigger an Event
		emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);

	}

}