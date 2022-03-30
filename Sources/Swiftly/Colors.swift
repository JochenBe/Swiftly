//
//  Colors.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

final class Colors {
    private init() {}
    
    private static func color(_ color: UInt8, _ string: String) -> String {
        "\u{001b}[0;3\(color)m" + string + "\u{001b}[0;0m"
    }
    
    static func cyan(_ string: String) -> String {
        color(6, string)
    }
}
