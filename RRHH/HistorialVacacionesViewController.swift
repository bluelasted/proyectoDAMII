import UIKit

class HistorialVacacionesViewController: UIViewController {
    private let solicitudService = SolicitudService()
    private var solicitudes: [Solicitud] = []
    private var stackSolicitudes: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Historial"
        configurarBotonAtras()
        setupUI()
        cargarHistorial()
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
        headerLabel.text = "Historial de solicitudes"
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
        stackSolicitudes.spacing = 12
        stackSolicitudes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackSolicitudes)

        NSLayoutConstraint.activate([
            stackSolicitudes.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
            stackSolicitudes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackSolicitudes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackSolicitudes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func tapSolicitud(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view else { return }
        let index = card.tag

        guard index >= 0, index < solicitudes.count else { return }

        let solicitud = solicitudes[index]
        verDetalleSolicitud(solicitud)
    }

    private func crearRegistro(
        solicitud: Solicitud,
        titulo: String,
        icono: String,
        estado: EstadoSolicitud
    ) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.05
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 100).isActive = true // un poco más alto para todo

        let iconView = UIImageView(image: UIImage(systemName: icono))
        iconView.tintColor = estado == .aprobada ? .systemGreen : .systemRed
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Usuario (primero y más grande)
        let usuarioLabel = UILabel()
        usuarioLabel.text = solicitud.usuarioNombre
        usuarioLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold) // más grande y resaltado
        usuarioLabel.textColor = .label

        // Título (fechas) - abajo
        let titleLabel = UILabel()
        titleLabel.text = titulo
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .secondaryLabel

        // Tipo + motivo - abajo también
        let tipoMotivoLabel = UILabel()
        tipoMotivoLabel.text = "\(solicitud.tipoSolicitud.titulo) – \(solicitud.motivo)"
        tipoMotivoLabel.font = UIFont.systemFont(ofSize: 13)
        tipoMotivoLabel.textColor = .secondaryLabel
        tipoMotivoLabel.numberOfLines = 2

        // Stack de texto: nombre arriba, luego fechas y tipo+motivo
        let textStack = UIStackView(arrangedSubviews: [usuarioLabel, titleLabel, tipoMotivoLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let hStack = UIStackView(arrangedSubviews: [iconView, textStack, UIView()])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 10
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 26),
            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSolicitud(_:)))
        card.addGestureRecognizer(tap)
        card.isUserInteractionEnabled = true

        card.tag = solicitudes.firstIndex(where: { $0.id == solicitud.id }) ?? -1

        return card
    }
    
    private func procesarSolicitudes(solicitudes: [Solicitud]?, error: Error?) {
        if let error = error {
            AppUtils.mostrarAlerta(en: self, titulo: "Error", mensaje: error.localizedDescription)
            return
        }
        
        self.solicitudes = (solicitudes ?? []).filter {
            $0.estado != .pendiente
        }
        
        self.renderizarHistorial()
    }
    
    private func cargarHistorial() {
        guard let usuario = Sesion.shared.usuario else {
            AppUtils.mostrarAlerta(en: self, titulo: "Error", mensaje: "No se pudo obtener la información del usuario.")
            return
        }
        
        switch usuario.rol {
        case .USUARIO:
            solicitudService.obtenerSolicitudesPorUsuario(usuarioId: usuario.id) { [weak self] solicitudes, error in
                guard let self = self else { return }
                self.procesarSolicitudes(solicitudes: solicitudes, error: error)
            }

        case .JEFE_DE_AREA:
            solicitudService.obtenerSolicitudesPorArea(areaId: usuario.areaId) { [weak self] solicitudes, error in
                guard let self = self else { return }
                self.procesarSolicitudes(solicitudes: solicitudes, error: error)
            }

        default:
            solicitudService.obtenerSolicitudes { [weak self] solicitudes, error in
                guard let self = self else { return }
                self.procesarSolicitudes(solicitudes: solicitudes, error: error)
            }
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
    
    private func renderizarHistorial() {
        stackSolicitudes.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if solicitudes.isEmpty {
            let label = UILabel()
            label.text = "No hay solicitudes en el historial"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            stackSolicitudes.addArrangedSubview(label)
            return
        }

        for solicitud in solicitudes {
            let icono = solicitud.estado == .aprobada
                ? "checkmark.seal.fill"
                : "xmark.seal.fill"

            let card = crearRegistro(
                solicitud: solicitud,
                titulo: formatearRango(
                    inicio: solicitud.fechaInicio,
                    fin: solicitud.fechaFin
                ),
                //detalle: solicitud.motivo,
                icono: icono,
                estado: solicitud.estado
            )

            stackSolicitudes.addArrangedSubview(card)
        }
    }
    
    private func verDetalleSolicitud(_ solicitud: Solicitud) {
        let detalleVC = DetalleSolicitudViewController(solicitud: solicitud)
        navigationController?.pushViewController(detalleVC, animated: true)
    }
}
