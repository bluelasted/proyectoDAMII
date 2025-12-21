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
        validarEmailUnico(email: usuario.email, ignorando: nil) {
            error in
            if let error = error {
                completion(error)
                return
            }
            
            var usuarioNormalizado = usuario
            usuarioNormalizado.email = usuario.email.lowercased()
            
            do {
                try self.db.collection(self.collection)
                    .document(usuario.id)
                    .setData(from: usuario, merge: false, completion: completion)
            } catch let error {
                completion(error)
            }
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
        validarEmailUnico(email: usuario.email, ignorando: usuario.id) {
            error in
            if let error = error {
                completion(error)
                return
            }
            
            var usuarioNormalizado = usuario
            usuarioNormalizado.email = usuario.email.lowercased()
            
            do {
                try self.db.collection(self.collection)
                    .document(usuario.id)
                    .setData(from: usuario, merge: true, completion: completion)
            } catch let error {
                completion(error)
            }
        }
    }
    
    func obtenerUsuario(uid: String, completion: @escaping (Usuario?, Error?) -> Void) {
        db.collection(collection).document(uid)
            .getDocument {
                snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    completion(nil, NSError(
                        domain: "Usuario", code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado"]
                    ))
                    return
                }
                
                let usuario = try? snapshot.data(as: Usuario.self)
                completion(usuario, nil)
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
                            let usuario = try? document.data(as: Usuario.self)
                            completion(usuario, nil)
                        } else {
                            completion(nil, NSError(domain: "Correo o contraseña incorrectos", code: 401, userInfo: nil))
                        }
                    }
                }
        }
    
    private func validarEmailUnico(email: String, ignorando userId: String?, completion: @escaping (Error?) -> Void) {
        let emailNormalizado = email.lowercased()

        db.collection(collection).whereField("email", isEqualTo: emailNormalizado)
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(error)
                    return
                }

                if let docs = snapshot?.documents,
                   docs.contains(where: { $0.documentID != userId }) {

                    let error = NSError(domain: "Firestore", code: 409,
                        userInfo: [
                            NSLocalizedDescriptionKey: "El correo ya está registrado"
                        ]
                    )
                    completion(error)
                    return
                }

                completion(nil)
            }
    }
    
        
    
}
