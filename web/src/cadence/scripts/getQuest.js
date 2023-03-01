export const getQuest = `
  // Emulator
  import MembershipCard from 0xf8d6e0586b0a20c7;
  import MetadataViews from 0xf8d6e0586b0a20c7;
  import NonFungibleToken from 0xf8d6e0586b0a20c7

  // Testnet
  // import MembershipCard from 0x3b5750ca70a87ea0;
  // import NonFungibleToken from 0x631e88ae7f1d7c20;
  // import MetadataViews from 0x631e88ae7f1d7c20;  

  pub struct RenderCollection {
    pub var id: UInt64
    pub var name: String
    pub var image: String?

    init(id: UInt64, name: String, image: String?) {
      self.id = id
      self.name = name
      self.image = image
    }
  }

  pub fun main(address: Address, id: UInt64): MetadataViews.Display? { // &MembershipCard.Collection{} {

    let account = getAccount(address)

    let collection = account
        .getCapability(MembershipCard.CollectionPublicPath)
        .borrow<&MembershipCard.Collection{MetadataViews.ResolverCollection}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowViewResolver(id: id)    

    let view = nft.resolveView(Type<MetadataViews.Display>()) 
    let display = view as! MetadataViews.Display?

    return display
    
  }
`