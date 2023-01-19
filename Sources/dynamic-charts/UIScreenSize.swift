//
//  SwiftUIView.swift
//  
//
//  Created by Inagamjanov on 19/01/23.
//

import SwiftUI
import os

//public var ui_screen: CGSize =


func get_ui_screen() -> Bool {
    if #available(iOS 13.0, *) {
         return true
    }
}
