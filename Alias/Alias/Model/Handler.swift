//
//  Parser.swift
//  Alias
//
//  Created by mkll on 6/10/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import Foundation
import SwiftUI

class Handler: Decodable {
    enum Result: CodingKey {
        case type, data
    }
    enum Carrier {
        case room([User])
        case new(User)
        case me(User)
        case message(Message)
        case all(Message)
        case offline(String)
        case null
    }
    var type: Carrier = .null
    
    required init(from decoder: Decoder) throws {
        let result = try decoder.container(keyedBy: Result.self)
        let t = try result.decode(String.self, forKey: .type)
        
        switch t {
            case "room":
                let users = try result.decode([User].self, forKey: .data)
                type = .room(users)
            case "new":
                let user = try result.decode(User.self, forKey: .data)
                type = .new(user)
            case "me":
                let user =  try result.decode(User.self, forKey: .data)
                type = .me(user)
            case "message":
                let msg = try result.decode(FakeMsg.self, forKey: .data)
                type = .message(Message(text: msg.text, createdAt: msg.createdAt, creator: msg.creator))
            case "all":
                let msg = try result.decode(FakeMsg.self, forKey: .data)
                type = .all(Message(text: msg.text, createdAt: msg.createdAt, creator: msg.creator))
            case "offline":
                let username = try result.decode(String.self, forKey: .data)
                type = .offline(username)
            default:
                print("This default case is indicated by the default keyword, and must always appear last.")
        }
    }
}
