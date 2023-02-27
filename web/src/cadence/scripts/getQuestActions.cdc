  import MembershipCard from 0xf8d6e0586b0a20c7;
  import MetadataViews from 0xf8d6e0586b0a20c7;
  import NonFungibleToken from 0xf8d6e0586b0a20c7

  pub fun main(address: Address, id: UInt64): &AnyResource{MetadataViews.Resolver} {
    let account = getAccount(address)

    let collection = account
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{MetadataViews.ResolverCollection}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowViewResolver(id: id) 

    return(nft)
  }