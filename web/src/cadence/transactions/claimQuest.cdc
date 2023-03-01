  // Emulator
  import MembershipCard from 0xf8d6e0586b0a20c7;
  import MetadataViews from 0xf8d6e0586b0a20c7;
  import NonFungibleToken from 0xf8d6e0586b0a20c7

  // Testnet
  // import MembershipCard from 0x3b5750ca70a87ea0;
  // import NonFungibleToken from 0x631e88ae7f1d7c20;
  // import MetadataViews from 0x631e88ae7f1d7c20;  

  transaction(
    recipient: Address,
    claimQuestNumber: UInt64,
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
    
     // Borrow the recipient's public NFT colletion reference
      let receiver = getAccount(recipient)
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get reciever reference to the NFT Collection")


    
    }

    execute {
      // Borrow the recipient's public NFT colletion reference
      let receiver = getAccount(recipient)
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get reciever reference to the NFT Collection")

        log(claimQuestNumber)
        
        var image: String = ""
        var locationName = ""
        var locationDescription: String = ""
        var website: String = ""
        var phone: String = ""
        var address: String = ""
        var city: String = ""
        var state: String = ""
        var zip: String = ""
        var amenities: [String] = []

        if claimQuestNumber == 1234 {
          image = "https://flow-hackathon.vercel.app/distillery-2.png"
          locationName = "Brunswick"
          locationDescription = "Medina Great"
          website = "https://www.google.com"
          phone = "333-333-3333"
          address = "1234 Medina"
          city = "Medina"
          state = "Ohio"
          zip = "33333"
          amenities = ["Out Side"]

          log("distillery")
        }

        if claimQuestNumber == 4567 {
          image = "https://flow-hackathon.vercel.app/cupcake-2.png"
          locationName = "Medina"
          locationDescription = "Medina Great"
          website = "https://www.google.com"
          phone = "333-333-3333"
          address = "1234 Medina"
          city = "Medina"
          state = "Ohio"
          zip = "33333"
          amenities = ["Out Side"]
          
          log("cupcake")
        }

        if claimQuestNumber == 7890 {
          image = "https://flow-hackathon.vercel.app/bigfoot-traits.png"
          locationName = "Medina"
          locationDescription = "Medina Great"
          website = "https://www.google.com"
          phone = "333-333-3333"
          address = "1234 Medina"
          city = "Medina"
          state = "Ohio"
          zip = "33333"
          amenities = ["Out Side"]

          log("Bigfoot")
        }

        let action1 <- MembershipCard.mintAction(
          image: image,
          locationName: locationName,
          locationDescription: locationDescription,
          website: website,
          phone: phone,
          address: address,
          city: city,
          state: state,
          zip: zip,
          amenities: amenities,
          status: "Open",
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