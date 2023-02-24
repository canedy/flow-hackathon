import MembershipCard from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

transaction() {

  prepare(signer: AuthAccount) {
    let collection: @NonFungibleToken.Collection <- MembershipCard.createEmptyCollection()
    signer.save(<- collection, to: MembershipCard.CollectionStoragePath)
    signer.link<&MembershipCard.Collection>(MembershipCard.CollectionPublicPath, target: MembershipCard.CollectionStoragePath)
  }

  execute {
    log("Membership Card collection created")
  }
}