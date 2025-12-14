import UIKit

class DatosEmpleadoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Datos del Empleado"
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

        // Tarjeta de perfil
        let profileCard = UIView()
        profileCard.backgroundColor = .secondarySystemGroupedBackground
        profileCard.layer.cornerRadius = 18
        profileCard.layer.shadowColor = UIColor.black.cgColor
        profileCard.layer.shadowOpacity = 0.08
        profileCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        profileCard.layer.shadowRadius = 6
        profileCard.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(profileCard)

        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            profileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        let avatar = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatar.tintColor = .systemBlue
        avatar.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = "Empleado Demo"
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        let roleLabel = UILabel()
        roleLabel.text = "Cargo: Analista de Sistemas"
        roleLabel.font = UIFont.systemFont(ofSize: 13)
        roleLabel.textColor = .secondaryLabel

        let deptLabel = UILabel()
        deptLabel.text = "Área: Tecnología"
        deptLabel.font = UIFont.systemFont(ofSize: 13)
        deptLabel.textColor = .secondaryLabel

        let mailRow = crearFilaIcono(texto: "empleado@empresa.com", icono: "envelope")
        let phoneRow = crearFilaIcono(texto: "+51 999 999 999", icono: "phone")

        let textStack = UIStackView(arrangedSubviews: [nameLabel, roleLabel, deptLabel, mailRow, phoneRow])
        textStack.axis = .vertical
        textStack.spacing = 4

        let topStack = UIStackView(arrangedSubviews: [avatar, textStack])
        topStack.axis = .horizontal
        topStack.alignment = .top
        topStack.spacing = 12
        topStack.translatesAutoresizingMaskIntoConstraints = false

        profileCard.addSubview(topStack)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),

            topStack.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 16),
            topStack.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -16),
            topStack.bottomAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: -16),
        ])

        // Tarjeta de resumen de vacaciones
        let resumenCard = UIView()
        resumenCard.backgroundColor = .secondarySystemGroupedBackground
        resumenCard.layer.cornerRadius = 16
        resumenCard.layer.shadowColor = UIColor.black.cgColor
        resumenCard.layer.shadowOpacity = 0.08
        resumenCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        resumenCard.layer.shadowRadius = 6
        resumenCard.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(resumenCard)

        NSLayoutConstraint.activate([
            resumenCard.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 18),
            resumenCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resumenCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        let resumenTitle = UILabel()
        resumenTitle.text = "Resumen de vacaciones"
        resumenTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        let usadosLabel = crearPill(title: "Usados", value: "12 días")
        let disponiblesLabel = crearPill(title: "Disponibles", value: "8 días")
        let acumuladosLabel = crearPill(title: "Acumulados", value: "3 días")

        let pillsStack = UIStackView(arrangedSubviews: [usadosLabel, disponiblesLabel, acumuladosLabel])
        pillsStack.axis = .horizontal
        pillsStack.spacing = 8
        pillsStack.distribution = .fillEqually

        let resumenStack = UIStackView(arrangedSubviews: [resumenTitle, pillsStack])
        resumenStack.axis = .vertical
        resumenStack.spacing = 10
        resumenStack.translatesAutoresizingMaskIntoConstraints = false

        resumenCard.addSubview(resumenStack)

        NSLayoutConstraint.activate([
            resumenStack.topAnchor.constraint(equalTo: resumenCard.topAnchor, constant: 16),
            resumenStack.leadingAnchor.constraint(equalTo: resumenCard.leadingAnchor, constant: 16),
            resumenStack.trailingAnchor.constraint(equalTo: resumenCard.trailingAnchor, constant: -16),
            resumenStack.bottomAnchor.constraint(equalTo: resumenCard.bottomAnchor, constant: -16),
        ])

        // Botón de editar
        let editarButton = UIButton(type: .system)
        editarButton.setTitle("Editar datos", for: .normal)
        editarButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editarButton.tintColor = .white
        editarButton.backgroundColor = .systemBlue
        editarButton.layer.cornerRadius = 14
        editarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        editarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        editarButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        editarButton.translatesAutoresizingMaskIntoConstraints = false
        editarButton.addTarget(self, action: #selector(abrirEditarEmpleado), for: .touchUpInside)

        contentView.addSubview(editarButton)

        NSLayoutConstraint.activate([
            editarButton.topAnchor.constraint(equalTo: resumenCard.bottomAnchor, constant: 24),
            editarButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func abrirEditarEmpleado(){
        let editarVC = EditarEmpleadoViewController()
        navigationController?.pushViewController(editarVC, animated: true)
    }

    private func crearFilaIcono(texto: String, icono: String) -> UIStackView {
        let iconView = UIImageView(image: UIImage(systemName: icono))
        iconView.tintColor = .secondaryLabel
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let label = UILabel()
        label.text = texto
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel

        let hStack = UIStackView(arrangedSubviews: [iconView, label])
        hStack.axis = .horizontal
        hStack.spacing = 6
        return hStack
    }

    private func crearPill(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        valueLabel.textColor = .label

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])

        return container
    }

    @objc private func editarEmpleado() {
        print("Editar datos del empleado")
    }
}

