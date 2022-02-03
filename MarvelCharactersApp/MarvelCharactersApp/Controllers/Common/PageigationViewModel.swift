import UIKit

class PageigationViewModel: NetworkingViewModel {
    internal var currentPageInfo: PageInfo

    init(networkingService: NetworkingServiceProtocol, limit: Int) {
        self.currentPageInfo = PageInfo()
        super.init(networkingService: networkingService)
    }

    public func loadMoreData() {}

    public func resetPageInfo() {
        currentPageInfo = PageInfo()
    }
}

extension PageigationViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        guard contentHeight > 0 else { return }

        if offsetY > contentHeight - scrollView.frame.size.height && dataState != .loading && !currentPageInfo.isLast {
            currentPageInfo.offset += currentPageInfo.limit
            loadMoreData()
        }
    }
}
