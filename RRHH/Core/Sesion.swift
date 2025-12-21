//
//  Sesion.swift
//  RRHH
//
//  Created by Percy Valverde on 20/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import Foundation

final class Sesion {
    static let shared = Sesion()
    private init() {}
    var usuario: Usuario?
    
    func cerrarSesion() {
        usuario = nil
    }
}

