//
//  Solicitud.swift
//  RRHH
//
//  Created by Percy Valverde on 14/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import Foundation

enum TipoSolicitud: String, Codable, CaseIterable {

    case vacaciones
    case vacacionesAdelantadas
    case permiso
    case licencia

    var titulo: String {
        switch self {
        case .vacaciones:
            return "Vacaciones regulares"
        case .vacacionesAdelantadas:
            return "Vacaciones adelantadas"
        case .permiso:
            return "Permiso especial"
        case .licencia:
            return "Licencia"
        }
    }
}

enum EstadoSolicitud: String, Codable {
    case pendiente
    case aprobada
    case rechazada
    case anulada
}

struct Solicitud: Identifiable, Codable {
    let id: String
    var usuarioId: String
    var usuarioNombre: String
    var areaId: String
    var areaNombre: String

    var fechaInicio: Date
    var fechaFin: Date

    var tipoSolicitud: TipoSolicitud
    var motivo: String
    var observaciones: String?

    var fechaCreacion: Date
    var fechaResolucion: Date?

    var estado: EstadoSolicitud
}

