  import MembershipCard from 0xf8d6e0586b0a20c7;
  import MetadataViews from 0xf8d6e0586b0a20c7;
  import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction(recipient: Address, questID: UInt64) {
  
  prepare(signer: AuthAccount) {

    // Borrow reference &Event to collection
    let collection = signer.getCapability(MembershipCard.CollectionPublicPath)
                      .borrow<&MembershipCard.Collection{MetadataViews.ResolverCollection, NonFungibleToken.CollectionPublic}>()
                      ?? panic("This account does not have a Collection.")
// 36 nft
// 35 action

    let nft = collection.borrowViewResolver(id: 36) 
    log(nft.getIDs)
    // log(nft.getAction())

    

    // let action <- signer.load<@MembershipCard.Collection>(from: /storage/ExperienceCollection)
    //     ?? panic("Kitty doesn't exist!")

    // let nft: @MembershipCard.NFT <- action.withdraw(withdrawID: 35)

    // // let actions <- nft.getAction()

    // log(nft)
    // destroy action
    // destroy nft

    let admin = signer.borrow<&MembershipCard.Admin>(from: /storage/Admin)
                  ?? panic("Signer does not Admin privileges")




  }

  execute {
    log("🎉 Congrats you have completed the Quest Action!")
  }
}