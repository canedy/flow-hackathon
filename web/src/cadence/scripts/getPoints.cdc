import MembershipCard from 0xf8d6e0586b0a20c7

pub fun main(user: Address): UInt64 {

  // get the public account of the user
  let account: PublicAccount = getAccount(user)

  // Fetch the public capability of @NFT
  let capability: Capability<&MembershipCard.MemberPoints{MembershipCard.MemberPointsInterface}> = account.getCapability<&MembershipCard.MemberPoints{MembershipCard.MemberPointsInterface}>(/public/MemberPoints)

  // Borrowing the &NFT reference
  let points: &MembershipCard.MemberPoints{MembershipCard.MemberPointsInterface} = capability.borrow() ?? panic("No reference to resource{type}")

  return points.getCurrentPoints()

}