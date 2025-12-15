//
//  UsuarioService.swift
//  RRHH
//
//  Created by Percy Valverde on 14/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import FirebaseFirestore

class UsuarioService {
    private let db = Firestore.firestore()
    private let collection = "usuarios"

    func agregarUsuario(_ usuario: Usuario, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collection)
                .document(usuario.id)
                .setData(from: usuario, merge: true, completion: completion)
        } catch let error {
            completion(error)
        }
    }

    func obtenerUsuarios(completion: @escaping ([Usuario]?, Error?) -> Void) {
        db.collection(collection)
            .whereField("activo", isEqualTo: true)
            .getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                let usuarios = snapshot?.documents.compactMap { doc -> Usuario? in
                    try? doc.data(as: Usuario.self)
                }
                completion(usuarios, nil)
            }
        }
    }

    func actualizarUsuario(_ usuario: Usuario, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection(collection)
                .document(usuario.id)
                .setData(from: usuario, merge: true, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func validarUsuario(email: String, password: String, completion: @escaping (Usuario?, Error?) -> Void) {
            db.collection(collection)
                .whereField("email", isEqualTo: email)
                .whereField("password", isEqualTo: password)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(nil, error)
                    } else {
                        if let document = snapshot?.documents.first {
                            // Deserializamos el usuario desde Firestore
                            let usuario = try? document.data(as: Usuario.self)
                            completion(usuario, nil)
                        } else {
                            completion(nil, NSError(domain: "Usuario no encontrado", code: 404, userInfo: nil))
                        }
                    }
                }
        }
}
