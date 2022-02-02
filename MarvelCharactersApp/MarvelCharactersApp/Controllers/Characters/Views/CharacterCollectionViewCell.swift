import UIKit

struct CharacterCollectionViewModel {
    let coverImageUrl: String
    let title: String
    let description: String
}

final class CharacterCollectionViewCell: UICollectionViewCell {
    let coverImage = UIImageView()
    let shadowView = UIView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    var coverDataTask: URLSessionDataTask?

    func apply(viewModel: CharacterCollectionViewModel) {
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

private extension CharacterCollectionViewCell {
    func configureCell() {
        configureSubviews()
        configureConstraints()
        configureStyling()
    }

    func configureSubviews() {
        contentView.addSubview(coverImage)
        contentView.addSubview(shadowView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    func configureStyling() {
        shadowView.backgroundColor = .init(white: 0, alpha: 0.3)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 11)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 3
    }

    func configureConstraints() {
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
