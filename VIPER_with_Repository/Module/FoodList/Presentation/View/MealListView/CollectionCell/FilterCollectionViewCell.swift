import UIKit

internal class FilterCollectionViewCell: UICollectionViewCell {
    private var areaLabel: AreaLabelView

    override init(frame: CGRect = .zero) {
        self.areaLabel = AreaLabelView(frame: frame)
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
            areaLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            areaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            areaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            areaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }

    internal func configure(with area: String) {
        self.areaLabel.label.text = area
    }
}
