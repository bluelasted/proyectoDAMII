import UIKit

class EditarEmpleadoViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nombreField = UITextField()
    private let apellidoField = UITextField()
    private let emailField = UITextField()
    private let telefonoField = UITextField()
    private let cargoField = UITextField()
    private let areaField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Editar Datos"
        view.backgroundColor = .systemGroupedBackground

        configurarBotonAtras()
        setupUI()
        cargarDatosEmpleadoDemo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Back Button
    private func configurarBotonAtras() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(volverAtras)
        )
        backButton.title = "Atrás"
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func volverAtras() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let fields = [
            crearTextField(nombreField, placeholder: "Nombre"),
            crearTextField(apellidoField, placeholder: "Apellido"),
            crearTextField(emailField, placeholder: "Email"),
            crearTextField(telefonoField, placeholder: "Teléfono"),
            crearTextField(cargoField, placeholder: "Cargo"),
            crearTextField(areaField, placeholder: "Área")
        ]

        let stack = UIStackView(arrangedSubviews: fields)
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        let guardarButton = UIButton(type: .system)
        guardarButton.setTitle("Guardar cambios", for: .normal)
        guardarButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        guardarButton.tintColor = .white
        guardarButton.backgroundColor = .systemGreen
        guardarButton.layer.cornerRadius = 12
        guardarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        guardarButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        guardarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        guardarButton.addTarget(self, action: #selector(guardarCambios), for: .touchUpInside)

        guardarButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(guardarButton)

        NSLayoutConstraint.activate([
            guardarButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            guardarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            guardarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            guardarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func crearTextField(_ field: UITextField, placeholder: String) -> UIView {
        field.placeholder = placeholder
        field.font = UIFont.systemFont(ofSize: 15)
        field.backgroundColor = .white
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return field
    }

    // MARK: - Demo
    private func cargarDatosEmpleadoDemo() {
        nombreField.text = "Luis"
        apellidoField.text = "Fernández"
        emailField.text = "luis.fernandez@empresa.com"
        telefonoField.text = "+51 987 654 321"
        cargoField.text = "Analista de Sistemas"
        areaField.text = "Tecnología"
    }

    // MARK: - Guardar
    @objc private func guardarCambios() {
        print("Datos guardados:")
        print("Nombre: \(nombreField.text ?? "")")
        print("Apellido: \(apellidoField.text ?? "")")
        print("Email: \(emailField.text ?? "")")
        print("Teléfono: \(telefonoField.text ?? "")")
        print("Cargo: \(cargoField.text ?? "")")
        print("Área: \(areaField.text ?? "")")

        let alert = UIAlertController(
            title: "Éxito",
            message: "Los datos fueron actualizados correctamente.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

