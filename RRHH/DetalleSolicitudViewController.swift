import UIKit

class DetalleSolicitudViewController: UIViewController {

    // Recibimos la solicitud desde la lista
    private let solicitud: Solicitud

    // Init personalizado
    init(solicitud: Solicitud) {
        self.solicitud = solicitud
        super.init(nibName: nil, bundle: nil)
    }

    // Requerido por UIKit (no lo vamos a usar con Storyboard)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Detalle de solicitud"

        configurarBotonAtras()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Botón atrás

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

        // Card principal
        let mainCard = UIView()
        mainCard.backgroundColor = .secondarySystemGroupedBackground
        mainCard.layer.cornerRadius = 18
        mainCard.layer.shadowColor = UIColor.black.cgColor
        mainCard.layer.shadowOpacity = 0.08
        mainCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        mainCard.layer.shadowRadius = 6
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainCard)

        NSLayoutConstraint.activate([
            mainCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            mainCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        // Icono según el tipo
        let iconoNombre = obtenerIcono(para: solicitud.tipoSolicitud)
        let iconView = UIImageView(image: UIImage(systemName: iconoNombre))
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Formatear fechas para el rango
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let fechaInicioStr = dateFormatter.string(from: solicitud.fechaInicio)
        let fechaFinStr = dateFormatter.string(from: solicitud.fechaFin)

        // Labels principales
        let rangoLabel = UILabel()
        rangoLabel.text = "\(fechaInicioStr) - \(fechaFinStr)"
        rangoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        rangoLabel.textColor = .label

        let tipoLabel = UILabel()
        tipoLabel.text = solicitud.tipoSolicitud.titulo
        tipoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tipoLabel.textColor = .secondaryLabel

        let headerTextStack = UIStackView(arrangedSubviews: [rangoLabel, tipoLabel])
        headerTextStack.axis = .vertical
        headerTextStack.spacing = 2

        // Estado
        let estadoColor = obtenerColorEstado()
        let estadoTexto = obtenerTextoEstado()

        let estadoLabel = UILabel()
        estadoLabel.text = "  \(estadoTexto)  "
        estadoLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        estadoLabel.textColor = .white
        estadoLabel.backgroundColor = estadoColor
        estadoLabel.layer.cornerRadius = 12
        estadoLabel.clipsToBounds = true

        let headerStack = UIStackView(arrangedSubviews: [iconView, headerTextStack, UIView(), estadoLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        mainCard.addSubview(headerStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -16)
        ])

        // Separador
        let separator = UIView()
        separator.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        mainCard.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])

        // Formatear fecha de creación
        let fechaCreacionStr = dateFormatter.string(from: solicitud.fechaCreacion)

        // Calcular días de duración
        let dias = Calendar.current.dateComponents([.day], from: solicitud.fechaInicio, to: solicitud.fechaFin).day ?? 0
        let duracionTexto = "\(dias + 1) día(s)"

        // Labels de detalle
        var detalleViews: [UIView] = []
        
        detalleViews.append(crearLabelTitulo("Solicitante"))
        detalleViews.append(crearLabelValor(solicitud.usuarioNombre))
        
        detalleViews.append(crearLabelTitulo("Área"))
        detalleViews.append(crearLabelValor(solicitud.areaNombre))
        
        detalleViews.append(crearLabelTitulo("Enviada el"))
        detalleViews.append(crearLabelValor(fechaCreacionStr))
        
        detalleViews.append(crearLabelTitulo("Duración"))
        detalleViews.append(crearLabelValor(duracionTexto))
        
        detalleViews.append(crearLabelTitulo("Tipo de solicitud"))
        detalleViews.append(crearLabelValor(solicitud.tipoSolicitud.titulo))

        // Motivo
        if !solicitud.motivo.isEmpty {
            detalleViews.append(crearLabelTitulo("Motivo"))
            let motivoValor = crearLabelValor(solicitud.motivo)
            motivoValor.numberOfLines = 0
            detalleViews.append(motivoValor)
        }

        // Observaciones (si existen)
        if let observaciones = solicitud.observaciones, !observaciones.isEmpty {
            detalleViews.append(crearLabelTitulo("Observaciones"))
            let obsValor = crearLabelValor(observaciones)
            obsValor.numberOfLines = 0
            detalleViews.append(obsValor)
        }

        // Fecha de resolución (si existe)
        if let fechaResolucion = solicitud.fechaResolucion {
            let fechaResolucionStr = dateFormatter.string(from: fechaResolucion)
            detalleViews.append(crearLabelTitulo("Resuelta el"))
            detalleViews.append(crearLabelValor(fechaResolucionStr))
        }

        let detailStack = UIStackView(arrangedSubviews: detalleViews)
        detailStack.axis = .vertical
        detailStack.spacing = 6
        detailStack.translatesAutoresizingMaskIntoConstraints = false

        mainCard.addSubview(detailStack)

        NSLayoutConstraint.activate([
            detailStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            detailStack.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 16),
            detailStack.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -16),
            detailStack.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -16)
        ])

        // Botón inferior solo si está pendiente
        if solicitud.estado == .pendiente {
            let footerButton = UIButton(type: .system)
            footerButton.setTitle("Cancelar solicitud", for: .normal)
            footerButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            footerButton.tintColor = .systemRed
            footerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            footerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
            footerButton.translatesAutoresizingMaskIntoConstraints = false
            footerButton.addTarget(self, action: #selector(cancelarSolicitud), for: .touchUpInside)

            contentView.addSubview(footerButton)

            NSLayoutConstraint.activate([
                footerButton.topAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: 24),
                footerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                footerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
            ])
        } else {
            // Si no hay botón, cerrar el constraint del mainCard al bottom
            NSLayoutConstraint.activate([
                mainCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
            ])
        }
    }

    private func crearLabelTitulo(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    private func crearLabelValor(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }

    // MARK: - Helpers

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

    private func obtenerColorEstado() -> UIColor {
        switch solicitud.estado {
        case .pendiente:
            return .systemOrange
        case .aprobada:
            return .systemGreen
        case .rechazada:
            return .systemRed
        case .anulada:
            return .systemGray
        }
    }

    private func obtenerTextoEstado() -> String {
        switch solicitud.estado {
        case .pendiente:
            return "Pendiente"
        case .aprobada:
            return "Aprobada"
        case .rechazada:
            return "Rechazada"
        case .anulada:
            return "Anulada"
        }
    }

    @objc private func cancelarSolicitud() {
        let alert = UIAlertController(
            title: "¿Cancelar solicitud?",
            message: "Esta acción no se puede deshacer. La solicitud será marcada como anulada.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sí, cancelar", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Aquí puedes implementar la lógica para anular la solicitud en Firebase
            let solicitudService = SolicitudService()
            solicitudService.actualizarEstadoSolicitud(
                solicitudId: self.solicitud.id,
                nuevoEstado: .anulada
            ) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        AppUtils.mostrarAlerta(
                            en: self,
                            titulo: "Error",
                            mensaje: "No se pudo cancelar la solicitud: \(error.localizedDescription)"
                        )
                    } else {
                        AppUtils.mostrarAlerta(
                            en: self,
                            titulo: "Solicitud cancelada",
                            mensaje: "Tu solicitud ha sido anulada exitosamente."
                        ) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
}
