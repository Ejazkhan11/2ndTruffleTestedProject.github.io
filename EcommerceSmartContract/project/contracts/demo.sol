// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract demo {
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint productID;
        uint price;
        address buyer;
        bool delivered;
    }
    uint counter = 1;
    Product[] public products;
    event registered(string title, uint productID, address seller);
    event bought(uint productID, address buyer);
    event delivered(uint productID);

    function registerProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price>0, "price should be greater than zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10**18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productID = counter;
        products.push(tempProduct);
        counter++;
        emit registered(_title, tempProduct.productID, msg.sender);
    }

    function buy(uint _productID) payable public {
        require(products[_productID-1].price==msg.value, "please pay the exact price");
        require(products[_productID-1].seller!=msg.sender, "seller cannot be the buyer");
        products[_productID-1].buyer=msg.sender;
        emit bought(_productID, msg.sender);
    }

    function delivery(uint _productID) public {
        require(products[_productID-1].buyer==msg.sender, "only buyer can confirm it");
        products[_productID-1].delivered = true;
        products[_productID-1].seller.transfer(products[_productID-1].price);
        emit delivered(_productID);
    }
}