import UIKit

class SolicitudesPendientesViewController: UIViewController {

    private var solicitudes: [Solicitud] = []
    private let solicitudService = SolicitudService()
    private var stackView: UIStackView!
    private var emptyStateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Solicitudes Pendientes"

        configurarBotonAtras()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        cargarSolicitudes()
    }

    // MARK: - Botón Atrás

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

    // MARK: - Cargar solicitudes desde Firebase

    private func cargarSolicitudes() {
        guard let usuario = Sesion.shared.usuario else {
            AppUtils.mostrarAlerta(en: self, titulo: "Error", mensaje: "No se pudo obtener la información del usuario.")
            return
        }

        solicitudService.obtenerSolicitudesPorUsuario(usuarioId: usuario.id) { [weak self] solicitudes, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    AppUtils.mostrarAlerta(
                        en: self,
                        titulo: "Error",
                        mensaje: "No se pudieron cargar las solicitudes: \(error.localizedDescription)"
                    )
                    self.solicitudes = []
                    self.actualizarUI()
                    return
                }

                var solicitudesFiltradas = (solicitudes ?? []).filter {
                    $0.estado == .pendiente
                }
                
                solicitudesFiltradas.sort { $0.fechaCreacion > $1.fechaCreacion }
                self.solicitudes = solicitudesFiltradas
                                
                self.actualizarUI()
            }
        }
    }

    // MARK: - UI

    private func setupUI() {
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

        let headerLabel = UILabel()
        headerLabel.text = "Tus solicitudes en revisión"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .label
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        // Stack para las tarjetas
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        // Empty state
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "No tienes solicitudes pendientes"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            emptyStateLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 60),
            emptyStateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        // Constraint de bottom dinámico
        let stackBottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        stackBottom.priority = .defaultLow
        stackBottom.isActive = true

        let emptyBottom = emptyStateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        emptyBottom.priority = .defaultLow
        emptyBottom.isActive = true
    }

    private func actualizarUI() {
        // Limpiar stack
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if solicitudes.isEmpty {
            emptyStateLabel.isHidden = false
            stackView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            stackView.isHidden = false

            for (index, solicitud) in solicitudes.enumerated() {
                let card = crearTarjetaSolicitud(solicitud: solicitud, index: index)
                stackView.addArrangedSubview(card)
            }
        }
    }

    private func crearTarjetaSolicitud(solicitud: Solicitud, index: Int) -> UIView {

        let card = UIButton(type: .system)
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.tintColor = .label
        card.contentHorizontalAlignment = .leading
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true

        card.tag = index
        card.addTarget(self, action: #selector(verDetalleSolicitud(_:)), for: .touchUpInside)

        // Icono según el tipo
        let icono = obtenerIcono(para: solicitud.tipoSolicitud)
        let iconView = UIImageView(image: UIImage(systemName: icono))
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        // Formatear fechas
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let fechaInicioStr = dateFormatter.string(from: solicitud.fechaInicio)
        let fechaFinStr = dateFormatter.string(from: solicitud.fechaFin)

        let titleLabel = UILabel()
        titleLabel.text = "\(fechaInicioStr) - \(fechaFinStr)"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label

        let detailLabel = UILabel()
        detailLabel.text = solicitud.tipoSolicitud.titulo
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        // Badge de estado
        let estadoColor: UIColor
        let estadoTexto: String
        
        switch solicitud.estado {
        case .pendiente:
            estadoColor = .systemOrange
            estadoTexto = "Pendiente"
        case .aprobada:
            estadoColor = .systemGreen
            estadoTexto = "Aprobada"
        case .rechazada:
            estadoColor = .systemRed
            estadoTexto = "Rechazada"
        case .anulada:
            estadoColor = .systemGray
            estadoTexto = "Anulada"
        }

        let estadoLabel = UILabel()
        estadoLabel.text = "  \(estadoTexto)  "
        estadoLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        estadoLabel.textColor = .white
        estadoLabel.backgroundColor = estadoColor
        estadoLabel.layer.cornerRadius = 10
        estadoLabel.clipsToBounds = true
        estadoLabel.setContentHuggingPriority(.required, for: .horizontal)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .tertiaryLabel
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [iconView, textStack, estadoLabel, chevron])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 26),

            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])

        return card
    }

    private func obtenerIcono(para tipo: TipoSolicitud) -> String {
        switch tipo {
        case .vacaciones:
            return "airplane"
        case .permisoPersonal:
            return "person.badge.clock"
        case .licenciaMedica:
            return "stethoscope"
        case .licenciaMaternidadPaternidad:
            return "figure.and.child.holdinghands"
        case .licenciaDuelo:
            return "heart.fill"
        }
    }

    // MARK: - Navegación al detalle

    @objc private func verDetalleSolicitud(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0, index < solicitudes.count else { return }

        let solicitud = solicitudes[index]
        let detalleVC = DetalleSolicitudViewController(solicitud: solicitud)
        navigationController?.pushViewController(detalleVC, animated: true)
    }
}
