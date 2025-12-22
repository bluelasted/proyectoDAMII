//
//  ValidarSolicitudes.swift
//  RRHH
//
//  Created by Percy Valverde on 21/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import Foundation

// MARK: - Errores de validación

enum ValidacionSolicitudError: LocalizedError {

    case antiguedadInsuficiente(String)
    case anticipacionInsuficiente(String)
    case duracionInvalida(String)

    var errorDescription: String? {
        switch self {
        case .antiguedadInsuficiente(let msg),
             .anticipacionInsuficiente(let msg),
             .duracionInvalida(let msg):
            return msg
        }
    }
}

// MARK: - Validador de solicitudes

struct ValidarSolicitudes {

    static func validar(tipo: TipoSolicitud, fechaInicio: Date, fechaFin: Date, fechaIngreso: Date
    ) -> ValidacionSolicitudError? {

        let calendar = Calendar.current
        let hoy = Date()

        let duracion = calendar.dateComponents([.day], from: fechaInicio, to: fechaFin).day ?? 0
        let diasAnticipacion = calendar.dateComponents([.day], from: hoy, to: fechaInicio).day ?? 0
        
        if fechaFin < fechaInicio {
            return .duracionInvalida("La fecha de fin no puede ser menor a la fecha de inicio.")
        }

        switch tipo {

        case .vacaciones:
            if calendar.date(byAdding: .year, value: 1, to: fechaIngreso)! > hoy {
                return .antiguedadInsuficiente(
                    "Debes tener al menos 1 año de antigüedad para solicitar vacaciones."
                )
            }

            if diasAnticipacion < 7 {
                return .anticipacionInsuficiente(
                    "Las vacaciones deben solicitarse con al menos 7 días de anticipación."
                )
            }

            if duracion < 15 || duracion > 30 {
                return .duracionInvalida(
                    "Las vacaciones deben durar entre 15 y 30 días."
                )
            }

        case .permisoPersonal:
            if diasAnticipacion < 1 {
                return .anticipacionInsuficiente(
                    "El permiso personal debe solicitarse con al menos 1 día de anticipación."
                )
            }

            if duracion < 1 || duracion > 3 {
                return .duracionInvalida(
                    "El permiso personal puede durar hasta 3 días."
                )
            }

        case .licenciaMedica:
            if duracion < 1 || duracion > 30 {
                return .duracionInvalida(
                    "La licencia médica puede durar hasta 30 días."
                )
            }

        case .licenciaMaternidadPaternidad:
            if calendar.date(byAdding: .month, value: 6, to: fechaIngreso)! > hoy {
                return .antiguedadInsuficiente(
                    "Debes tener al menos 6 meses de antigüedad para esta licencia."
                )
            }

            if diasAnticipacion < 30 {
                return .anticipacionInsuficiente(
                    "Esta licencia debe solicitarse con al menos 30 días de anticipación."
                )
            }

            if duracion != 90 {
                return .duracionInvalida(
                    "La licencia por maternidad o paternidad tiene una duración de 90 días."
                )
            }

        case .licenciaDuelo:
            if duracion != 5 {
                return .duracionInvalida(
                    "La licencia por duelo tiene una duración de 5 días."
                )
            }
        }

        return nil
    }
}

