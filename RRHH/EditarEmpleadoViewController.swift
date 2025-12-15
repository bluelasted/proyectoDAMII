import UIKit
import FirebaseFirestore

class EditarEmpleadoViewController: UIViewController {

    // MARK: - Usuario a editar
    var usuario: Usuario
    var onSave: ((Usuario) -> Void)?

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let nombreField = UITextField()
    private let apellidoField = UITextField()
    private let emailField = UITextField()
    private let rolField = UITextField()
    private let passwordField = UITextField()
    private let areaField = UITextField()
        
    private let areaButton = UIButton(type: .system)
    private let rolButton = UIButton(type: .system)
    private let fechaButton = UIButton(type: .system)

    private let usuarioService = UsuarioService()
    private let areasService = AreaService()
    private var areasDisponibles: [Area] = []
    private var rolDisponibles: [Rol] = Rol.allCases
    private var fechaSeleccionada: Date?

    // MARK: - Inicializador
    init(usuario: Usuario) {
        self.usuario = usuario
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editar Datos"
        view.backgroundColor = .systemGroupedBackground

        configurarBotonAtras()
        setupUI()
        cargarDatosUsuario()
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

    // MARK: - setupUI()
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

        // Crear campos
        let nombreView = crearTextField(nombreField, placeholder: "Nombre")
        let apellidoView = crearTextField(apellidoField, placeholder: "Apellido")
        let emailView = crearTextField(emailField, placeholder: "Email")
        let passwordView = crearTextField(passwordField, placeholder: "Contraseña")
        passwordField.isSecureTextEntry = true

        // Fecha Button
        fechaButton.setTitle("Fecha de ingreso: \(formatearFecha(usuario.fechaIngreso))", for: .normal)
        fechaButton.setTitleColor(.label, for: .normal)
        fechaButton.contentHorizontalAlignment = .left
        fechaButton.backgroundColor = .white
        fechaButton.layer.cornerRadius = 10
        fechaButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        fechaButton.addTarget(self, action: #selector(seleccionarFecha), for: .touchUpInside)

        // Área Button
        areaButton.setTitle("Área: \(usuario.areaNombre.isEmpty ? "Seleccionar" : usuario.areaNombre)", for: .normal)
        areaButton.setTitleColor(.label, for: .normal)
        areaButton.contentHorizontalAlignment = .left
        areaButton.backgroundColor = .white
        areaButton.layer.cornerRadius = 10
        areaButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        areaButton.addTarget(self, action: #selector(seleccionarArea), for: .touchUpInside)

        // Rol Button
        rolButton.setTitle("Rol: \(usuario.rol.titulo)", for: .normal)
        rolButton.setTitleColor(.label, for: .normal)
        rolButton.contentHorizontalAlignment = .left
        rolButton.backgroundColor = .white
        rolButton.layer.cornerRadius = 10
        rolButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        rolButton.addTarget(self, action: #selector(seleccionarRol), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nombreView, apellidoView, emailView, passwordView, fechaButton, areaButton, rolButton])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        // Botón guardar
        let guardarButton = UIButton(type: .system)
        guardarButton.setTitle("Guardar cambios", for: .normal)
        guardarButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        guardarButton.tintColor = .white
        guardarButton.backgroundColor = .systemBlue
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
        field.autocapitalizationType = .none
        return field
    }

    // MARK: - Cargar datos del usuario
    private func cargarDatosUsuario() {
        nombreField.text = usuario.nombre
        apellidoField.text = usuario.apellido
        emailField.text = usuario.email
        passwordField.text = usuario.password
        rolField.text = usuario.rol.rawValue
        areaField.text = usuario.areaNombre
    }

    // MARK: - Guardar cambios
    @objc private func guardarCambios() {
        usuario = Usuario(
            id: usuario.id,
            nombre: nombreField.text ?? usuario.nombre,
            apellido: apellidoField.text ?? usuario.apellido,
            email: emailField.text ?? usuario.email,
            password: passwordField.text ?? usuario.password,
            areaId: usuario.areaId,
            areaNombre: areaField.text ?? usuario.areaNombre,
            fechaIngreso: fechaSeleccionada ?? usuario.fechaIngreso,
            rol: Rol(rawValue: rolField.text?.lowercased() ?? usuario.rol.rawValue) ?? usuario.rol,
            activo: usuario.activo
        )

        usuarioService.actualizarUsuario(usuario) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "No se pudo guardar el usuario: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                } else {
                    self?.onSave?(self!.usuario)
                    
                    let alert = UIAlertController(
                        title: "Éxito",
                        message: "Los datos fueron actualizados correctamente.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                }
            }
        }
    }

    // MARK: - Seleccionar Área
    @objc private func seleccionarArea() {
        areasService.obtenerAreas { [weak self] areas, error in
            guard let self = self else { return }

            if let error = error {
                let alert = UIAlertController(title: "Error", message: "No se pudieron cargar las áreas: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }

            guard let areas = areas else { return }
            self.areasDisponibles = areas

            let alert = UIAlertController(title: "Seleccionar Área", message: nil, preferredStyle: .actionSheet)

            for area in areas {
                alert.addAction(UIAlertAction(title: area.descripcion, style: .default) { _ in
                    self.usuario.areaNombre = area.descripcion
                    self.usuario.areaId = area.id
                    self.areaField.text = area.descripcion
                    self.areaButton.setTitle("Área: \(area.descripcion)", for: .normal)
                })
            }

            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

            if let popover = alert.popoverPresentationController {
                popover.sourceView = self.areaButton
                popover.sourceRect = self.areaButton.bounds
            }

            self.present(alert, animated: true)
        }
    }

    // MARK: - Seleccionar Rol
    @objc private func seleccionarRol() {
        let alert = UIAlertController(title: "Seleccionar Rol", message: nil, preferredStyle: .actionSheet)
        
        for rol in Rol.allCases {
            alert.addAction(UIAlertAction(title: rol.titulo, style: .default) { _ in
                self.usuario.rol = rol
                self.rolButton.setTitle("Rol: \(rol.titulo)", for: .normal)
                self.rolField.text = rol.rawValue
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.rolButton
            popover.sourceRect = self.rolButton.bounds
        }

        self.present(alert, animated: true)
    }

    // MARK: - Seleccionar Fecha
    @objc private func seleccionarFecha() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = fechaSeleccionada ?? usuario.fechaIngreso

        let alert = UIAlertController(title: "Seleccionar fecha", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor, multiplier: 0.9)
        ])

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Seleccionar", style: .default) { _ in
            self.fechaSeleccionada = datePicker.date
            self.fechaButton.setTitle("Fecha de ingreso: \(self.formatearFecha(datePicker.date))", for: .normal)
        })

        if let popover = alert.popoverPresentationController {
            popover.sourceView = fechaButton
            popover.sourceRect = fechaButton.bounds
        }

        present(alert, animated: true)
    }

    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: fecha)
    }
}
