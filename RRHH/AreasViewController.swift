import UIKit

class AreasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let nombreTextField = UITextField()
    private let guardarButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    private var areas: [Area] = []
    private let areaService = AreaService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        title = "Áreas"
        configurarBotonAtras()
        setupUI()
        cargarAreas()
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func volverAtras() {
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
        
        // Stack superior (label + textfield + button)
        let stack = UIStackView(arrangedSubviews: [nombreLabel, nombreTextField, guardarButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AreaCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // evita líneas vacías
        view.addSubview(tableView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func guardarArea() {
        let nombre = nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if nombre.isEmpty {
            mostrarAlerta(titulo: "Campo vacío", mensaje: "Por favor, ingresa el nombre del área.")
            return
        }
        
        if areas.contains(where: { $0.descripcion.lowercased() == nombre.lowercased() }) {
            mostrarAlerta(titulo: "Área duplicada", mensaje: "Ya existe un área con esa descripción.")
            return
        }
        
        let nuevaArea = Area(id: UUID().uuidString, descripcion: nombre)
        areaService.agregarArea(nuevaArea) { [weak self] error in
            if let error = error {
                self?.mostrarAlerta(titulo: "Error", mensaje: error.localizedDescription)
            } else {
                self?.areas.append(nuevaArea)
                self?.tableView.reloadData()
                self?.nombreTextField.text = ""
            }
        }
    }
    
    private func cargarAreas() {
        areaService.obtenerAreas { [weak self] areas, error in
            if let areas = areas {
                self?.areas = areas
                self?.tableView.reloadData()
            } else if let error = error {
                print("Error al cargar áreas: \(error.localizedDescription)")
            }
        }
    }
    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let area = areas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath)
        cell.textLabel?.text = area.descripcion
        return cell
    }
    
    // MARK: - TableView Delegate para acciones de swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let area = self.areas[indexPath.row]
            
            let alerta = UIAlertController(title: "Eliminar área", message: "¿Seguro que quieres eliminar '\(area.descripcion)'?", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            alerta.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                self.areaService.eliminarArea(area) { error in
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: error.localizedDescription)
                    } else {
                        self.areas.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            })
            self.present(alerta, animated: true)
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let area = self.areas[indexPath.row]
            self.mostrarEditarArea(area, indexPath: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    private func mostrarEditarArea(_ area: Area, indexPath: IndexPath) {
        let alerta = UIAlertController(title: "Editar área", message: "Modifica el nombre del área", preferredStyle: .alert)
        alerta.addTextField { textField in
            textField.text = area.descripcion
            textField.autocapitalizationType = .words
        }
        
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let nuevoNombre = alerta.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if nuevoNombre.isEmpty {
                self.mostrarAlerta(titulo: "Campo vacío", mensaje: "No puede estar vacío")
                return
            }
            
            if self.areas.contains(where: { $0.descripcion.lowercased() == nuevoNombre.lowercased() && $0.id != area.id }) {
                self.mostrarAlerta(titulo: "Duplicado", mensaje: "Ya existe un área con ese nombre")
                return
            }
            
            var areaActualizada = area
            areaActualizada.descripcion = nuevoNombre
            self.areaService.actualizarArea(areaActualizada) { error in
                if let error = error {
                    self.mostrarAlerta(titulo: "Error", mensaje: error.localizedDescription)
                } else {
                    self.areas[indexPath.row] = areaActualizada
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
        
        present(alerta, animated: true)
    }
}
