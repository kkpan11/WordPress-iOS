import UIKit

extension BlogDetailsViewController {
    static func presentBloggingRemindersSettingsFlow(for blog: Blog, source: BloggingRemindersTracker.FlowStartSource, viewController: UIViewController) {
        let tracker = BloggingRemindersTracker(for: blog)
        tracker.flowStarted(source: source)

        // TODO: Check whether we've already presented this flow to the user. @frosty
        let flowIntroViewController = BloggingRemindersFlowIntroViewController(tracker: tracker)
        let navigationController = BloggingRemindersNavigationController(rootViewController: flowIntroViewController)

        let bottomSheet = BottomSheetViewController(childViewController: navigationController,
                                                    customHeaderSpacing: 0)
        bottomSheet.show(from: viewController)
    }
}
