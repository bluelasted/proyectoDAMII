import UIKit

class DetalleSolicitudViewController: UIViewController {

    // Recibimos la solicitud desde la lista
    private let solicitud: SolicitudesPendientesViewController.SolicitudPendiente

    // Init personalizado
    init(solicitud: SolicitudesPendientesViewController.SolicitudPendiente) {
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

        // Icono
        let iconView = UIImageView(image: UIImage(systemName: solicitud.icono))
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Labels principales
        let rangoLabel = UILabel()
        rangoLabel.text = solicitud.rangoFechas
        rangoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        rangoLabel.textColor = .label

        let tipoLabel = UILabel()
        tipoLabel.text = solicitud.tipo
        tipoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tipoLabel.textColor = .secondaryLabel

        let headerTextStack = UIStackView(arrangedSubviews: [rangoLabel, tipoLabel])
        headerTextStack.axis = .vertical
        headerTextStack.spacing = 2

        let estadoColor: UIColor = (solicitud.estado == "En revisión") ? .systemBlue : .systemOrange

        let estadoLabel = UILabel()
        estadoLabel.text = "  \(solicitud.estado)  "
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

        // Labels de detalle
        let enviadoTitulo = crearLabelTitulo("Enviada el")
        let enviadoValor  = crearLabelValor(solicitud.enviadoEl)

        let tipoTitulo = crearLabelTitulo("Tipo de vacaciones")
        let tipoValor  = crearLabelValor(solicitud.tipo)

        let motivoTitulo = crearLabelTitulo("Motivo")
        let motivoValor  = crearLabelValor(solicitud.motivo)
        motivoValor.numberOfLines = 0

        let detailStack = UIStackView(arrangedSubviews: [
            enviadoTitulo, enviadoValor,
            tipoTitulo, tipoValor,
            motivoTitulo, motivoValor
        ])
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

        // Botón inferior (placeholder)
        let footerButton = UIButton(type: .system)
        footerButton.setTitle("Ver más opciones", for: .normal)
        footerButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        footerButton.tintColor = .systemBlue
        footerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        footerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        footerButton.translatesAutoresizingMaskIntoConstraints = false
        footerButton.addTarget(self, action: #selector(tocarOpciones), for: .touchUpInside)

        contentView.addSubview(footerButton)

        NSLayoutConstraint.activate([
            footerButton.topAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: 24),
            footerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
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

    @objc private func tocarOpciones() {
        print("Más opciones para la solicitud: \(solicitud.rangoFechas)")
    }
}

