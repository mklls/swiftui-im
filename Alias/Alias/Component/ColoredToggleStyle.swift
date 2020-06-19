//
//  ColoredToggleStyle.swift
//  Alias
//
//  Created by mkll on 6/12/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    var action: (_ isOn: Bool) -> Void
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label).font(.system(size: 16))
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
                self.action(configuration.isOn)
            } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
    }
}
