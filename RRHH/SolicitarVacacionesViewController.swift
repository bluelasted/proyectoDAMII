import UIKit

class SolicitarVacacionesViewController: UIViewController {

    // MARK: - Propiedades

    private var fechaInicioSeleccionada: Date?
    private var fechaFinSeleccionada: Date?

    private var inicioButton: UIButton!
    private var finButton: UIButton!
    private var tipoButton: UIButton!
    private var motivoTextView: UITextView!

    private var tipoSeleccionado: TipoSolicitud?
    private let solicitudService = SolicitudService()

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium   // Ej: 10 ene 2026
        f.timeStyle = .none
        return f
    }()

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Solicitar Vacaciones"

        configurarBotonAtras()
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

    // MARK: - UI

    private func setupUI() {
        // Scroll
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

        // Título y subtítulo
        let headerLabel = UILabel()
        headerLabel.text = "Nueva solicitud"
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.textColor = .label

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Completa los datos para registrar tu solicitud de vacaciones."
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerLabel)
        contentView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        // Stack principal
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])

        // MARK: Card Rango de fechas (con BOTONES)
        let fechasCard = crearCard(
            titulo: "Rango de fechas",
            icono: "calendar",
            color: .systemBlue
        )

        inicioButton = crearBotonCampo(
            titulo: "Seleccionar fecha de inicio",
            icono: "calendar.badge.clock"
        )
        inicioButton.addTarget(self, action: #selector(seleccionarFechaInicio), for: .touchUpInside)

        finButton = crearBotonCampo(
            titulo: "Seleccionar fecha de fin",
            icono: "calendar.badge.exclamationmark"
        )
        finButton.addTarget(self, action: #selector(seleccionarFechaFin), for: .touchUpInside)

        let fechasStack = UIStackView(arrangedSubviews: [inicioButton, finButton])
        fechasStack.axis = .vertical
        fechasStack.spacing = 8
        fechasStack.translatesAutoresizingMaskIntoConstraints = false

        fechasCard.addSubview(fechasStack)

        NSLayoutConstraint.activate([
            fechasStack.topAnchor.constraint(equalTo: fechasCard.topAnchor, constant: 56),
            fechasStack.leadingAnchor.constraint(equalTo: fechasCard.leadingAnchor, constant: 16),
            fechasStack.trailingAnchor.constraint(equalTo: fechasCard.trailingAnchor, constant: -16),
            fechasStack.bottomAnchor.constraint(equalTo: fechasCard.bottomAnchor, constant: -14)
        ])

        // MARK: Card Tipo de vacaciones (con estilo de ActionSheet)
        let tipoCard = crearCard(
            titulo: "Tipo de vacaciones",
            icono: "sun.max",
            color: .systemOrange
        )

        tipoButton = UIButton(type: .system)
        tipoButton.setTitle("Tipo: Seleccionar", for: .normal)
        tipoButton.setTitleColor(.label, for: .normal)
        tipoButton.contentHorizontalAlignment = .left
        tipoButton.backgroundColor = .systemBackground
        tipoButton.layer.cornerRadius = 10
        tipoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tipoButton.addTarget(self, action: #selector(seleccionarTipo), for: .touchUpInside)
        tipoButton.translatesAutoresizingMaskIntoConstraints = false

        tipoCard.addSubview(tipoButton)

        NSLayoutConstraint.activate([
            tipoButton.topAnchor.constraint(equalTo: tipoCard.topAnchor, constant: 56),
            tipoButton.leadingAnchor.constraint(equalTo: tipoCard.leadingAnchor, constant: 16),
            tipoButton.trailingAnchor.constraint(equalTo: tipoCard.trailingAnchor, constant: -16),
            tipoButton.bottomAnchor.constraint(equalTo: tipoCard.bottomAnchor, constant: -14)
        ])

        // MARK: Card Motivo
        let motivoCard = crearCard(
            titulo: "Motivo",
            icono: "text.alignleft",
            color: .systemGreen
        )

        motivoTextView = UITextView()
        motivoTextView.font = UIFont.systemFont(ofSize: 14)
        motivoTextView.textColor = .label
        motivoTextView.backgroundColor = .secondarySystemGroupedBackground
        motivoTextView.layer.cornerRadius = 10
        motivoTextView.text = "Escribe brevemente el motivo de tu solicitud..."
        motivoTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        motivoTextView.translatesAutoresizingMaskIntoConstraints = false

        motivoCard.addSubview(motivoTextView)

        NSLayoutConstraint.activate([
            motivoTextView.topAnchor.constraint(equalTo: motivoCard.topAnchor, constant: 56),
            motivoTextView.leadingAnchor.constraint(equalTo: motivoCard.leadingAnchor, constant: 16),
            motivoTextView.trailingAnchor.constraint(equalTo: motivoCard.trailingAnchor, constant: -16),
            motivoTextView.heightAnchor.constraint(equalToConstant: 100),
            motivoTextView.bottomAnchor.constraint(equalTo: motivoCard.bottomAnchor, constant: -14)
        ])

        // Botón principal
        let enviarButton = UIButton(type: .system)
        enviarButton.setTitle("Enviar solicitud", for: .normal)
        enviarButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        enviarButton.tintColor = .white
        enviarButton.backgroundColor = .systemBlue
        enviarButton.layer.cornerRadius = 14
        enviarButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        enviarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        enviarButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

        enviarButton.addTarget(self, action: #selector(enviarSolicitud), for: .touchUpInside)

        // Agregar al stack principal
        stack.addArrangedSubview(fechasCard)
        stack.addArrangedSubview(tipoCard)
        stack.addArrangedSubview(motivoCard)
        stack.addArrangedSubview(enviarButton)
    }

    // MARK: - Helpers UI

    private func crearCard(titulo: String, icono: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false

        let iconContainer = UIView()
        iconContainer.backgroundColor = color.withAlphaComponent(0.18)
        iconContainer.layer.cornerRadius = 12
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icono))
        iconView.tintColor = color
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.text = titulo
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [iconContainer, titleLabel, UIView()])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(hStack)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),

            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14)
        ])

        return card
    }

    private func crearBotonCampo(titulo: String, icono: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("  \(titulo)", for: .normal)
        button.setImage(UIImage(systemName: icono), for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }

    // MARK: - Seleccionar Tipo
    @objc private func seleccionarTipo() {
        let alert = UIAlertController(title: "Seleccionar Tipo", message: nil, preferredStyle: .actionSheet)
        
        for tipo in TipoSolicitud.allCases {
            alert.addAction(UIAlertAction(title: tipo.titulo, style: .default) { _ in
                self.tipoSeleccionado = tipo
                self.tipoButton.setTitle("Tipo: \(tipo.titulo)", for: .normal)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.tipoButton
            popover.sourceRect = self.tipoButton.bounds
        }
        
        self.present(alert, animated: true)
    }

    // MARK: - Fecha (ActionSheet con UIDatePicker)

    private func mostrarDatePicker(esInicio: Bool) {

        let titulo = esInicio ? "Selecciona la fecha de inicio" : "Selecciona la fecha de fin"
        let alert = UIAlertController(title: titulo, message: nil, preferredStyle: .alert)

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 300, height: 250)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        if esInicio {
            datePicker.minimumDate = Date()
        } else if let inicio = fechaInicioSeleccionada {
            datePicker.minimumDate = inicio
        }

        vc.view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: vc.view.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ])

        alert.setValue(vc, forKey: "contentViewController")

        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)

        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            let fecha = datePicker.date
            let textoFecha = self.dateFormatter.string(from: fecha)

            if esInicio {
                self.fechaInicioSeleccionada = fecha
                self.inicioButton.setTitle("  Inicio: \(textoFecha)", for: .normal)

                if let fin = self.fechaFinSeleccionada, fin < fecha {
                    self.fechaFinSeleccionada = fecha
                    let textoFin = self.dateFormatter.string(from: fecha)
                    self.finButton.setTitle("  Fin: \(textoFin)", for: .normal)
                }

            } else {
                self.fechaFinSeleccionada = fecha
                self.finButton.setTitle("  Fin: \(textoFecha)", for: .normal)
            }
        }

        alert.addAction(cancelar)
        alert.addAction(aceptar)

        present(alert, animated: true)
    }

    @objc private func seleccionarFechaInicio() {
        mostrarDatePicker(esInicio: true)
    }

    @objc private func seleccionarFechaFin() {
        mostrarDatePicker(esInicio: false)
    }

    // MARK: - Acciones

    @objc private func enviarSolicitud() {
        guard let usuario = Sesion.shared.usuario else {
            AppUtils.mostrarAlerta(en: self, titulo: "Error", mensaje: "No se pudo obtener la información del usuario.")
            return
        }
        
        guard let fechaInicio = fechaInicioSeleccionada else {
            AppUtils.mostrarAlerta(en: self, titulo: "Campos incompletos", mensaje: "Por favor selecciona la fecha de inicio.")
            return
        }
        
        guard let fechaFin = fechaFinSeleccionada else {
            AppUtils.mostrarAlerta(en: self, titulo: "Campos incompletos", mensaje: "Por favor selecciona la fecha de fin.")
            return
        }
        
        guard fechaFin > fechaInicio else {
            AppUtils.mostrarAlerta(en: self, titulo: "Fechas inválidas", mensaje: "La fecha de fin debe ser posterior a la fecha de inicio.")
            return
        }
        
        guard let tipo = tipoSeleccionado else {
            AppUtils.mostrarAlerta(en: self, titulo: "Campos incompletos", mensaje: "Por favor selecciona el tipo de vacaciones.")
            return
        }
        
        if let errorValidacion = ValidarSolicitudes.validar(tipo: tipo, fechaInicio: fechaInicio, fechaFin: fechaFin, fechaIngreso: usuario.fechaIngreso)
        {
            AppUtils.mostrarAlerta(en: self, titulo: "Error", mensaje: errorValidacion.localizedDescription)
            return
        }
        
        let motivo = motivoTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let nuevaSolicitud = Solicitud(
            id: UUID().uuidString,
            usuarioId: usuario.id,
            usuarioNombre: "\(usuario.nombre) \(usuario.apellido)",
            areaId: usuario.areaId,
            areaNombre: usuario.areaNombre,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            tipoSolicitud: tipo,
            motivo: motivo,
            fechaCreacion: Date(),
            fechaResolucion: nil,
            estado: .pendiente,
        )
        
        let loadingAlert = UIAlertController(title: nil, message: "Enviando solicitud...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)
        
        solicitudService.crearSolicitud(nuevaSolicitud) { [weak self] error in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    guard let self = self else { return }
                    
                    if let error = error {
                        AppUtils.mostrarAlerta(
                            en: self,
                            titulo: "Error",
                            mensaje: "No se pudo enviar la solicitud: \(error.localizedDescription)"
                        )
                    } else {
                        AppUtils.mostrarAlerta(
                            en: self,
                            titulo: "¡Solicitud enviada!",
                            mensaje: "Tu solicitud de vacaciones ha sido registrada exitosamente."
                        ) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
