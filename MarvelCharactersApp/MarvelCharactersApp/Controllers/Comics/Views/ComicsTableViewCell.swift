import UIKit

struct ComicsTableViewCellModel {
    let coverImageUrl: String
    let title: String
    let description: String?
}

final class ComicsTableViewCell: UITableViewCell {
    let coverImage = UIImageView()
    let titleLabel = UILabel()
    let dataStckView = UIStackView()
    let descriptionLabel = UILabel()
    var coverDataTask: URLSessionDataTask?

    func apply(viewModel: ComicsTableViewCellModel) {
        configureCell()

        if let coverDataTask = coverDataTask {
            coverDataTask.cancel()
        }

        coverImage.image = nil
        coverDataTask = coverImage.image(from: viewModel.coverImageUrl)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

private extension ComicsTableViewCell {
    func configureCell() {
        configureSubviews()
        configureConstraints()
        configureStyling()
    }

    func configureSubviews() {
        contentView.addSubview(coverImage)
        contentView.addSubview(dataStckView)
        dataStckView.addArrangedSubview(titleLabel)
        dataStckView.addArrangedSubview(descriptionLabel)
    }

    func configureStyling() {
        self.backgroundColor = .clear
        coverImage.contentMode = .top
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        dataStckView.axis = .vertical
        dataStckView.spacing = 12
        dataStckView.distribution = .equalSpacing
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 0
    }

    func configureConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        dataStckView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            coverImage.widthAnchor.constraint(equalToConstant: 50),
            coverImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),

            dataStckView.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 20),
            dataStckView.topAnchor.constraint(equalTo: coverImage.topAnchor),
            dataStckView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dataStckView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
