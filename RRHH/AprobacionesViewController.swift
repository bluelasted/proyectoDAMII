import UIKit

class AprobacionesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Aprobaciones"
            configurarBotonAtras()
        setupUI()
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

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        stack.addArrangedSubview(crearTarjetaAprobacion(
            empleado: "Juan Pérez",
            rango: "10 - 14 Enero 2026",
            motivo: "Viaje familiar",
            icono: "person.fill.badge.plus"
        ))

        stack.addArrangedSubview(crearTarjetaAprobacion(
            empleado: "María López",
            rango: "02 Feb 2026",
            motivo: "Cita médica",
            icono: "heart.text.square"
        ))
    }

    private func crearTarjetaAprobacion(empleado: String,
                                        rango: String,
                                        motivo: String,
                                        icono: String) -> UIView {

        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 4
        card.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icono))
        iconView.tintColor = .systemPurple
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = empleado
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        let rangeLabel = UILabel()
        rangeLabel.text = rango
        rangeLabel.font = UIFont.systemFont(ofSize: 13)
        rangeLabel.textColor = .secondaryLabel

        let motivoLabel = UILabel()
        motivoLabel.text = motivo
        motivoLabel.font = UIFont.systemFont(ofSize: 13)
        motivoLabel.textColor = .secondaryLabel

        let textStack = UIStackView(arrangedSubviews: [nameLabel, rangeLabel, motivoLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let approveButton = UIButton(type: .system)
        approveButton.setTitle("Aprobar", for: .normal)
        approveButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        approveButton.tintColor = .white
        approveButton.backgroundColor = .systemGreen
        approveButton.layer.cornerRadius = 10
        approveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        approveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        approveButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        approveButton.addTarget(self, action: #selector(aprobarSolicitud), for: .touchUpInside)

        let rejectButton = UIButton(type: .system)
        rejectButton.setTitle("Rechazar", for: .normal)
        rejectButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        rejectButton.tintColor = .systemRed
        rejectButton.backgroundColor = .systemBackground
        rejectButton.layer.cornerRadius = 10
        rejectButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        rejectButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
        rejectButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        rejectButton.addTarget(self, action: #selector(rechazarSolicitud), for: .touchUpInside)

        let buttonsStack = UIStackView(arrangedSubviews: [approveButton, rejectButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8

        let topStack = UIStackView(arrangedSubviews: [iconView, textStack, UIView()])
        topStack.axis = .horizontal
        topStack.spacing = 10
        topStack.alignment = .top
        topStack.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(topStack)
        card.addSubview(buttonsStack)

        buttonsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),

            topStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            topStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            topStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),

            buttonsStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 10),
            buttonsStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            buttonsStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])

        return card
    }

    @objc private func aprobarSolicitud() {
        print("Solicitud aprobada ✅")
    }

    @objc private func rechazarSolicitud() {
        print("solicitud aprobada")
    }
}


