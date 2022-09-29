const MerkleTree = require("merkletreejs");
const keccak256 = require("keccak256");
let fs = require('fs');

let leaves = [];
let whitelisted_addresses = []

file_path = process.argv[2];
fs.readFile(file_path, 'utf8', function(err, data){
    whitelisted_addresses = data.split(/\r?\n/)
    console.log("whitelisted addresses: ", whitelisted_addresses);
    if (whitelisted_addresses) {
        leaves = whitelisted_addresses.map(x => keccak256(x));
    }

    let tree = new MerkleTree.MerkleTree(leaves, keccak256, {sortPairs: true});

    console.log("Merkle root:", tree.getHexRoot());
});
