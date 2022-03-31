//
//  git.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation
import Shell

struct Git {
    private static func execute(_ args: String...) -> Int32 {
        Shell.execute(["git"] + args) { string in
            print(string, terminator: "")
        }
    }
    
    static func clone(from url: URL, to path: String) -> Int32 {
        execute("clone", "--single-branch", "--depth", "1", url.absoluteString, path)
    }
}
