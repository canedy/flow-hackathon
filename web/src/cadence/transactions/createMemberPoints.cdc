import MembershipCard from 0xf8d6e0586b0a20c7

transaction() {

  prepare(signer: AuthAccount) {
    let memberPoints <- MembershipCard.createMemeberPoints()
    signer.save(<- memberPoints, to: /storage/MemberPoints)
    signer.link<&MembershipCard.MemberPoints{MembershipCard.MemberPointsInterface}>(/public/MemberPoints, target: /storage/MemberPoints)
  }

  execute {
    log("Member Points resource has been created")
  } 

}