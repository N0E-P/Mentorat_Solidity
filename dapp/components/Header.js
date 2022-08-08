import { ConnectButton } from "web3uikit"

export default function Header() {
	return (
		<nav className="p-5 border-b2 flex flex-row justify-between items-center">
			<h1 className="py-4 px-4 font-bold text-3xl">NFT Dapp - Mentorat Solidity</h1>
			<div className="flex flex-row items-center">
				<ConnectButton />
			</div>
		</nav>
	)
}
