// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Utilisation d'Open Zeppelin pour faciliter la création des NFTs
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Importation d'autres smart contracts pour gérer les royalties
import "rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol";
import "rarible/royalties/contracts/LibPart.sol";
import "rarible/royalties/contracts/LibRoyaltiesV2.sol";

// Création du contract
contract NFTMentoratSolidity is ERC721Enumerable, Ownable, RoyaltiesV2Impl {
    using Strings for uint256;
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    uint256 supply = 0;
    string public metadata =
        "ipfs://QmUrjx75FvtJxzGksxtsP2SwD8rE5DTPLYppHb3piUzgfY/?filename=metadata.json";
    uint256 public maxSupply = 420;
    uint256 public maxMintAmountPerTx = 1;

    //Envoie 26 NFTs aux fondateurs au lancement du contract
    constructor() ERC721("Mentorat Solidity - DRENGR ", "MSD") {
        for (uint256 i = 0; i < 26; i++) {
            _safeMint(msg.sender, supply);
            supply = supply + 1;
        }
    }

    //Minter les NFTs
    function mint(uint256 mintAmount) public payable {
        require(mintAmount == maxMintAmountPerTx, "Invalid mint amount!");
        require(supply + mintAmount <= maxSupply, "Max supply exceeded!");
        _safeMint(msg.sender, supply);
        supply = supply + 1;
    }

    //Configurer les royalties (3 fonctions suivantes)
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

    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount)
    {
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
