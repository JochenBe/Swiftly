//
//  Swiftly+List.swift
//  
//
//  Created by Jochen Bernard on 31/03/2022.
//

import ArgumentParser

extension Swiftly {
    struct List: ParsableCommand {
        func run() throws {
            try Swiftly.useDirectory(Swiftly.directory)
            
            let packages = try Packages.get()
            
            packages.forEach { package in
                print(package.url.path.trimmingCharacters(in: .init(charactersIn: "/")))
            }
        }
    }
}
