//
//  Chat.swift
//  Alias
//
//  Created by mkll on 6/7/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import Foundation
import SwiftUI

class Chat {
    let with: User
    var messages: [Message]

    init(with: User) {
        self.messages = []
        self.with = with
    }
}
