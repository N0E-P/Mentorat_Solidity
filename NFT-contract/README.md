#V1 et V2(version corrigée)

Réaliser un contrat de NFT avec ces caractéristiques :
-> Supply : 420
-> Price : free
-> Mint d'1 NFT maximum par transaction
-> Une supply réservée au fondateur (26 NFT)
(il faut pouvoir les distribuer directement ou indirectement en utilisant le moins d'ethereum possible)
-> But: ne rien à redire sur le contrat, pas de faille de sécurité, optimisé etc
-> Intégrer les royalties dans le smart contract en respectant le standard opensea

J'ai pris le contract utilisé dans cette vidéo :
https://www.youtube.com/watch?v=McmhpmnQLto
https://github.com/HashLips/hashlips_nft_contract/blob/main/contract/SimpleNftLowerGas.sol

---

#V3
Comme avant, mais avec ces caractéristiques en supplément :

Prix pour le mint ✅
erreur si prix pas suffisant ✅
Pourcentage de royalties modifiable ✅
Reveal ~✅~
Dapp
Tout tester
