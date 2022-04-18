import UIKit
import WordPressUI
import WordPressShared

extension NSNotification.Name {
    static let installJetpack = NSNotification.Name(rawValue: "Meowww")
}

enum OnboardingOption {
    case stats
    case writing
    case notifications
    case reader
    case other
}

class OnboardingQuestionsPromptViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var postsButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var notSureButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        navigationController?.delegate = self

        applyStyles()
        updateButtonTitles()
    }

    // MARK: - View Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        configureButtons()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return [.portrait, .portraitUpsideDown]
    }

    private func pushToNotificationsPrompt(option: OnboardingOption ) {
        let controller = OnboardingEnableNotificationsViewController()
        controller.selectedOption = option
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - IBAction's
extension OnboardingQuestionsPromptViewController {
    @IBAction func didTapStats(_ sender: Any) {
        pushToNotificationsPrompt(option: .stats)
    }

    @IBAction func didTapWriting(_ sender: Any) {
        pushToNotificationsPrompt(option: .writing)
    }

    @IBAction func didTapNotifications(_ sender: Any) {
        pushToNotificationsPrompt(option: .notifications)
    }

    @IBAction func didTapReader(_ sender: Any) {
        pushToNotificationsPrompt(option: .reader)
    }

    @IBAction func didTapNotSure(_ sender: Any) {
        pushToNotificationsPrompt(option: .other)
    }

    @IBAction func skip(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Private Helpers
private extension OnboardingQuestionsPromptViewController {
    private func applyStyles() {
        titleLabel.font = WPStyleGuide.serifFontForTextStyle(.title1, fontWeight: .semibold)
        titleLabel.textColor = .text

        stackView.setCustomSpacing(32, after: titleLabel)
    }

    private func updateButtonTitles() {
        statsButton.setTitle(Strings.stats, for: .normal)
        statsButton.setImage("📊".image(), for: .normal)

        postsButton.setTitle(Strings.writing, for: .normal)
        postsButton.setImage("✍️".image(), for: .normal)

        notificationsButton.setTitle(Strings.notifications, for: .normal)
        notificationsButton.setImage("🔔".image(), for: .normal)

        readButton.setTitle(Strings.reader, for: .normal)
        readButton.setImage("📚".image(), for: .normal)

        notSureButton.setTitle(Strings.notSure, for: .normal)
        notSureButton.setImage("🤔".image(), for: .normal)

        skipButton.setTitle(Strings.skip, for: .normal)
    }

    private func configureButtons() {
        [statsButton, postsButton, notificationsButton, readButton, notSureButton].forEach {
            style(button: $0)
        }
    }

    private func style(button: UIButton) {
        button.titleLabel?.font = WPStyleGuide.fontForTextStyle(.headline)
        button.setTitleColor(.text, for: .normal)
        button.titleLabel?.textAlignment = .natural
        button.titleEdgeInsets.left = 10
        button.flipInsetsForRightToLeftLayoutDirection()
        button.imageView?.contentMode = .scaleAspectFit
    }
}

// MARK: - UINavigation Controller Delegate
extension OnboardingQuestionsPromptViewController {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return supportedInterfaceOrientations
    }
}


// MARK: - CGSize Helper Extension
private extension CGSize {

    /// Get the center point of the size in the given rect
    /// - Parameter rect: The rect to center the size in
    /// - Returns: The center point
    func centered(in rect: CGRect) -> CGPoint {
        let x = rect.midX - (self.width * 0.5)
        let y = rect.midY - (self.height * 0.5)

        return CGPoint(x: x, y: y)
    }
}

// MARK: - Emoji Drawing Helper Extension
private extension String {
    func image() -> UIImage {
        let size = Constants.iconSize
        let imageSize = CGSize(width: size, height: size)
        let rect = CGRect(origin: .zero, size: imageSize)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        UIColor.clear.set()
        UIRectFill(rect)

        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size)]

        let string = self as NSString
        let drawingSize = string.size(withAttributes: attributes)
        string.draw(at: drawingSize.centered(in: rect), withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.withRenderingMode(.alwaysOriginal) ?? UIImage()
    }
}

// MARK: - Helper Structs
private struct Strings {
    static let stats = NSLocalizedString("Checking stats", comment: "Title of a button")
    static let writing = NSLocalizedString("Writing blog posts", comment: "Title of a button")
    static let notifications = NSLocalizedString("Staying up to date with notifications", comment: "Title of a button")
    static let reader = NSLocalizedString("Reading posts from other sites", comment: "Title of a button")
    static let notSure = NSLocalizedString("Not sure, show me around", comment: "Title of a button")
    static let skip = NSLocalizedString("Skip", comment: "Title of a button")
}

private struct Constants {
    static let iconSize = 24.0
}
