import UIKit

class OnboardingViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.getViewControllerAtIndex(index: 1),
                self.getViewControllerAtIndex(index: 2),
                self.getViewControllerAtIndex(index: 3),
                self.getViewControllerAtIndex(index: 4),
                self.getViewControllerAtIndex(index: 5)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self;
        self.setViewControllers([getViewControllerAtIndex(index: 1)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    private func getViewControllerAtIndex(index: Int) -> UIViewController {
    let onboardingViewController = self.storyboard?.instantiateViewController(withIdentifier: "onboarding\(index)")
        return onboardingViewController!
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = orderedViewControllers.index(where: {$0.restorationIdentifier == viewController.restorationIdentifier})! + 2
        print(index)
        let controller = index == 6 ? nil : UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboarding\(index)")
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = orderedViewControllers.index(where: {$0.restorationIdentifier == viewController.restorationIdentifier})!
        let controller =  index == 0 ? nil : UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboarding\(index)")
        return controller
    }
}
