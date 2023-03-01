// Emulator
// import NonFungibleToken from 0xf8d6e0586b0a20c7;
// import MetadataViews from 0xf8d6e0586b0a20c7;

// Testnet
import NonFungibleToken from 0x631e88ae7f1d7c20;
import MetadataViews from 0x631e88ae7f1d7c20;

access(all) contract MembershipCard: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64)

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let AdminStoragePath: StoragePath
    pub let MemberPointStoragePath: StoragePath

    pub resource interface MemberPointsInterface {
        pub fun getCurrentPoints(): UInt64

        access(contract) fun addPoints()
    }

    pub resource MemberPoints: MemberPointsInterface {
        pub var totalPoints: UInt64

        init() {
            self.totalPoints = 0
        }
        
        access(contract) fun addPoints(){
            self.totalPoints = self.totalPoints + 1
        }

        pub fun getCurrentPoints(): UInt64 {
            return self.totalPoints
        }
    }


    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64
        pub let image: String
        pub let thumbnail: String
        pub let name: String
        pub let description: String
        pub let startDateTime: UFix64
        pub let endDateTime: UFix64
        pub let totalPoints: UInt64
        pub let totalVisits: UInt64

        pub var action: @{String: Action}

        init(
            image: String,
            thumbnail: String,
            name: String,
            description: String,
            startDateTime: UFix64,
            endDateTime: UFix64
        ){
            self.id = self.uuid
            self.image = image
            self.thumbnail = thumbnail
            self.name = name
            self.description = description
            self.startDateTime = startDateTime
            self.endDateTime = endDateTime
            self.totalPoints = 0
            self.totalVisits = 0
            self.action <- {}
        }

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>(),
                Type<MetadataViews.Trait>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
          switch view {
            case Type<MetadataViews.Display>():
              return MetadataViews.Display(
                name: self.name,
                description: self.description,
                thumbnail: MetadataViews.HTTPFile(
                    url: self.thumbnail
                )
              )
            case Type<MetadataViews.Trait>():
              let location: String = "Medina, OH"
              return location
            }
            return nil
          }
        

        pub fun setAction(action: @{String: Action}) {
            var other <- action
            self.action <-> other
            destroy other
        }

        pub fun getAction(): @{String: Action} {
            var other: @{String: Action} <- {}
            self.action <-> other
            return <- other
        }

        destroy() {
        destroy self.action
        }
    }

    pub resource Action {
        pub let id: UInt64
        pub let image: String
        pub let locationName: String
        pub let locationDescription: String
        pub let website: String
        pub let phone: String
        pub let address: String
        pub let city: String
        pub let state: String
        pub let zip: String
        pub let amenities: [String]
        pub let status: String
        pub let earnedPoints: UInt64
        pub let completeDateTime: UFix64

        init(
            image: String,
            locationName: String,
            locationDescription: String,
            website: String,
            phone: String,
            address: String,
            city: String,
            state: String,
            zip: String,
            amenities: [String],
            status: String,
            earnedPoints: UInt64,
            completeDateTime: UFix64
        ){
            self.id = self.uuid
            self.image = image
            self.locationName = locationName
            self.locationDescription = locationDescription
            self.website = website
            self.phone = phone
            self.address = address
            self.city = city
            self.state = state
            self.zip = zip
            self.amenities = amenities
            self.status = status
            self.earnedPoints = earnedPoints
            self.completeDateTime = completeDateTime
        }
    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        // pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
        //     post {
        //         (result == nil):
        //             "Cannot borrow the reference: the ID of the returned reference is incorrect"
        //     }
        // }
    }

    pub resource Collection: CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <- token
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @MembershipCard.NFT
            emit Deposit(id: token.id, to: self.owner?.address)
            self.ownedNFTs[token.id] <-! token
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
          let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
          let MembershipCard = nft as! &MembershipCard.NFT
          return MembershipCard as &AnyResource{MetadataViews.Resolver}
        }

        init () {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub fun mintNFT(
        recipient: &{NonFungibleToken.CollectionPublic},
        image: String,
        thumbnail: String,
        name: String,
        description: String,
        startDateTime: UFix64,
        endDateTime: UFix64,
        action: @MembershipCard.Action
    ){        
        var nft <- create NFT(
            image: image,
            thumbnail: thumbnail,
            name: name,
            description: description,
            startDateTime: startDateTime,
            endDateTime: endDateTime
        )
        emit Minted(id: nft.id)

        let actions <- nft.getAction()

        let oldAction <- actions["a1"] <- action
        destroy oldAction
        nft.setAction(action: <- actions)
        
        recipient.deposit(token: <- nft)
        MembershipCard.totalSupply = MembershipCard.totalSupply + 1
    }

    pub fun mintAction(
        image: String,
        locationName: String,
        locationDescription: String,
        website: String,
        phone: String,
        address: String,
        city: String,
        state: String,
        zip: String,
        amenities: [String],
        status: String,
        earnedPoints: UInt64,
        completeDateTime: UFix64
    ): @Action {
        return <- create Action(
            image: image,
            locationName: locationName,
            locationDescription: locationDescription,
            website: website,
            phone: phone,
            address: address,
            city: city,
            state: state,
            zip: zip,
            amenities: amenities,
            status: status,
            earnedPoints: earnedPoints,
            completeDateTime: completeDateTime
        )
    }

    pub fun createMemeberPoints(): @MemberPoints{MemberPointsInterface} {
        let point: @MemberPoints{MemberPointsInterface} <- create MemberPoints()
        return <- point
    }

    pub resource Admin {

    }
        

    init() {
        self.totalSupply = 0

        self.CollectionStoragePath = /storage/ExperienceCollection
        self.CollectionPublicPath = /public/ExperienceCollection
        self.AdminStoragePath = /storage/Admin
        self.MemberPointStoragePath = /storage/MemberPoints

        self.account.save(<- create Admin(), to: MembershipCard.AdminStoragePath)

        emit ContractInitialized()
    }


}
