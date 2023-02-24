export const claimQuestTransaction = `
  import MembershipCard from 0xf8d6e0586b0a20c7
  import NonFungibleToken from 0xf8d6e0586b0a20c7

  transaction(recipient: Address, questId: UInt64) {

    prepare(signer: AuthAccount) {
      
      // Get a reference to the Minter
      let minter = signer.borrow<&MembershipCard.Admin>(from: MembershipCard.AdminStoragePath)
                      ?? panic("This signer is not the one who deployed the contract.")

      // Get a reference to the recipients public Collection
      let recipientsCollection = getAccount(recipient).getCapability(MembershipCard.CollectionPublicPath)
                                    .borrow<&MembershipCard.Collection{MembershipCard.CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic}>()
                                    ?? panic("This account does not have a Collection.")
        
      let nft = recipientsCollection.borrowMembershipCardNFT(id: questId)

      // let nft <- signer.load<@MembershipCard.Admin>(from: /storage/Admin)
      // ?? panic("Admin doesn't exist!")

      log(nft)
      let admin = signer.borrow<&MembershipCard.Admin>(from: /storage/Admin)
                    ?? panic("Signer does not Admin privileges")

      // mint the NFT using the reference to the Minter and pass in the metadata
      // let nft <- minter.mintNFT(
      //             image: image,
      //             name: name,
      //             description: description,
      //             startDateTime: startDateTime,
      //             endDateTime: endDateTime)

    

      let action1 <- admin.mintAction(
                                      image: "image",
                                      startDateTime: 1676600957.0,
                                      endDateTime: 1676600957.0,
                                      locationName: "locationName",
                                      locationDescription: "locationDescription",
                                      website: "website",
                                      phone: 3333333333,
                                      address: "address",
                                      city: "city",
                                      state: "state",
                                      zip: 33333,
                                      amenities: ["amenities"],
                                      status: "status",
                                      earnedPoints: 0,
                                      completeDateTime: 0.0
                                    )
      
      let action2 <- admin.mintAction(
                                      image: "image",
                                      startDateTime: 1676600957.0,
                                      endDateTime: 1676600957.0,
                                      locationName: "locationName",
                                      locationDescription: "locationDescription",
                                      website: "website",
                                      phone: 3333333333,
                                      address: "address",
                                      city: "city",
                                      state: "state",
                                      zip: 33333,
                                      amenities: ["amenities"],
                                      status: "status",
                                      earnedPoints: 0,
                                      completeDateTime: 0.0
                                    )

      let actions <- nft.getAction()

      let oldAction <- actions["a1"] <- action1
      destroy oldAction
      let oldAction2 <- actions["a3"] <- action2
      destroy oldAction2

      nft.setAction(action: <- actions)

      // deposit the NFT in the recipient's Collection
      recipientsCollection.deposit(token: <- nft)
    }

    execute {
      log("Quest with action created! 🚀")
    }

  }
`