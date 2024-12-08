import UIKit

internal class AreaLabelView: UIView {
    internal var label: UILabel
    private var padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override init(frame: CGRect = .zero) {
        label = UILabel()
        super.init(frame: frame)
        setupLabel()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupView() {
        backgroundColor = .systemGray2
        layer.cornerRadius = 8
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
        ])
    }

    internal func configure(text: String, padding: UIEdgeInsets? = nil) {
        label.text = text

        if let newPadding = padding {
            self.padding = newPadding
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: self.padding.top),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -self.padding.bottom),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: self.padding.left),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -self.padding.right)
            ])
        }
    }

    internal func toggle() {
        
    }
}
