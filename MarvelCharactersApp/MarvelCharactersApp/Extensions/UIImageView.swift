import UIKit

extension UIImageView {
    func image(from url: URL) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }
        task.resume()
        return task
    }

    func image(from link: String) -> URLSessionDataTask? {
        guard let url = URL(string: link) else {
            return nil
        }

        return image(from: url)
    }
}
