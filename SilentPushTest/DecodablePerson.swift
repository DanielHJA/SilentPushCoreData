//
//  Person.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-27.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit

struct DecodablePerson: Decodable {

    let id: String
    let hasBeenread: Bool = false
    let name: String
    let headline: String
    let bio: String
    let age: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case headline = "headline"
        case bio = "bio"
        case age = "age"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        headline = try container.decode(String.self, forKey: .headline)
        bio = try container.decode(String.self, forKey: .bio)
        age = try container.decode(Int.self, forKey: .age)
    }
    
    func toPersonEntity() {
        Core.shared.checkIdExist(type: Person.self, id: self.id) { (exists) in
            if !exists {
                Core.shared.add(type: Person.self) { (person) in
                    person.hasBeenRead = self.hasBeenread
                    person.id = self.id
                    person.name = self.name
                    person.headline = self.headline
                    person.bio = self.bio
                    person.age = Int32(self.age)
                    Core.shared.save()
                }
            }
        }
    }
    
}
