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
    case permisoPersonal
    case licenciaMedica
    case licenciaMaternidadPaternidad
    case licenciaDuelo

    var titulo: String {
        switch self {
        case .vacaciones:
            return "Vacaciones"
        case .permisoPersonal:
            return "Permiso personal"
        case .licenciaMedica:
            return "Licencia médica"
        case .licenciaMaternidadPaternidad:
            return "Licencia por maternidad / paternidad"
        case .licenciaDuelo:
            return "Licencia por duelo"
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

