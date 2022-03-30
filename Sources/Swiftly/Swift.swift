//
//  Swift.swift
//  
//
//  Created by Jochen Bernard on 29/03/2022.
//

import Foundation
import Shell

struct Swift {
    private init() {}
    
    private static func execute(_ args: String...) -> Int32 {
        Shell.execute(["swift"] + args) { string in
            print(string, terminator: "")
        }
    }
    
    static func build(path: String) -> Int32 {
        let previousPath = FileManager.default.currentDirectoryPath
        
        defer {
            FileManager.default.changeCurrentDirectoryPath(previousPath)
        }
        
        FileManager.default.changeCurrentDirectoryPath(path)
        return execute("build", "-c", "release")
    }
    
    static func getBinPath(path: String) -> String {
        let previousPath = FileManager.default.currentDirectoryPath
        
        defer {
            FileManager.default.changeCurrentDirectoryPath(previousPath)
        }
        
        FileManager.default.changeCurrentDirectoryPath(path)
        return Shell.execute("swift", "build", "-c", "release", "--show-bin-path").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
