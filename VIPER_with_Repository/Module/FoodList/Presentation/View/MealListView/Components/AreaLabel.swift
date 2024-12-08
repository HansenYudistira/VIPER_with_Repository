import UIKit

enum ButtonState {
    case on
    case off
}

protocol ButtonTappedDelegate: AnyObject {
    func toggle(_ sender: UIButton)
}

internal class AreaLabelButton: UIButton {
    private var customPadding: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
        top: 4,
        leading: 8,
        bottom: 4,
        trailing: 8
    )

    internal var buttonState: ButtonState = .off

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 12)
        titleLabel?.adjustsFontForContentSizeCategory = true
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7
        titleLabel?.numberOfLines = 1
        titleLabel?.textAlignment = .center

        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
        translatesAutoresizingMaskIntoConstraints = false
        updateAppearance()
    }

    internal func configure(text: String, configuration: ((inout NSDirectionalEdgeInsets) -> Void)? = nil) {
        setTitle(text, for: .normal)
        accessibilityLabel = text

        if let config = configuration {
            var newPadding = customPadding
            config(&newPadding)
            customPadding = newPadding
        }

        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = customPadding
        self.configuration = buttonConfig
    }

    internal func toggle() {
        buttonState = (buttonState == .on) ? .off : .on
        updateAppearance()
    }

    private func updateAppearance() {
        switch buttonState {
        case .on:
            backgroundColor = .systemBlue
        case .off:
            backgroundColor = .systemGray2
        }
    }

    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(
            width: superSize.width + customPadding.leading + customPadding.trailing + 4,
            height: superSize.height
        )
    }

    internal func resetState() {
        buttonState = .off
        isSelected = false
        updateAppearance()
    }
}
