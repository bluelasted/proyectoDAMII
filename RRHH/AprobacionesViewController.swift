import UIKit

class AprobacionesViewController: UIViewController {
    
    private let solicitudService = SolicitudService()
    private var solicitudes: [Solicitud] = []
    private var stackSolicitudes: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Aprobaciones"
        configurarBotonAtras()
        setupUI()
        cargarSolicitudes()
    }
    
     override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              navigationController?.setNavigationBarHidden(false, animated: true)
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
          @objc private func volverAtras(){
              navigationController?.popViewController(animated: true)
          }
       
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
        headerLabel.text = "Solicitudes del equipo"
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .label
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        stackSolicitudes = UIStackView()
        stackSolicitudes.axis = .vertical
        stackSolicitudes.spacing = 14
        stackSolicitudes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackSolicitudes)

        NSLayoutConstraint.activate([
            stackSolicitudes.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
            stackSolicitudes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackSolicitudes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackSolicitudes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func crearTarjetaAprobacion(solicitud: Solicitud) -> UIView {

        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.shadowOpacity = 0.06
        card.translatesAutoresizingMaskIntoConstraints = false

        let iconConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)

        let iconView = UIImageView(
            image: UIImage(systemName: iconoPorTipo(solicitud.tipoSolicitud),
                           withConfiguration: iconConfig)
        )

        iconView.tintColor = .systemPurple
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = solicitud.usuarioNombre
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        let rangeLabel = UILabel()
        rangeLabel.text = formatearRango(
            inicio: solicitud.fechaInicio,
            fin: solicitud.fechaFin
        )
        rangeLabel.font = .systemFont(ofSize: 13)
        rangeLabel.textColor = .secondaryLabel

        let motivoLabel = UILabel()
        motivoLabel.text = solicitud.motivo
        motivoLabel.font = .systemFont(ofSize: 13)
        motivoLabel.textColor = .secondaryLabel

        let estadoBadge = crearBadgeEstado(solicitud.estado)

        let textStack = UIStackView(arrangedSubviews: [
            nameLabel,
            rangeLabel,
            motivoLabel,
            estadoBadge
        ])
        textStack.axis = .vertical
        textStack.spacing = 4

        let topStack = UIStackView(arrangedSubviews: [iconView, textStack, UIView()])
        topStack.axis = .horizontal
        topStack.spacing = 10
        topStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(topStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),
            topStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            topStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            topStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14)
        ])

        // 🔥 SOLO SI ESTÁ PENDIENTE → BOTONES
        if solicitud.estado == .pendiente {
            let approveButton = UIButton(type: .system)
            approveButton.setTitle(" Aprobar", for: .normal)
            approveButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            approveButton.tintColor = .white
            approveButton.backgroundColor = .systemGreen
            approveButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            approveButton.layer.cornerRadius = 10
            approveButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 12)
            approveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)

            approveButton.addAction(UIAction { [weak self] _ in
                self?.actualizarEstado(solicitud, nuevoEstado: .aprobada)
            }, for: .touchUpInside)


            let rejectButton = UIButton(type: .system)
            rejectButton.setTitle(" Rechazar", for: .normal)
            rejectButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            rejectButton.tintColor = .systemRed
            rejectButton.backgroundColor = .systemBackground
            rejectButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            rejectButton.layer.cornerRadius = 10
            rejectButton.layer.borderWidth = 1
            rejectButton.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.4).cgColor
            rejectButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 12)
            rejectButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)

            rejectButton.addAction(UIAction { [weak self] _ in
                self?.actualizarEstado(solicitud, nuevoEstado: .rechazada)
            }, for: .touchUpInside)

            let buttonsStack = UIStackView(arrangedSubviews: [approveButton, rejectButton])
            buttonsStack.axis = .horizontal
            buttonsStack.spacing = 8
            buttonsStack.translatesAutoresizingMaskIntoConstraints = false

            card.addSubview(buttonsStack)

            NSLayoutConstraint.activate([
                buttonsStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 10),
                buttonsStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
                buttonsStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
            ])
        } else {
            NSLayoutConstraint.activate([
                topStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
            ])
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tarjetaTapped(_:)))
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true

        card.accessibilityHint = solicitud.id

        return card
    }
    
    @objc private func tarjetaTapped(_ sender: UITapGestureRecognizer) {
        guard
            let card = sender.view,
            let solicitudId = card.accessibilityHint,
            let solicitud = solicitudes.first(where: { $0.id == solicitudId })
        else { return }

        verDetalleSolicitud(solicitud)
    }
    
    private func actualizarEstado(_ solicitud: Solicitud, nuevoEstado: EstadoSolicitud) {
        solicitudService.actualizarEstadoSolicitud(
            solicitudId: solicitud.id,
            estado: nuevoEstado
        ) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                AppUtils.mostrarAlerta(
                    en: self,
                    titulo: "Error",
                    mensaje: error.localizedDescription
                )
                return
            }

            if nuevoEstado != .pendiente {
                self.solicitudes.removeAll { $0.id == solicitud.id }
            }

            self.renderizarSolicitudes()
        }
    }
    
    private func cargarSolicitudes() {
        solicitudService.obtenerSolicitudes { [weak self] solicitudes, error in
            guard let self = self else { return }

            if let error = error {
                AppUtils.mostrarAlerta(
                    en: self,
                    titulo: "Error",
                    mensaje: error.localizedDescription
                )
                return
            }

            self.solicitudes = (solicitudes ?? []).filter {
                $0.estado == .pendiente
            }
            self.renderizarSolicitudes()
        }
    }
    
    private func renderizarSolicitudes() {
        stackSolicitudes.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if solicitudes.isEmpty {
            let label = UILabel()
            label.text = "No hay solicitudes pendientes"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            stackSolicitudes.addArrangedSubview(label)
            return
        }

        for solicitud in solicitudes {
            let card = crearTarjetaAprobacion(solicitud: solicitud)
            stackSolicitudes.addArrangedSubview(card)
        }
    }

    private func formatearRango(inicio: Date, fin: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        if Calendar.current.isDate(inicio, inSameDayAs: fin) {
            return formatter.string(from: inicio)
        }
        
        return "\(formatter.string(from: inicio)) - \(formatter.string(from: fin))"
    }

    private func iconoPorTipo(_ tipo: TipoSolicitud) -> String {
        switch tipo {
        case .vacaciones: return "sun.max.fill"
        case .permisoPersonal: return "person.fill"
        case .licenciaMedica: return "heart.text.square"
        case .licenciaMaternidadPaternidad: return "figure.and.child.holdinghands"
        case .licenciaDuelo: return "cross.fill"
        }
    }
    
    private func crearBadgeEstado(_ estado: EstadoSolicitud) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        switch estado {
        case .pendiente:
            label.text = "PENDIENTE"
            label.textColor = .systemOrange
            label.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)

        case .aprobada:
            label.text = "APROBADA"
            label.textColor = .systemGreen
            label.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)

        case .rechazada:
            label.text = "RECHAZADA"
            label.textColor = .systemRed
            label.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)

        default:
            label.text = estado.rawValue.uppercased()
            label.textColor = .systemGray
            label.backgroundColor = UIColor.systemGray.withAlphaComponent(0.15)
        }

        return label
    }
    
    private func verDetalleSolicitud(_ solicitud: Solicitud) {
        let detalleVC = DetalleSolicitudViewController(solicitud: solicitud)
        navigationController?.pushViewController(detalleVC, animated: true)
    }
}


