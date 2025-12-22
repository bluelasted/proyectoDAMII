//
//  AreaService.swift
//  RRHH
//
//  Created by Percy Valverde on 14/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import FirebaseFirestore

class AreaService {
    private let db = Firestore.firestore()
    private let collection = "areas"

    func agregarArea(_ area: Area, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collection)
                .document(area.id)
                .setData(from: area, merge: true, completion: completion)
        } catch let error {
            completion(error)
        }
    }

    func obtenerAreas(completion: @escaping ([Area]?, Error?) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                let areas = snapshot?.documents.compactMap { doc -> Area? in
                    try? doc.data(as: Area.self)
                }
                completion(areas, nil)
            }
        }
    }

    func actualizarArea(_ area: Area, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collection)
                .document(area.id)
                .setData(from: area, merge: true, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func eliminarArea(_ area: Area, completion: @escaping (Error?) -> Void) {
        db.collection("usuarios")
            .whereField("areaId", isEqualTo: area.id)
            .limit(to: 1)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(error)
                    return
                }

                if let snapshot = snapshot, !snapshot.isEmpty {
                    let error = NSError(
                        domain: "Area",
                        code: 400,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                            "No se puede eliminar el área porque tiene usuarios asignados."
                        ]
                    )
                    completion(error)
                    return
                }

                self.db.collection(self.collection)
                    .document(area.id)
                    .delete { error in
                        completion(error)
                    }
            }
    }
}
