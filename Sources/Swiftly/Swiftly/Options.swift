//
//  Options.swift
//  
//
//  Created by Jochen Bernard on 30/03/2022.
//

import ArgumentParser

struct Options: ParsableArguments {
    @Argument(help: "The URL of the package.")
    var url: String
}
