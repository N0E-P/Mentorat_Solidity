import Head from "next/head"
import Header from "../components/Header"
import Main from "../components/Main"

export default function Home() {
	return (
		<div>
			<Head>
				<title>NFT Dapp - Noé</title>
				<meta name="description" content="NFT Mint App" />
				<link rel="icon" href="/favicon.ico" />
			</Head>
			<Header />
			<Main />
		</div>
	)
}
