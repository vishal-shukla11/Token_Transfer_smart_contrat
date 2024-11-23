// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    
    // Struct to represent an item
    struct Item {
        uint256 id;
        address payable seller;
        uint256 price;
        address buyer;
        bool isSold;
    }

    // Mapping to store items with an item ID
    mapping(uint256 => Item) public items;
    
    // Counter for item IDs
    uint256 public itemCount;

    // Event to log the listing of a new item
    event ItemListed(uint256 id, address seller, uint256 price);
    
    // Event to log the purchase of an item
    event ItemPurchased(uint256 id, address buyer, uint256 price);

    // Function to list a new item for sale
    function listItem(uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            seller: payable(msg.sender),
            price: _price,
            buyer: address(0),
            isSold: false
        });

        emit ItemListed(itemCount, msg.sender, _price);
    }

    // Function to purchase an item
    function purchaseItem(uint256 _id) external payable {
        Item storage item = items[_id];
        require(_id > 0 && _id <= itemCount, "Item does not exist");
        require(msg.value == item.price, "Please submit the exact price");
        require(!item.isSold, "Item is already sold");
        require(item.seller != msg.sender, "Seller cannot purchase their own item");

        // Mark the item as sold
        item.isSold = true;
        item.buyer = msg.sender;

        // Transfer funds to the seller
        item.seller.transfer(msg.value);

        emit ItemPurchased(_id, msg.sender, item.price);
    }

    // Function to get details of an item
    function getItemDetails(uint256 _id) external view returns (uint256, address, uint256, address, bool) {
        Item memory item = items[_id];
        return (item.id, item.seller, item.price, item.buyer, item.isSold);
    }
}
