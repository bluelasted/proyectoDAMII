import UIKit

class SolicitudesPendientesViewController: UIViewController {

    // Modelo simple para la solicitud
    struct SolicitudPendiente {
        let rangoFechas: String
        let tipo: String
        let motivo: String
        let estado: String
        let icono: String
        let enviadoEl: String
    }

    private var solicitudes: [SolicitudPendiente] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Solicitudes Pendientes"

        configurarBotonAtras()
        cargarSolicitudesDemo()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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

    // MARK: - Data demo

    private func cargarSolicitudesDemo() {
        solicitudes = [
            SolicitudPendiente(
                rangoFechas: "15 - 20 Enero 2026",
                tipo: "Vacaciones anuales",
                motivo: "Viaje familiar a la playa.",
                estado: "Pendiente",
                icono: "airplane",
                enviadoEl: "02 Ene 2026"
            ),
            SolicitudPendiente(
                rangoFechas: "02 Febrero 2026",
                tipo: "Día personal",
                motivo: "Trámite personal en la mañana.",
                estado: "En revisión",
                icono: "person.badge.clock",
                enviadoEl: "25 Ene 2026"
            ),
            SolicitudPendiente(
                rangoFechas: "10 - 12 Marzo 2026",
                tipo: "Licencia médica",
                motivo: "Controles médicos programados.",
                estado: "Pendiente",
                icono: "stethoscope",
                enviadoEl: "01 Mar 2026"
            )
        ]
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

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        // Crear una tarjeta por cada solicitud
        for (index, solicitud) in solicitudes.enumerated() {
            let card = crearTarjetaSolicitud(solicitud: solicitud, index: index)
            stack.addArrangedSubview(card)
        }
    }

    private func crearTarjetaSolicitud(solicitud: SolicitudPendiente,
                                       index: Int) -> UIView {

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

        card.tag = index   // para saber qué solicitud se tocó
        card.addTarget(self, action: #selector(verDetalleSolicitud(_:)), for: .touchUpInside)

        let iconView = UIImageView(image: UIImage(systemName: solicitud.icono))
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        let titleLabel = UILabel()
        titleLabel.text = solicitud.rangoFechas
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label

        let detailLabel = UILabel()
        detailLabel.text = solicitud.tipo
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let estadoColor: UIColor = (solicitud.estado == "En revisión") ? .systemBlue : .systemOrange

        let estadoLabel = UILabel()
        estadoLabel.text = "  \(solicitud.estado)  "
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

    // MARK: - Navegación al detalle

    @objc private func verDetalleSolicitud(_ sender: UIButton) {
        let index = sender.tag
        guard index >= 0, index < solicitudes.count else { return }

        let solicitud = solicitudes[index]
        let detalleVC = DetalleSolicitudViewController(solicitud: solicitud)
        navigationController?.pushViewController(detalleVC, animated: true)
    }
}
