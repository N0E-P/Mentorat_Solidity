// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Utilisation d'Open Zeppelin pour faciliter la création des NFTs
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Erreurs
error NFTMentoratSolidityV3__AllNFTsHaveBeenMinted();
error NFTMentoratSolidityV3__RoyaltiesNeedToBeMoreThan0();
error NFTMentoratSolidityV3__RoyaltiesNeedToBeMoreThan10000();
error NFTMentoratSolidityV3__InsufficientFunds();

// Création du contract
contract NFTMentoratSolidityV3 is ERC721, ERC2981, Ownable {
    string public constant hiddenMetadataUri =
        "ipfs://QmT1EZTkk5oTeAT4yXbBqp28AbuypvugCNNLSjshg7tip5/?filename=metadata.json";
    string public uriPrefix;
    string public uriSuffix;
    address public royaltiesReceiver;
    uint256 public immutable maxMintAmountPerTx = 1;
    uint256 public immutable maxSupply = 420;
    uint256 public immutable cost = 0.1 ether;
    uint256 public supply = 0;
    bool public revealed = false;

    //Envoie 26 NFTs aux fondateurs au lancement du contract, et set les royalties
    constructor(address _royaltiesReceiver, uint96 _royaltyFeesInBips, string memory _uriPrefix, string memory _uriSuffix)
        ERC721("Mentorat Solidity - DRENGR ", "MSD")
    {
        if (_royaltyFeesInBips <= 0) {
            revert NFTMentoratSolidityV3__RoyaltiesNeedToBeMoreThan0();
        }
        if (_royaltyFeesInBips > 10000) {
            revert NFTMentoratSolidityV3__RoyaltiesNeedToBeMoreThan10000();
        }
        royaltiesReceiver = _royaltiesReceiver;
        uriPrefix = _uriPrefix;
        uriSuffix = _uriSuffix;
        _setDefaultRoyalty(royaltiesReceiver, _royaltyFeesInBips);
        for (uint256 i = 0; i < 26; i++) {
            _safeMint(msg.sender, supply);
            supply = supply + 1;
        }
    }

    //Minter les NFTs
    function mint() public payable{
        if (supply + 1 > maxSupply) {
            revert NFTMentoratSolidityV3__AllNFTsHaveBeenMinted();
        }
        if (msg.value < cost) {
            revert NFTMentoratSolidityV3__InsufficientFunds();
        }
        supply = supply + 1;
        _safeMint(msg.sender, supply);
    }

    //Récupérer les fonds
    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    //Changer les royalties
    function setRoyaltyFees(uint96 _royaltyFeesInBips) public onlyOwner {
        _setDefaultRoyalty(royaltiesReceiver, _royaltyFeesInBips);
    }

    //Faire le reveal
    function setRevealed(bool _state) public onlyOwner {
        revealed = _state;
    }

    // Définit la metadata des NFTs
    //Je ne suis pas sur de moi sur cette fonction, parce qu'une fois reveal, l'uri va forcément dépendre d'où et de comment est stocké la metadata. Donc c'est surement à adapter en fonction des projets.
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (revealed == false) {
            return hiddenMetadataUri;
        }
        
        return string(abi.encodePacked(uriPrefix, _tokenId, uriSuffix));
    }

    //Dire que l'on utilise ERC721 et ERC2981
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
