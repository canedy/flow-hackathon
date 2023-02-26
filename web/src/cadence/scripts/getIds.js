export const getIds = `
import MembershipCard from 0xf8d6e0586b0a20c7;
import MetadataViews from 0xf8d6e0586b0a20c7;

// import MetadataViews from 0x631e88ae7f1d7c20;


pub fun main(address: Address): [UInt64] {
    
  let account = getAccount(address)

  let collection = account
      .getCapability(MembershipCard.CollectionPublicPath)
      .borrow<&MembershipCard.Collection{MetadataViews.ResolverCollection}>()
      ?? panic("Could not borrow a reference to the collection")

      let IDs = collection.getIDs()
  return IDs;
}
`;