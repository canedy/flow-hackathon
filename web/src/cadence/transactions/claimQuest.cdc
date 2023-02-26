  import MembershipCard from 0xf8d6e0586b0a20c7
  import NonFungibleToken from 0xf8d6e0586b0a20c7
  import MetadataViews from 0xf8d6e0586b0a20c7

  transaction(
    recipient: Address,
    image: String,
    name: String,
    description: String,
    startDateTime: UFix64,
    endDateTime: UFix64,
    action: [{String: String}]
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
      signer.link<&MembershipCard.Collection{NonFungibleToken.CollectionPublic}>(MembershipCard.CollectionPublicPath, target: MembershipCard.CollectionStoragePath)
    }

    execute {
      // Borrow the recipient's public NFT colletion reference
      let receiver = getAccount(recipient)
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get reciever reference to the NFT Collection")

      // Mint the NFT and deposit it to the recipient's collection
      MembershipCard.mintNFT(
        recipient: receiver,
        image: image,
        name: name,
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        action: action
      )

      log("Quest with action created! 🚀")
    }

  }