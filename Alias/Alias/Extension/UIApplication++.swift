//
//  UIApplication.swift
//  Alias
//
//  Created by mkll on 6/12/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
