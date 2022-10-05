

import Foundation

///Mappable model protocol
protocol Mappable {
    init(fromJson json : JSON)
}

class NotificationModel {

    var content : String!
    var createdAt : String!
    var profileImage : String!


    init(content: String, createdAt: String, profileImage: String) {
        self.content = content
        self.createdAt = createdAt
        self.profileImage = profileImage
    }
}
