//
//  Assembler+Extensions.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import Foundation
import Swinject

extension Assembler {
    static let sharedAssembler: Assembler = {
        let container = Container()
        let assembler = Assembler([
            ServiceAssembly(),
            HomeAssembly(),
            AuthorizationAssembly()
        ], container: container)
        return assembler
    }()
}
