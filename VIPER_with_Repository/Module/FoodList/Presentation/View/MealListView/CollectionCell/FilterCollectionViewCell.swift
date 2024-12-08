import UIKit

internal class FilterCollectionViewCell: UICollectionViewCell {
    private var areaLabel: AreaLabelButton

    weak var delegate: ButtonTappedDelegate?

    override init(frame: CGRect = .zero) {
        self.areaLabel = AreaLabelButton(frame: frame)
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(areaLabel)

        NSLayoutConstraint.activate([
            areaLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            areaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            areaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            areaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        areaLabel.addTarget(self, action: #selector(didTapAreaButton), for: .touchUpInside)
    }

    internal func configure(with area: String) {
        self.areaLabel.configure(text: area)
    }

    @objc private func didTapAreaButton(_ sender: UIButton) {
        areaLabel.toggle()
        delegate?.toggle(sender)
    }

    internal func resetState() {
        areaLabel.resetState()
    }
}
