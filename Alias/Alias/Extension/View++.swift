//
//  View++.swift
//  Alias
//
//  Created by mkll on 6/8/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import SwiftUI

extension View {
    
    /// 基于 NavigationLink 跳转，但避免了因为出现在 List 中而出现详情指示器 `>`
    /// ，在 Cell 中调用即可实现跳转
    /// - Parameter destination: 要跳转的界面
    func navigationLink<Destination: View>(destination: Destination) -> some View {
        background(
            NavigationLink(destination: destination) {
                EmptyView() // 不需要实际的 Label 视图，EmtpyView 即可
            }
                .frame(width: 0, height: 0) // 避免占用空间
                .opacity(0) // 不可见
        )
    }
    
}
