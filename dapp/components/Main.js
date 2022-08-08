import { useWeb3Contract } from "react-moralis"
import { useNotification } from "web3uikit"

export default function Main() {
	const contractAddresses = require("../constants/contractAddresses.json")
	const contractAddress = contractAddresses["4"][0]
	const abi = require("../constants/abi.json")
	const dispatch = useNotification()

	const {
		runContractFunction: mint,
		data: enterTxResponse,
		isLoading,
		isFetching,
	} = useWeb3Contract({
		abi: abi,
		contractAddress: contractAddress,
		functionName: "mint",
		//msgValue: 0, //////////////////////////////
		params: {},
	})

	const handleSuccess = async (tx) => {
		await tx.wait(1)
		dispatch({
			type: "info",
			message: "Transaction Complete!",
			title: "Transaction Notification",
			position: "topR",
			icon: "bell",
		})
	}

	return (
		<div className="p-5">
			<h1 className="py-4 px-4 font-bold text-3xl">Mint an NFT</h1>
			<p>Make sure to connect your Wallet to the Rinkeby Network</p>
			<button
				className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded ml-auto"
				onClick={async () =>
					await mint({
						onSuccess: handleSuccess,
						onError: (error) => console.log(error),
					})
				}
				disabled={isLoading || isFetching}
			>
				{isLoading || isFetching ? (
					<div className="animate-spin spinner-border h-8 w-8 border-b-2 rounded-full"></div>
				) : (
					"Mint Here!"
				)}
			</button>
		</div>
	)
}
