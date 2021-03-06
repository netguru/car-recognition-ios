//
//  OnboardningViewController.swift
//  CarLens
//


import UIKit

final class OnboardingViewController: TypedViewController<OnboardingView> {

    /// Enum describing events that can be triggered by this controller
    ///
    /// - didTriggerFinishOnboarding: Send when user is on the last screen of onboarding and triggers the "next" button.
    enum Event {
        case didTriggerFinishOnboarding
    }

    /// Callback with triggered event.
    var eventTriggered: ((Event) -> Void)?

    /// Page View Controller used for onboarding views.
    private lazy var pageViewController: OnboardingPageViewController = {
        let viewController = OnboardingPageViewController(transitionStyle: .scroll,
                                                          navigationOrientation: .horizontal,
                                                          options: [:])
        viewController.onboardingDelegate = self
        return viewController
    }()

    /// Animation Player handling the animation by playing video.
    private lazy var animationPlayer = OnboardingAnimationPlayer()

    override func loadView() {
        super.loadView()
        addChildViewControllers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func addChildViewControllers() {
        add(pageViewController, inside: customView.pageView)
        add(animationPlayer.playerViewController, inside: customView.animationView)
    }

    private func setUpView() {
        view.accessibilityIdentifier = "onboarding/view/main"
        customView.nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }

    @objc private func didTapNext() {
        pageViewController.moveToNextPage()
    }
}

extension OnboardingViewController: OnboardingPageViewControllerDelegate {

    func onboardingPageViewController(_ onboardingPageViewController: OnboardingPageViewController,
                                      willTransitionFrom currentPageIndex: Int,
                                      to nextPageIndex: Int) {
        let lastPageIndex = onboardingPageViewController.numberOfPages - 1
        if nextPageIndex == lastPageIndex {
            customView.nextButton.setImage(#imageLiteral(resourceName: "button-scan-with-shadow"), for: .normal)
        } else if currentPageIndex == lastPageIndex {
            customView.nextButton.setImage(#imageLiteral(resourceName: "button-next-page"), for: .normal)
        }
    }

    func onboardingPageViewController(_ onboardingPageViewController: OnboardingPageViewController,
                                      didTransitionFrom previousPageIndex: Int,
                                      to currentPageIndex: Int) {
        animationPlayer.animate(fromPage: previousPageIndex, to: currentPageIndex)
        customView.indicatorAnimationView.animate(fromPage: previousPageIndex, to: currentPageIndex)
    }

    func didFinishOnboarding(onboardingPageViewController: OnboardingPageViewController) {
        eventTriggered?(.didTriggerFinishOnboarding)
    }
}
