import { useWeb3Contract } from "react-moralis"
import { useNotification } from "web3uikit"

export default function Main() {
	const contractAddresses = require("../constants/contractAddresses.json")
	const contractAddress = contractAddresses["4"][0]
	const abi = require("../constants/abi.json")
	const notification = useNotification()

	const {
		runContractFunction: mint,
		data: enterTxResponse,
		isLoading,
		isFetching,
	} = useWeb3Contract({
		abi: abi,
		contractAddress: contractAddress,
		functionName: "mint",
		params: {},
	})

	const handleSuccess = async (tx) => {
		await tx.wait(1)
		notification({
			type: "info",
			message: "Transaction Complete!",
			title: "Transaction Notification",
			position: "topR",
			icon: "bell",
		})
	}

	return (
		<div className="py-24">
			<div className="h-auto m-auto max-w-[600px] shadow-lg shadow-gray-400 rounded-xl items-center justify-center p-4 ">
				<h1 className="py-2 px-4 font-bold text-3xl">Mint an NFT</h1>
				<p className="py-3 px-4">
					Make sure to connect your Wallet to the Rinkeby Network.
				</p>
				<div className="px-52">
					<button
						className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded shadow-md shadow-gray-400 ml-auto hover:scale-105 ease-in duration-300"
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
			</div>
		</div>
	)
}
