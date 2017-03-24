// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

enum StoryboardScene {
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    static func initialViewController() -> UINavigationController {
      guard let vc = storyboard().instantiateInitialViewController() as? UINavigationController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case complaintListViewControllerScene = "ComplaintListViewController"
    static func instantiateComplaintListViewController() -> SSS.ComplaintListViewController {
      guard let vc = StoryboardScene.Main.complaintListViewControllerScene.viewController() as? SSS.ComplaintListViewController
      else {
        fatalError("ViewController 'ComplaintListViewController' is not of the expected class SSS.ComplaintListViewController.")
      }
      return vc
    }

    case homeScene = "Home"
    static func instantiateHome() -> UINavigationController {
      guard let vc = StoryboardScene.Main.homeScene.viewController() as? UINavigationController
      else {
        fatalError("ViewController 'Home' is not of the expected class UINavigationController.")
      }
      return vc
    }

    case homeViewControllerScene = "HomeViewController"
    static func instantiateHomeViewController() -> SSS.HomeViewController {
      guard let vc = StoryboardScene.Main.homeViewControllerScene.viewController() as? SSS.HomeViewController
      else {
        fatalError("ViewController 'HomeViewController' is not of the expected class SSS.HomeViewController.")
      }
      return vc
    }

    case pageViewControllerScene = "PageViewController"
    static func instantiatePageViewController() -> SSS.PageViewController {
      guard let vc = StoryboardScene.Main.pageViewControllerScene.viewController() as? SSS.PageViewController
      else {
        fatalError("ViewController 'PageViewController' is not of the expected class SSS.PageViewController.")
      }
      return vc
    }

    case pinValidationScene = "PinValidation"
    static func instantiatePinValidation() -> SSS.PinValidationViewController {
      guard let vc = StoryboardScene.Main.pinValidationScene.viewController() as? SSS.PinValidationViewController
      else {
        fatalError("ViewController 'PinValidation' is not of the expected class SSS.PinValidationViewController.")
      }
      return vc
    }

    case profilePanelScene = "ProfilePanel"
    static func instantiateProfilePanel() -> SSS.SidePanelViewController {
      guard let vc = StoryboardScene.Main.profilePanelScene.viewController() as? SSS.SidePanelViewController
      else {
        fatalError("ViewController 'ProfilePanel' is not of the expected class SSS.SidePanelViewController.")
      }
      return vc
    }

    case recordingsViewControllerScene = "RecordingsViewController"
    static func instantiateRecordingsViewController() -> SSS.RecordingsViewController {
      guard let vc = StoryboardScene.Main.recordingsViewControllerScene.viewController() as? SSS.RecordingsViewController
      else {
        fatalError("ViewController 'RecordingsViewController' is not of the expected class SSS.RecordingsViewController.")
      }
      return vc
    }
  }
  enum SignUp: String, StoryboardSceneType {
    static let storyboardName = "SignUp"

    static func initialViewController() -> UINavigationController {
      guard let vc = storyboard().instantiateInitialViewController() as? UINavigationController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case imagePickViewControllerScene = "ImagePickViewController"
    static func instantiateImagePickViewController() -> SSS.ImagePickViewController {
      guard let vc = StoryboardScene.SignUp.imagePickViewControllerScene.viewController() as? SSS.ImagePickViewController
      else {
        fatalError("ViewController 'ImagePickViewController' is not of the expected class SSS.ImagePickViewController.")
      }
      return vc
    }

    case loginScene = "login"
    static func instantiateLogin() -> SSS.LoginViewController {
      guard let vc = StoryboardScene.SignUp.loginScene.viewController() as? SSS.LoginViewController
      else {
        fatalError("ViewController 'login' is not of the expected class SSS.LoginViewController.")
      }
      return vc
    }

    case loginAndSignupScene = "loginAndSignup"
    static func instantiateLoginAndSignup() -> UINavigationController {
      guard let vc = StoryboardScene.SignUp.loginAndSignupScene.viewController() as? UINavigationController
      else {
        fatalError("ViewController 'loginAndSignup' is not of the expected class UINavigationController.")
      }
      return vc
    }
  }
}

enum StoryboardSegue {
  enum Main: String, StoryboardSegueType {
    case notification
  }
  enum SignUp: String, StoryboardSegueType {
    case main
    case setUpPin
    case signup
  }
}

private final class BundleToken {}
