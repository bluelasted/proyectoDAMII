import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
    }
    
    private func setupUI() {
        // Scroll por si en pantallas pequeñas no entra todo
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // MARK: - Header con datos del usuario
        let headerCard = UIView()
        headerCard.backgroundColor = .systemBlue
        headerCard.layer.cornerRadius = 20
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerCard)
        
        NSLayoutConstraint.activate([
            headerCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
        // Obtener usuario de la sesión
        guard let usuario = Sesion.shared.usuario else {
            return
        }
            
        // Icono del usuario
        let avatarContainer = UIView()
        avatarContainer.backgroundColor = .white.withAlphaComponent(0.2)
        avatarContainer.layer.cornerRadius = 30
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarIcon = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        avatarIcon.tintColor = .white
        avatarIcon.contentMode = .scaleAspectFit
        avatarIcon.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarIcon)
        
        NSLayoutConstraint.activate([
            avatarIcon.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarIcon.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarIcon.widthAnchor.constraint(equalToConstant: 35),
            avatarIcon.heightAnchor.constraint(equalToConstant: 35),
            avatarContainer.widthAnchor.constraint(equalToConstant: 60),
            avatarContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Nombre del usuario
        let nombreLabel = UILabel()
        nombreLabel.text = "\(usuario.nombre) \(usuario.apellido)"
        nombreLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nombreLabel.textColor = .white
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Rol y área
        let infoLabel = UILabel()
        infoLabel.text = "\(usuario.rol.titulo) • \(usuario.areaNombre)"
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        infoLabel.textColor = .white.withAlphaComponent(0.85)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Email
        let emailLabel = UILabel()
        emailLabel.text = usuario.email
        emailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        emailLabel.textColor = .white.withAlphaComponent(0.75)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack con info del usuario
        let infoStack = UIStackView(arrangedSubviews: [nombreLabel, infoLabel, emailLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Botón cerrar sesión
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.tintColor = .white
        logoutButton.backgroundColor = .white.withAlphaComponent(0.2)
        logoutButton.layer.cornerRadius = 20
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 40),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Stack horizontal con avatar e info
        let userStack = UIStackView(arrangedSubviews: [avatarContainer, infoStack])
        userStack.axis = .horizontal
        userStack.spacing = 14
        userStack.alignment = .center
        userStack.translatesAutoresizingMaskIntoConstraints = false
        
        headerCard.addSubview(userStack)
        headerCard.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            userStack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 20),
            userStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            userStack.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor, constant: -12),
            userStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -20),
            
            logoutButton.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20)
        ])
        
        // Título principal
        let titleLabel = UILabel()
        titleLabel.text = "Gestión de Solicitudes"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtítulo
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Administra solicitudes, aprobaciones y tu historial en un solo lugar."
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // Stack para las tarjetas
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Agregar módulos
        agregarModulos(al: stack, rol: usuario.rol)
        
        // Definir el bottom del contentView después del stack para que funcione el scroll
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Método para crear tarjetas de módulo
    private func crearModulo(
        titulo: String,
        detalle: String,
        icono: String,
        color: UIColor,
        selector: Selector
    ) -> UIView {
        
        let card = UIButton(type: .system)
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        card.tintColor = .label
        card.contentHorizontalAlignment = .leading
        
        // Acción del botón
        card.addTarget(self, action: selector, for: .touchUpInside)
        
        // Icono
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = color.withAlphaComponent(0.15)
        iconContainer.layer.cornerRadius = 12
        
        let icon = UIImageView(image: UIImage(systemName: icono))
        icon.tintColor = color
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Título y detalle
        let titleLabel = UILabel()
        titleLabel.text = titulo
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        
        let detailLabel = UILabel()
        detailLabel.text = detalle
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 2
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        // Flecha a la derecha
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .tertiaryLabel
        
        // Stack horizontal
        let hStack = UIStackView(arrangedSubviews: [iconContainer, textStack, UIView(), chevron])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 14
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
        
        return card
    }
    
    // MARK: - Cerrar sesión
    @objc private func cerrarSesion() {
        let alert = UIAlertController(
            title: "Cerrar sesión",
            message: "¿Estás seguro que deseas cerrar tu sesión?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cerrar sesión", style: .destructive) { _ in
            // Limpiar la sesión
            Sesion.shared.usuario = nil
            
            // Volver al login
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
                
                // Animación suave
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Acciones de los módulos
    @objc private func abrirSolicitarVacaciones() {
        let vc = SolicitarVacacionesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func abrirSolicitudesPendientes() {
        let vc = SolicitudesPendientesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func abrirHistorial() {
        let vc = HistorialVacacionesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func abrirAprobaciones() {
        let vc = AprobacionesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func abrirDatosEmpleado() {
        let vc = DatosEmpleadoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func abrirAreas() {
        let vc = AreasViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func agregarModulos(al stack: UIStackView, rol: Rol) {
        stack.addArrangedSubview(crearModulo(
            titulo: "Solicitar Vacaciones",
            detalle: "Registrar una nueva solicitud",
            icono: "calendar.badge.plus",
            color: .systemBlue,
            selector: #selector(abrirSolicitarVacaciones)
        ))
        
        stack.addArrangedSubview(crearModulo(
            titulo: "Solicitudes Pendientes",
            detalle: "Ver estado de tus solicitudes",
            icono: "tray.full",
            color: .systemOrange,
            selector: #selector(abrirSolicitudesPendientes)
        ))
        
        stack.addArrangedSubview(crearModulo(
            titulo: "Historial de Solicitudes",
            detalle: "Revisar las vacaciones aprobadas o rechazadas",
            icono: "clock.arrow.circlepath",
            color: .systemGreen,
            selector: #selector(abrirHistorial)
        ))

        if rol == .JEFE_DE_AREA || rol == .ADMINISTRADOR {
            stack.addArrangedSubview(crearModulo(
                titulo: "Aprobaciones (Jefe o Admin)",
                detalle: "Gestionar solicitudes del equipo",
                icono: "checkmark.seal",
                color: .systemPurple,
                selector: #selector(abrirAprobaciones)
            ))
            
            stack.addArrangedSubview(crearModulo(
                titulo: "Usuarios",
                detalle: "Información personal y laboral",
                icono: "person.crop.circle",
                color: .systemGray,
                selector: #selector(abrirDatosEmpleado)
            ))
        }

        if rol == .ADMINISTRADOR {
            stack.addArrangedSubview(crearModulo(
                titulo: "Áreas",
                detalle: "Gestionar áreas de la empresa",
                icono: "square.grid.2x2",
                color: .systemTeal,
                selector: #selector(abrirAreas)
            ))
        }
    }

}
