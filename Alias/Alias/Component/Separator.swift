//
//  Separator.swift
//  Alias
//
//  Created by pan on 6/7/20.
//  Copyright © 2020 pan. All rights reserved.
//

import SwiftUI

struct Separator: View {
    let color: Color
    
    var body: some View {
        Divider()
            .overlay(color)
            .padding(.zero)
    }
    
    init(color: Color) {
        self.color = color
    }
}
