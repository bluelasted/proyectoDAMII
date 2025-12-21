//
//  AppUtils.swift
//  RRHH
//
//  Created by Percy Valverde on 20/12/25.
//  Copyright © 2025 Los malditos de cibertec. All rights reserved.
//

import UIKit

struct AppUtils {
    
    // MARK: Alertas
    static func mostrarAlerta(en viewController: UIViewController, titulo: String,
                              mensaje: String, accion: (() -> Void)? = nil) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            accion?()
        }
        alerta.addAction(accionAceptar)
        viewController.present(alerta, animated: true, completion: nil)
    }
    
}
