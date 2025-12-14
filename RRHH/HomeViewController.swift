		
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
                
                // Título principal
                let titleLabel = UILabel()
                titleLabel.text = "Gestión de Vacaciones"
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
                    titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
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
                    stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
                ])
                
                // Agregar módulos
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
                    titulo: "Historial de Vacaciones",
                    detalle: "Revisar vacaciones pasadas",
                    icono: "clock.arrow.circlepath",
                    color: .systemGreen,
                    selector: #selector(abrirHistorial)
                ))
                
                stack.addArrangedSubview(crearModulo(
                    titulo: "Aprobaciones (Jefe)",
                    detalle: "Gestionar solicitudes del equipo",
                    icono: "checkmark.seal",
                    color: .systemPurple,
                    selector: #selector(abrirAprobaciones)
                ))
                
                stack.addArrangedSubview(crearModulo(
                    titulo: "Datos del Empleado",
                    detalle: "Información personal y laboral",
                    icono: "person.crop.circle",
                    color: .systemGray,
                    selector: #selector(abrirDatosEmpleado)
                ))
                
                 stack.addArrangedSubview(crearModulo(
                     titulo: "Áreas",
                     detalle: "Gestionar áreas de la empresa",
                     icono: "square.grid.2x2",
                     color: .systemTeal,
                     selector: #selector(abrirAreas)
                 ))
                
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
        }
