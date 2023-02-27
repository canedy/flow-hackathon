  // Emulator
  // import MembershipCard from 0xf8d6e0586b0a20c7;
  // import MetadataViews from 0xf8d6e0586b0a20c7;
  // import NonFungibleToken from 0xf8d6e0586b0a20c7

  // Testnet
  import MembershipCard from 0x3b5750ca70a87ea0;
  import NonFungibleToken from 0x631e88ae7f1d7c20;
  import MetadataViews from 0x631e88ae7f1d7c20;  

  pub fun main(address: Address, id: UInt64): &AnyResource{MetadataViews.Resolver} {
    let account = getAccount(address)

    let collection = account
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{MetadataViews.ResolverCollection}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowViewResolver(id: id) 

    return(nft)
  }