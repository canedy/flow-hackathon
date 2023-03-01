export const createCollectionTransaction = `
  // Emulator
  // import MembershipCard from 0xf8d6e0586b0a20c7;
  // import MetadataViews from 0xf8d6e0586b0a20c7;
  // import NonFungibleToken from 0xf8d6e0586b0a20c7

  // Testnet
  import MembershipCard from 0x712510f9b51ae316;
  import NonFungibleToken from 0x631e88ae7f1d7c20;
  import MetadataViews from 0x631e88ae7f1d7c20;  
  
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
`