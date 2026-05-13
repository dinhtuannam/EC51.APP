//
//  AlxInputField.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation

@Observable
final class AlxInputField<T> {
    var value: T?
    var errorMsg: String = ""
    var error: Bool {
        return !errorMsg.isEmpty
    }
    
    init(value: T) {
        self.value = value
    }
    
    func clear() {
        value = nil
        errorMsg = ""
    }
    
    func clearErr() {
        errorMsg = ""
    }
}
