//
//  Usuario.swift
//  RRHH
//
//  Created by Percy Valverde on 14/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import Foundation

enum Rol: String, Codable, CaseIterable {
    case USUARIO
    case ADMINISTRADOR
    case JEFE_DE_AREA

    var titulo: String {
        switch self {
        case .USUARIO:
            return "Usuario"
        case .ADMINISTRADOR:
            return "Administrador"
        case .JEFE_DE_AREA:
            return "Jefe de Área"
        }
    }
}

struct Usuario: Identifiable, Codable {
    let id: String
    var nombre: String
    var apellido: String
    var email: String
    var password: String
    var areaId: String
    var areaNombre: String
    var fechaIngreso: Date
    var rol: Rol
    var activo: Bool
}
