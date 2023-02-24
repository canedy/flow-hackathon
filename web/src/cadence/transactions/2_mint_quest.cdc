import MembershipCard from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction(recipient: Address,
            image: String,
            name: String,
            description: String,
            startDateTime: UFix64,
            endDateTime: UFix64) {

  prepare(signer: AuthAccount) {
    // Get a reference to the `Minter`
    let minter = signer.borrow<&MembershipCard.Admin>(from: MembershipCard.AdminStoragePath)
                    ?? panic("This signer is not the one who deployed the contract.")

    // Get a reference to the `recipient`s public Collection
    let recipientsCollection = getAccount(recipient).getCapability(MembershipCard.CollectionPublicPath)
                                  .borrow<&MembershipCard.Collection{MembershipCard.CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>()
                                  ?? panic("The recipient does not have a Collection.")

    // mint the NFT using the reference to the `Minter` and pass in the metadata
    let nft <- minter.mintNFT(
                image: image,
                name: name,
                description: description,
                startDateTime: startDateTime,
                endDateTime: endDateTime)

    // deposit the NFT in the recipient's Collection
    recipientsCollection.deposit(token: <- nft)
  }

}