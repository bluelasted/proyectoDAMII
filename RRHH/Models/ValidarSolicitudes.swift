//
//  ValidarSolicitudes.swift
//  RRHH
//
//  Created by Percy Valverde on 21/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import Foundation

enum ValidacionSolicitudError: LocalizedError {
    case antiguedadInsuficiente(String)
    case anticipacionInsuficiente(String)
    case duracionInvalida(String)
    case fechaInvalida(String)

    var errorDescription: String? {
        switch self {
        case .antiguedadInsuficiente(let msg),
             .anticipacionInsuficiente(let msg),
             .duracionInvalida(let msg),
             .fechaInvalida(let msg):
            return msg
        }
    }
}

struct ValidarSolicitudes {

    static func validar(
        tipo: TipoSolicitud,
        fechaInicio: Date,
        fechaFin: Date,
        fechaIngreso: Date
    ) -> ValidacionSolicitudError? {

        let calendar = Calendar.current
        let hoy = calendar.startOfDay(for: Date())
        let inicioNormalizado = calendar.startOfDay(for: fechaInicio)
        let finNormalizado = calendar.startOfDay(for: fechaFin)
        let ingresoNormalizado = calendar.startOfDay(for: fechaIngreso)

        if ingresoNormalizado > hoy {
            return .fechaInvalida("La fecha de ingreso no puede ser futura.")
        }

        if finNormalizado < inicioNormalizado {
            return .fechaInvalida("La fecha de fin no puede ser anterior a la fecha de inicio.")
        }

        if tipo != .licenciaMedica && inicioNormalizado < hoy {
            return .anticipacionInsuficiente("No puedes crear solicitudes con fecha de inicio en el pasado.")
        }

        let duracion = calendar.dateComponents([.day], from: inicioNormalizado, to: finNormalizado).day! + 1
        let diasAnticipacion = calendar.dateComponents([.day], from: hoy, to: inicioNormalizado).day ?? 0

        switch tipo {

        case .vacaciones:
            guard let unAnioDespues = calendar.date(byAdding: .year, value: 1, to: ingresoNormalizado) else {
                return .fechaInvalida("Error al calcular la antigüedad.")
            }
            
            if unAnioDespues > hoy {
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
                    "Las vacaciones deben durar entre 15 y 30 días. Duración solicitada: \(duracion) días."
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
                    "El permiso personal puede durar entre 1 y 3 días. Duración solicitada: \(duracion) días."
                )
            }

        case .licenciaMedica:
            if inicioNormalizado < hoy {
                let diasAtras = calendar.dateComponents([.day], from: inicioNormalizado, to: hoy).day ?? 0
                if diasAtras > 7 {
                    return .anticipacionInsuficiente(
                        "La licencia médica no puede iniciarse más de 7 días en el pasado."
                    )
                }
            }

            if duracion < 1 || duracion > 30 {
                return .duracionInvalida(
                    "La licencia médica puede durar entre 1 y 30 días. Duración solicitada: \(duracion) días."
                )
            }

        case .licenciaMaternidadPaternidad:
            guard let seisMesesDespues = calendar.date(byAdding: .month, value: 6, to: ingresoNormalizado) else {
                return .fechaInvalida("Error al calcular la antigüedad.")
            }
            
            if seisMesesDespues > hoy {
                return .antiguedadInsuficiente(
                    "Debes tener al menos 6 meses de antigüedad para solicitar esta licencia."
                )
            }

            if diasAnticipacion < 30 {
                return .anticipacionInsuficiente(
                    "Esta licencia debe solicitarse con al menos 30 días de anticipación."
                )
            }

            if duracion != 90 {
                return .duracionInvalida(
                    "La licencia por maternidad o paternidad debe tener una duración de 90 días. Duración solicitada: \(duracion) días."
                )
            }

        case .licenciaDuelo:
            if duracion != 5 {
                return .duracionInvalida(
                    "La licencia por duelo debe tener una duración de 5 días. Duración solicitada: \(duracion) días."
                )
            }
        }

        return nil
    }
}
