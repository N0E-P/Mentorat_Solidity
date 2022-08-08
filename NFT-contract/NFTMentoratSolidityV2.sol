// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Utilisation d'Open Zeppelin pour faciliter la création des NFTs
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Erreurs
error NFTMentoratSolidityV2__AllNFTsHaveBeenMinted();
error NFTMentoratSolidityV2__RoyaltiesNeedToBeMoreThan0();
error NFTMentoratSolidityV2__RoyaltiesNeedToBeMoreThan10000();

// Création du contract
contract NFTMentoratSolidityV2 is ERC721Enumerable, ERC2981, Ownable {
    string public constant metadata =
        "ipfs://QmT1EZTkk5oTeAT4yXbBqp28AbuypvugCNNLSjshg7tip5/?filename=metadata.json";
    uint256 public immutable maxSupply = 420;
    uint256 public immutable maxMintAmountPerTx = 1;
    uint256 public supply = 0;

    //Envoie 26 NFTs aux fondateurs au lancement du contract, et set les royalties
    constructor(address _royaltiesReceiver, uint96 _royaltyFeesInBips)
        ERC721("Mentorat Solidity - DRENGR ", "MSD")
    {
        if (_royaltyFeesInBips <= 0) {
            revert NFTMentoratSolidityV2__RoyaltiesNeedToBeMoreThan0();
        }
        if (_royaltyFeesInBips > 10000) {
            revert NFTMentoratSolidityV2__RoyaltiesNeedToBeMoreThan10000();
        }
        _setDefaultRoyalty(_royaltiesReceiver, _royaltyFeesInBips);
        for (uint256 i = 0; i < 26; i++) {
            _safeMint(msg.sender, supply);
            supply = supply + 1;
        }
    }

    //Minter les NFTs
    function mint() public {
        if (supply + 1 >= maxSupply) {
            revert NFTMentoratSolidityV2__AllNFTsHaveBeenMinted();
        }
        _safeMint(msg.sender, supply);
        supply = supply + 1;
    }

    // Définit la metadata pour tout les NFTs
    function _baseURI() internal view override returns (string memory) {
        return metadata;
    }

    //Dire que l'on utilise ERCEnumerable et ERC2981
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Enumerable, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
