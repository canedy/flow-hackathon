import MembershipCard from 0xf8d6e0586b0a20c7

pub fun main(user: Address): &MembershipCard.Collection {

  // get the public account of the user
  let account: PublicAccount = getAccount(user)

  // Fetch the public capability of @NFT
  let capability: Capability<&MembershipCard.Collection> = account.getCapability<&MembershipCard.Collection>(MembershipCard.CollectionPublicPath)

  // Borrowing the &NFT reference
  let membershipCard: &MembershipCard.Collection = capability.borrow()!

  return membershipCard

}