import * as fcl from "@onflow/fcl"

// config()
//   .put("flow.network", process.env.TESTNET_FLOW_NETWORK)
//   .put("app.detail.title", process.env.DETAIL_TITLE)
//   .put("accessNode.api", process.env.TESTNET_ACCESS_API)
//   .put("app.detail.icon", process.env.DETAIL_ICON)
//   .put("discovery.wallet", process.env.TESTNET_WALLET_DISCOVERY);

//Testnet
// fcl.config()
// .put("flow.network", "testnet")
// .put("app.detail.title", "Craft Block Quest")
// .put("accessNode.api", "https://rest-testnet.onflow.org")
// .put("app.detail.icon", "http://localhost:8910/favicon.png")
// .put("discovery.wallet", "https://fcl-discovery.onflow.org/testnet/authn")
// .put("0xFlowToken", "0x7e60df042a9c0868")

// Local Emulator
fcl.config()
.put("flow.network", "local")
.put("app.detail.title", "Craft Block Quest")
.put("accessNode.api", "http://localhost:8888")
.put("app.detail.icon", "http://localhost:8910/favicon.png")
.put("discovery.wallet", "http://localhost:8701/fcl/authn")
.put("discovery.wallet.method", "IFRAME/RPC");