//
//  SolicitudService.swift
//  RRHH
//
//  Created by Percy Valverde on 21/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import FirebaseFirestore

class SolicitudService {

    private let db = Firestore.firestore()
    private let collection = "solicitudes"

    func crearSolicitud(_ solicitud: Solicitud, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collection)
                .document(solicitud.id)
                .setData(from: solicitud, merge: false, completion: completion)
        } catch {
            completion(error)
        }
    }

    func obtenerSolicitudesPorUsuario(usuarioId: String, completion: @escaping ([Solicitud]?, Error?) -> Void) {
        db.collection(collection)
            .whereField("usuarioId", isEqualTo: usuarioId)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(nil, error)
                    return
                }

                var solicitudes = snapshot?.documents.compactMap {
                    try? $0.data(as: Solicitud.self)
                }
                
                solicitudes?.sort { $0.fechaCreacion > $1.fechaCreacion }

                completion(solicitudes, nil)
            }
    }
    
    func obtenerSolicitudes(completion: @escaping ([Solicitud]?, Error?) -> Void) {
        db.collection("solicitudes")
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(nil, error)
                    return
                }

                let solicitudes = snapshot?.documents.compactMap {
                    try? $0.data(as: Solicitud.self)
                }

                completion(solicitudes, nil)
            }
    }
    
    func obtenerSolicitudesPorArea(areaId: String, completion: @escaping ([Solicitud]?, Error?) -> Void) {
        db.collection("solicitudes")
            .whereField("areaId", isEqualTo: areaId)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(nil, error)
                    return
                }

                let solicitudes = snapshot?.documents.compactMap {
                    try? $0.data(as: Solicitud.self)
                }

                completion(solicitudes, nil)
            }
    }


    func obtenerSolicitud(id: String, completion: @escaping (Solicitud?, Error?) -> Void) {
        db.collection(collection)
            .document(id)
            .getDocument { snapshot, error in

                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let snapshot = snapshot, snapshot.exists else {
                    completion(nil, NSError(
                        domain: "Solicitud",
                        code: 404,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Solicitud no encontrada"
                        ]
                    ))
                    return
                }

                let solicitud = try? snapshot.data(as: Solicitud.self)
                completion(solicitud, nil)
            }
    }

    func actualizarEstadoSolicitud(solicitudId: String,nuevoEstado: EstadoSolicitud, completion: @escaping (Error?) -> Void) {
        db.collection(collection)
            .document(solicitudId)
            .updateData([
                "estado": nuevoEstado.rawValue,
                "fechaResolucion": Date()
            ], completion: completion)
    }
    
    func actualizarEstadoSolicitud(solicitudId: String, estado: EstadoSolicitud, completion: @escaping (Error?) -> Void) {
        db.collection("solicitudes")
            .document(solicitudId)
            .updateData([
                "estado": estado.rawValue,
                "fechaResolucion": Date()
            ]) { error in
                completion(error)
            }
    }

}
