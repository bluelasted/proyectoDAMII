import UIKit

class SolicitarVacacionesViewController: UIViewController {

    // MARK: - Propiedades

    private var fechaInicioSeleccionada: Date?
    private var fechaFinSeleccionada: Date?

    private var inicioButton: UIButton!
    private var finButton: UIButton!

    private var tipoSeleccionadoButton: UIButton?   // Radio button seleccionado

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

        // MARK: Card Tipo de vacaciones (radio buttons)
        let tipoCard = crearCard(
            titulo: "Tipo de vacaciones",
            icono: "sun.max",
            color: .systemOrange
        )

        let vacacionesAnualesButton = crearChipButton(titulo: "Vacaciones anuales")
        let diaPersonalButton      = crearChipButton(titulo: "Día personal")
        let licenciaMedicaButton   = crearChipButton(titulo: "Licencia médica")
        let sinGoceButton          = crearChipButton(titulo: "Sin goce de haber")

        let chipsStack = UIStackView(arrangedSubviews: [
            vacacionesAnualesButton,
            diaPersonalButton,
            licenciaMedicaButton,
            sinGoceButton
        ])
        chipsStack.axis = .horizontal
        chipsStack.spacing = 8
        chipsStack.distribution = .fillEqually
        chipsStack.translatesAutoresizingMaskIntoConstraints = false

        tipoCard.addSubview(chipsStack)

        NSLayoutConstraint.activate([
            chipsStack.topAnchor.constraint(equalTo: tipoCard.topAnchor, constant: 56),
            chipsStack.leadingAnchor.constraint(equalTo: tipoCard.leadingAnchor, constant: 16),
            chipsStack.trailingAnchor.constraint(equalTo: tipoCard.trailingAnchor, constant: -16),
            chipsStack.bottomAnchor.constraint(equalTo: tipoCard.bottomAnchor, constant: -14)
        ])

        // Opcional: marcar uno por defecto
        aplicarEstiloChip(vacacionesAnualesButton, seleccionado: true)
        tipoSeleccionadoButton = vacacionesAnualesButton

        // MARK: Card Motivo
        let motivoCard = crearCard(
            titulo: "Motivo",
            icono: "text.alignleft",
            color: .systemGreen
        )

        let motivoTextView = UITextView()
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

    private func crearChipButton(titulo: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(titulo, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true

        // Estilo inicial (no seleccionado)
        aplicarEstiloChip(button, seleccionado: false)

        // Cada chip se comporta como radio button
        button.addTarget(self, action: #selector(tipoVacacionesTapped(_:)), for: .touchUpInside)

        return button
    }

    // Estilo para chips (radio buttons)
    private func aplicarEstiloChip(_ button: UIButton, seleccionado: Bool) {
        if seleccionado {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .systemBackground
            button.setTitleColor(.label, for: .normal)
        }
    }

    // Cuando se toca un tipo de vacaciones
    @objc private func tipoVacacionesTapped(_ sender: UIButton) {
        // Des-selecciona el anterior
        if let anterior = tipoSeleccionadoButton {
            aplicarEstiloChip(anterior, seleccionado: false)
        }

        // Marca el nuevo como seleccionado
        tipoSeleccionadoButton = sender
        aplicarEstiloChip(sender, seleccionado: true)

        print("Tipo de vacaciones seleccionado: \(sender.currentTitle ?? "")")
    }

    // MARK: - Fecha (ActionSheet con UIDatePicker)

    private func mostrarDatePicker(esInicio: Bool) {
        let titulo = esInicio ? "Selecciona la fecha de inicio" : "Selecciona la fecha de fin"

        let alert = UIAlertController(
            title: titulo,
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .actionSheet
        )

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
        ])

        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { _ in
            let fecha = datePicker.date
            let textoFecha = self.dateFormatter.string(from: fecha)

            if esInicio {
                self.fechaInicioSeleccionada = fecha
                self.inicioButton.setTitle("  Inicio: \(textoFecha)", for: .normal)
            } else {
                self.fechaFinSeleccionada = fecha
                self.finButton.setTitle("  Fin: \(textoFecha)", for: .normal)
            }
        }

        alert.addAction(cancelar)
        alert.addAction(aceptar)

        // Para iPad (evita crash)
        if let popover = alert.popoverPresentationController {
            popover.sourceView = esInicio ? inicioButton : finButton
            popover.sourceRect = (esInicio ? inicioButton : finButton).bounds
        }

        present(alert, animated: true, completion: nil)
    }

    @objc private func seleccionarFechaInicio() {
        mostrarDatePicker(esInicio: true)
    }

    @objc private func seleccionarFechaFin() {
        mostrarDatePicker(esInicio: false)
    }

    // MARK: - Acciones

    @objc private func enviarSolicitud() {
        let tipo = tipoSeleccionadoButton?.currentTitle ?? "Sin tipo seleccionado"
        print("Solicitud enviada (aún sin backend) 🚀")
        print("Inicio: \(String(describing: fechaInicioSeleccionada))")
        print("Fin: \(String(describing: fechaFinSeleccionada))")
        print("Tipo: \(tipo)")
    }
}
