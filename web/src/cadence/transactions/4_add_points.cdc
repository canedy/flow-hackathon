import MembershipCard from 0xf8d6e0586b0a20c7

transaction() {

  prepare(signer: AuthAccount) {
    let recipientPoints = signer.borrow<&MembershipCard.MemberPoints{MembershipCard.MemberPointsInterface}>(from: /storage/MemberPoints)
                            ?? panic("Recipient does not have the proper reference{type}")

    recipientPoints.addPoints()
  }

  execute{
    log("Added Points")
  }

}