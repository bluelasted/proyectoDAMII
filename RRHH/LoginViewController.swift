
import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    // MARK: - Video
    private var queuePlayer: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?

    // MARK: - Credenciales válidas
    private let validUser = "Admin"
    private let validPassword = "1234"

    // MARK: - UI
    private let usuarioTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Usuario"
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        tf.layer.cornerRadius = 10
        tf.borderStyle = .none
        tf.setLeftPaddingPoints(10)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.isSecureTextEntry = true
        tf.textColor = .white
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        tf.layer.cornerRadius = 10
        tf.borderStyle = .none
        tf.setLeftPaddingPoints(10)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ingresar", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupVideoBackground()
        setupGlassmorphismCard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        queuePlayer?.play()
    }

    // MARK: - Video de fondo
    private func setupVideoBackground() {
        print("➡️ Intentando cargar fondo.mp4")

        let mp4Files = Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil)
        print("MP4s en el bundle:", mp4Files)

        guard let url = Bundle.main.url(forResource: "fondo", withExtension: "mp4") else {
            print("❌ No se encontró fondo.mp4 en el bundle")
            return
        }

        print("✅ Video encontrado en:", url.path)

        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        queuePlayer = player
        player.isMuted = true

        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        playerLayer = layer

        view.layer.insertSublayer(layer, at: 0)
    }

    // MARK: - Tarjeta glassmorphism
    private func setupGlassmorphismCard() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 20
        blurView.layer.masksToBounds = true
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.15)

        view.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            blurView.heightAnchor.constraint(equalToConstant: 260)
        ])

        let titleLabel = UILabel()
        titleLabel.text = "Iniciar Sesión"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            usuarioTextField,
            passwordTextField,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        blurView.contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -20)
        ])

        loginButton.addTarget(self,
                              action: #selector(didTapLogin),
                              for: .touchUpInside)
    }

    // MARK: - Login
    @objc private func didTapLogin() {
        let user = usuarioTextField.text ?? ""
        let pass = passwordTextField.text ?? ""

        // Validar campos vacíos
        if user.isEmpty || pass.isEmpty {
            mostrarAlerta(titulo: "Faltan datos",
                          mensaje: "Ingresa usuario y contraseña.")
            return
        }

        // Comparar con usuario/clave válidos
        if user == validUser && pass == validPassword {
            irAHOME()
        } else {
            mostrarAlerta(titulo: "Error",
                          mensaje: "Usuario o contraseña incorrectos.")
        }
    }

    // Mostrar alertas
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo,
                                      message: mensaje,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // Ir a la segunda pantalla
    private func irAHOME() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(homeVC, animated: true)
    }
}

// MARK: - Extensión de UITextField
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: amount,
                                               height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

