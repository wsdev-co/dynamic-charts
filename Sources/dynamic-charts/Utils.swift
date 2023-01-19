//
//  SwiftUIView.swift
//  
//
//  Created by Inagamjanov on 20/01/23.
//

import SwiftUI
import os


// MARK: Get Current Device Screen Height
public func get_os_height() -> CGFloat {
    var height_size: CGFloat = 0
#if os(iOS)
    height_size = UIScreen.main.bounds.height
#elseif os(macOS)
    height_size = NSScreen.main!.frame.height
#endif
    return height_size
}


// MARK: Get Current Device Screen Width
public func get_os_width() -> CGFloat {
    var height_size: CGFloat = 0
#if os(iOS)
    height_size = UIScreen.main.bounds.width
#elseif os(macOS)
    height_size = NSScreen.main!.frame.width
#endif
    return height_size
}
