import UIKit

class DatosEmpleadoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let nombreTextField = UITextField()
    private let agregarButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    private var usuarios: [Usuario] = []
    private let usuarioService = UsuarioService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        title = "Listado de Usuarios"
        configurarBotonAtras()
        setupUI()
        configurarTableView()
        cargarUsuarios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }
    
    // MARK: - Cargar usuarios desde UsuarioService
    private func cargarUsuarios() {
        usuarioService.obtenerUsuarios { [weak self] usuariosObtenidos, error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: "No se pudieron cargar los usuarios: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    return
                }
                
                self?.usuarios = usuariosObtenidos ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Navegación
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
    
    // MARK: - UI
    private func setupUI() {
        // Stack vertical
        let stack = UIStackView(arrangedSubviews: [agregarButton, tableView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        // --- Botón Agregar Usuario ---
        agregarButton.setTitle("Agregar usuario", for: .normal)
        agregarButton.setImage(UIImage(systemName: "plus"), for: .normal)
        agregarButton.tintColor = .white
        agregarButton.backgroundColor = .systemBlue
        agregarButton.layer.cornerRadius = 10
        agregarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        agregarButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        agregarButton.setTitleColor(.white, for: .normal)
        agregarButton.addTarget(self, action: #selector(agregarUsuario), for: .touchUpInside)
        
        // --- Tabla de Usuarios ---
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 14
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        
        // --- Constraints ---
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    // MARK: - TableView config
    private func configurarTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UsuarioCell")
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsuarioCell", for: indexPath)
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
        \(usuario.nombre) \(usuario.apellido)
        Área: \(usuario.areaNombre)
        Email: \(usuario.email)
        Rol: \(usuario.rol.titulo)
        Activo: \(usuario.activo ? "Sí" : "No")
        """
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        mostrarEditarUsuario(usuario, indexPath: indexPath)
    }
    
    // MARK: - Swipe Actions (Editar / Eliminar)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let usuario = self.usuarios[indexPath.row]
            
            let alerta = UIAlertController(
                title: "Eliminar usuario",
                message: "¿Seguro que quieres desactivar a \(usuario.nombre)?",
                preferredStyle: .alert
            )
            
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            alerta.addAction(UIAlertAction(title: "Desactivar", style: .destructive) { _ in
                var usuarioActualizado = usuario
                usuarioActualizado.activo = false
                
                self.usuarioService.actualizarUsuario(usuarioActualizado) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            let errorAlert = UIAlertController(title: "Error", message: "No se pudo desactivar el usuario: \(error.localizedDescription)", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(errorAlert, animated: true)
                        } else {
                            self.usuarios.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            })
            
            self.present(alerta, animated: true)
            completionHandler(true)
        }

        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let usuario = self.usuarios[indexPath.row]
            self.mostrarEditarUsuario(usuario, indexPath: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - Editar Usuario
    private func mostrarEditarUsuario(_ usuario: Usuario, indexPath: IndexPath) {
        let editarVC = EditarEmpleadoViewController(usuario: usuario)
        editarVC.onSave = { [weak self] usuarioGuardado in
            self?.usuarios[indexPath.row] = usuarioGuardado
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        navigationController?.pushViewController(editarVC, animated: true)
    }
    
    // MARK: - Agregar Usuario
    @objc private func agregarUsuario() {
        let nuevoUsuario = Usuario(
            id: UUID().uuidString,
            nombre: "",
            apellido: "",
            email: "",
            password: "",
            areaId: "",
            areaNombre: "",
            fechaIngreso: Date(),
            rol: .USUARIO,
            activo: true
        )
        
        let editarVC = EditarEmpleadoViewController(usuario: nuevoUsuario)
        editarVC.onSave = { [weak self] usuarioGuardado in
            self?.usuarios.append(usuarioGuardado)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(editarVC, animated: true)
    }
}
