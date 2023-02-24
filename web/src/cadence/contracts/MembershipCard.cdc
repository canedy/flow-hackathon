import NonFungibleToken from 0xf8d6e0586b0a20c7

access(all) contract MembershipCard: NonFungibleToken {

    pub var totalSupply: UInt64

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(name: String)

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


    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64
        pub let image: String
        pub let name: String
        pub let description: String
        pub let startDateTime: UFix64
        pub let endDateTime: UFix64
        pub let totalPoints: UInt64
        pub let totalVisits: UInt64

        pub var action: @{String: Action}

        init(
            image: String,
            name: String,
            description: String,
            startDateTime: UFix64,
            endDateTime: UFix64
        ){
            self.id = self.uuid
            self.image = image
            self.name = name
            self.description = description
            self.startDateTime = startDateTime
            self.endDateTime = endDateTime
            self.totalPoints = 0
            self.totalVisits = 0
            self.action <- {}
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
        pub let startDateTime: UFix64
        pub let endDateTime: UFix64
        pub let locationName: String
        pub let locationDescription: String
        pub let website: String
        pub let phone: UInt64
        pub let address: String
        pub let city: String
        pub let state: String
        pub let zip: UInt64
        pub let amenities: [String]
        pub let status: String
        pub let earnedPoints: UInt64
        pub let completeDateTime: UFix64

        init(
            image: String,
            startDateTime: UFix64,
            endDateTime: UFix64,
            locationName: String,
            locationDescription: String,
            website: String,
            phone: UInt64,
            address: String,
            city: String,
            state: String,
            zip: UInt64,
            amenities: [String],
            status: String,
            earnedPoints: UInt64,
            completeDateTime: UFix64
        ){
            self.id = self.uuid
            self.image = image
            self.startDateTime = startDateTime
            self.endDateTime = endDateTime
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
        pub fun borrowMembershipCardNFT(id: UInt64): &MembershipCard.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow the reference: the ID of the returned reference is incorrect"
            }
        }
    }

    pub resource Collection: CollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
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


        // pub fun getNFT(id: UInt64, a: UInt64): @NonFungibleToken.NFT {
        //     let token <- self.ownedNFTs.remove(key: id) ?? panic("missing NFT")
        //     let actions <- token.getAction()  
        //     let oldAction <- actions["a1"] <- a
        //     destroy oldAction
        //     // let oldAction2 <- actions["a3"] <- action2
        //     // destroy oldAction2

        //     token.setAction(action: <- actions)
            
        //     //tbd add emit
        //     return <- token
        // }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        pub fun borrowMembershipCardNFT(id: UInt64): &MembershipCard.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &MembershipCard.NFT
            }

            return nil
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

    pub resource Admin {
        pub fun mintNFT(
            image: String,
            name: String,
            description: String,
            startDateTime: UFix64,
            endDateTime: UFix64): @MembershipCard.NFT {
            
            emit Minted(name: name)
            
            return <- create NFT(
                image: image,
                name: name,
                description: description,
                startDateTime: startDateTime,
                endDateTime: endDateTime
            )
        }

        pub fun mintAction(
            image: String,
            startDateTime: UFix64,
            endDateTime: UFix64,
            locationName: String,
            locationDescription: String,
            website: String,
            phone: UInt64,
            address: String,
            city: String,
            state: String,
            zip: UInt64,
            amenities: [String],
            status: String,
            earnedPoints: UInt64,
            completeDateTime: UFix64
        ): @Action {
            return <- create Action(
                                image: image,
                                startDateTime: startDateTime,
                                endDateTime: endDateTime,
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
    }

    pub fun createMemeberPoints(): @MemberPoints{MemberPointsInterface} {
        let point: @MemberPoints{MemberPointsInterface} <- create MemberPoints()
        return <- point
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
