// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Utilisation d'Open Zeppelin pour faciliter la création des NFTs
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Utilisation de Rarible pour récupérer des royalties sur chaque reventes
import "rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol";
import "rarible/royalties/contracts/LibPart.sol";
import "rarible/royalties/contracts/LibRoyaltiesV2.sol";

// Création du contract
contract NFTMentoratSolidity is ERC721, Ownable {
    using Strings for uint256;
    uint256 supply = 0;
    string public metadata =
        "ipfs://QmUrjx75FvtJxzGksxtsP2SwD8rE5DTPLYppHb3piUzgfY/?filename=metadata.json";
    uint256 public maxSupply = 420;
    uint256 public maxMintAmountPerTx = 1;

    //Fonction qui s'effectue au lancement du Smart Contract pour envoyer 26 NFTs aux fondateurs
    constructor() ERC721("Mentorat Solidity - DRENGR ", "MSD") {
        for (uint256 i = 0; i <= 26; i++) {
            _safeMint(msg.sender, supply.current());
        }
        supply = supply + 26;
    }

    //Minter les NFTs
    function mint(uint256 mintAmount) public payable {
        require(mintAmount = maxMintAmountPerTx, "Invalid mint amount!");
        require(
            supply.current() + mintAmount <= maxSupply,
            "Max supply exceeded!"
        );
        _safeMint(msg.sender, supply.current());
        supply = supply + 1;
    }

    //Récupérer tout les fonds
    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    //Configurer les royalties
    function setRoyalties(
        uint _tokenId,
        address payable _royaltiesRecipientAddress,
        uint96 _percentageBasisPoints
    ) public onlyOwner {
        LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = _percentageBasisPoints;
        _royalties[0].account = _royaltiesRecipientAddress;
        _saveRoyalties(_tokenId, _royalties);
    }

    //configure royalties for Mintable using the ERC2981 standard
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
        //use the same royalties that were saved for Rariable
        LibPart.Part[] memory _royalties = royalties[_tokenId];
        if (_royalties.length > 0) {
            return (
                _royalties[0].account,
                (_salePrice * _royalties[0].value) / 10000
            );
        }
        return (address(0), 0);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable)
        returns (bool)
    {
        if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
            return true;
        }

        if (interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }

        return super.supportsInterface(interfaceId);
    }
}
