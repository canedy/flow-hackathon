export const claimQuestTransaction = `
  import MembershipCard from 0xf8d6e0586b0a20c7
  import NonFungibleToken from 0xf8d6e0586b0a20c7
  import MetadataViews from 0xf8d6e0586b0a20c7

  transaction(
    recipient: Address,
    image: String,
    thumbnail: String,
    name: String,
    description: String,
    startDateTime: UFix64,
    endDateTime: UFix64,
    // action: [{String: String}]
  ) {


    prepare(signer: AuthAccount) {

      if signer.borrow<&MembershipCard.Collection>(from: MembershipCard.CollectionStoragePath) != nil {
        return
      }

      // Create a new empty collection
      let collection <- MembershipCard.createEmptyCollection()

      // save it to the account
      signer.save(<- collection, to: MembershipCard.CollectionStoragePath)

      // create a public capability for the collection
      signer.link< &MembershipCard.Collection{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(MembershipCard.CollectionPublicPath, target: MembershipCard.CollectionStoragePath)
    }

    execute {
      // Borrow the recipient's public NFT colletion reference
      let receiver = getAccount(recipient)
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get reciever reference to the NFT Collection")


        let action1 <- MembershipCard.mintAction(
          image: "image",
          locationName: "locationName",
          locationDescription: "locationDescription",
          website: "website",
          phone: "3333333333",
          address: "address",
          city: "city",
          state: "state",
          zip: "33333",
          amenities: ["amenities"],
          status: "status",
          earnedPoints: 0,
          completeDateTime: 0.0          
        )


      // Mint the NFT and deposit it to the recipient's collection
      MembershipCard.mintNFT(
        recipient: receiver,
        image: image,
        thumbnail: thumbnail,
        name: name,
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        action: <- action1
      )

      log("Quest with action created! 🚀")
    }

  }
`