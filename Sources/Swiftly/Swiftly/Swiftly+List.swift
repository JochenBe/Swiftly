//
//  Swiftly+List.swift
//  
//
//  Created by Jochen Bernard on 31/03/2022.
//

import ArgumentParser

extension Swiftly {
    struct List: ParsableCommand {
        @Flag(name: .shortAndLong, help: "List executables.")
        var executables = false
        
        func run() throws {
            try Swiftly.useDirectory(Swiftly.directory)
            
            let packages = try Packages.get()
            
            packages.forEach { package in
                print(package.url.path.trimmingCharacters(in: .init(charactersIn: "/")))
                
                if executables {
                    package.executables.forEach { executable in
                        print("  - " + executable)
                    }
                }
            }
        }
    }
}
