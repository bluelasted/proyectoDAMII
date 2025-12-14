
import UIKit

class AreasViewController: UIViewController {
    
    private let nombreTextField = UITextField()
    private let guardarButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        title = "Áreas"
        configurarBotonAtras()
        setupUI()
    }
    
    
       private func configurarBotonAtras(){
               let backButton = UIBarButtonItem(
                   image: UIImage(systemName:"chevron.left"),
                   style: .plain,
                   target: self,
                   action: #selector(volverAtras)
               )
               backButton.title = "Atras"
               navigationItem.leftBarButtonItem = backButton
           }
    
     override func viewWillAppear(_ animated: Bool) {
                 super.viewWillAppear(animated)
                 navigationController?.setNavigationBarHidden(false, animated: true)
             }
    
           @objc private func volverAtras(){
               navigationController?.popViewController(animated: true)
           }
    
    private func setupUI() {
        // Etiqueta
        let nombreLabel = UILabel()
        nombreLabel.text = "Nombre del área"
        nombreLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nombreLabel.textColor = .label
        
        // TextField
        nombreTextField.placeholder = "Ejemplo: Recursos Humanos"
        nombreTextField.borderStyle = .roundedRect
        nombreTextField.clearButtonMode = .whileEditing
        nombreTextField.autocapitalizationType = .words
        
        // Botón Guardar
        guardarButton.setTitle("Guardar", for: .normal)
        guardarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        guardarButton.backgroundColor = .systemBlue
        guardarButton.tintColor = .white
        guardarButton.layer.cornerRadius = 10
        guardarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        guardarButton.addTarget(self, action: #selector(guardarArea), for: .touchUpInside)
        
        // Stack
        let stack = UIStackView(arrangedSubviews: [nombreLabel, nombreTextField, guardarButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func guardarArea() {
        let nombre = nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if nombre.isEmpty {
            mostrarAlerta(
                titulo: "Campo vacío",
                mensaje: "Por favor, ingresa el nombre del área."
            )
            return
        }
        
        mostrarAlerta(
            titulo: "Área guardada",
            mensaje: "Se ha guardado el área: \(nombre)"
        )
        
        nombreTextField.text = ""
    }
    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
