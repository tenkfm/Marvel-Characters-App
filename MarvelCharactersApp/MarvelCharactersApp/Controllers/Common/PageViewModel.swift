import UIKit

class PageViewModel: NetworkingViewModel {
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

extension PageViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        guard contentHeight > 0 else { return }

        /// Load more if:
        /// - less than 2 screens of data left,
        /// - there is no loading process
        /// - current data is not loaded from cache
        /// - more pages available
        if offsetY > contentHeight - scrollView.frame.size.height * 2 && dataState != .loading && dataState != .cached && !currentPageInfo.isLast {
            currentPageInfo.offset += currentPageInfo.limit
            loadMoreData()
        }
    }
}
