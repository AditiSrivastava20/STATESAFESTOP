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

    static func initialViewController() -> SSS.BaseNavigationController {
      guard let vc = storyboard().instantiateInitialViewController() as? SSS.BaseNavigationController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case cameraViewControllerScene = "CameraViewController"
    static func instantiateCameraViewController() -> SSS.CameraViewController {
      guard let vc = StoryboardScene.Main.cameraViewControllerScene.viewController() as? SSS.CameraViewController
      else {
        fatalError("ViewController 'CameraViewController' is not of the expected class SSS.CameraViewController.")
      }
      return vc
    }

    case complaintViewControllerScene = "ComplaintViewController"
    static func instantiateComplaintViewController() -> SSS.ComplaintViewController {
      guard let vc = StoryboardScene.Main.complaintViewControllerScene.viewController() as? SSS.ComplaintViewController
      else {
        fatalError("ViewController 'ComplaintViewController' is not of the expected class SSS.ComplaintViewController.")
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

    case pinValidationViewControllerScene = "PinValidationViewController"
    static func instantiatePinValidationViewController() -> SSS.PinValidationViewController {
      guard let vc = StoryboardScene.Main.pinValidationViewControllerScene.viewController() as? SSS.PinValidationViewController
      else {
        fatalError("ViewController 'PinValidationViewController' is not of the expected class SSS.PinValidationViewController.")
      }
      return vc
    }
    
    case complaintDoneViewControllerScene = "ComplaintDoneViewController"
    static func instantiateComplaintDoneViewController() -> SSS.ComplaintDoneViewController {
        guard let vc = StoryboardScene.Main.complaintDoneViewControllerScene.viewController() as? SSS.ComplaintDoneViewController
            else {
                fatalError("ViewController 'ComplaintDoneViewController' is not of the expected class SSS.ComplaintDoneViewController.")
        }
        return vc
    }

    case recordingViewControllerScene = "RecordingViewController"
    static func instantiateRecordingViewController() -> SSS.RecordingViewController {
      guard let vc = StoryboardScene.Main.recordingViewControllerScene.viewController() as? SSS.RecordingViewController
      else {
        fatalError("ViewController 'RecordingViewController' is not of the expected class SSS.RecordingViewController.")
      }
      return vc
    }

    case safeListViewControllerScene = "SafeListViewController"
    static func instantiateSafeListViewController() -> SSS.SafeListViewController {
      guard let vc = StoryboardScene.Main.safeListViewControllerScene.viewController() as? SSS.SafeListViewController
      else {
        fatalError("ViewController 'SafeListViewController' is not of the expected class SSS.SafeListViewController.")
      }
      return vc
    }
    
    case settingsViewControllerScene = "SettingsViewController"
    static func instantiateSettingsViewController() -> SSS.SettingsViewController {
        guard let vc = StoryboardScene.Main.settingsViewControllerScene.viewController() as? SSS.SettingsViewController
            else {
                fatalError("ViewController 'SettingsViewController' is not of the expected class SSS.SettingsViewController.")
        }
        return vc
    }
    
    case editProfileViewControllerScene = "EditProfileViewController"
    static func instantiateEditProfileViewController() -> SSS.EditProfileViewController {
        guard let vc = StoryboardScene.Main.editProfileViewControllerScene.viewController() as? SSS.EditProfileViewController
            else {
                fatalError("ViewController 'EditProfileViewController' is not of the expected class SSS.EditProfileViewController.")
        }
        return vc
    }
    
    
    case changePasswordViewControllerScene = "ChangePasswordViewController"
    static func instantiateChangePasswordViewController() -> SSS.ChangePasswordViewController {
        guard let vc = StoryboardScene.Main.changePasswordViewControllerScene.viewController() as? SSS.ChangePasswordViewController
            else {
                fatalError("ViewController 'ChangePasswordViewController' is not of the expected class SSS.ChangePasswordViewController.")
        }
        return vc
    }
    
    case writeComplaintViewControllerScene = "WriteComplaintViewController"
    static func instantiateWriteComplaintViewController() -> SSS.WriteComplaintViewController {
        guard let vc = StoryboardScene.Main.writeComplaintViewControllerScene.viewController() as? SSS.WriteComplaintViewController
            else {
                fatalError("ViewController 'WriteComplaintViewController' is not of the expected class SSS.WriteComplaintViewController.")
        }
        return vc
    }
    

    case sideMenuViewControllerScene = "SideMenuViewController"
    static func instantiateSideMenuViewController() ->  SSS.SideMenuViewController {
      guard let vc = StoryboardScene.Main.sideMenuViewControllerScene.viewController() as?  SSS.SideMenuViewController
      else {
        fatalError("ViewController 'SideMenuViewController' is not of the expected class SSS.SideMenuViewController.")
      }
      return vc
    }
    
    case notificationViewControllerScene = "NotificationViewController"
    static func instantiateNotificationViewController() -> SSS.NotificationViewController {
        guard let vc = StoryboardScene.Main.notificationViewControllerScene.viewController() as?  SSS.NotificationViewController
            else {
                fatalError("ViewController 'NotificationViewController' is not of the expected class SSS.NotificationViewController.")
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
    
    
    case sSSPackageViewControllerScene = "SSSPackageViewController"
    static func instantiateSSSPackageViewController() -> SSS.SSSPackageViewController {
        guard let vc = StoryboardScene.SignUp.sSSPackageViewControllerScene.viewController() as? SSS.SSSPackageViewController
            else {
                fatalError("ViewController 'SSSPackageViewController' is not of the expected class SSS.SSSPackageViewController.")
        }
        return vc
    }
    
    case cardTransactionViewControllerScene = "CardTransactionViewController"
    static func instantiateCardTransactionViewController() -> SSS.CardTransactionViewController {
        guard let vc = StoryboardScene.SignUp.cardTransactionViewControllerScene.viewController() as? SSS.CardTransactionViewController
            else {
                fatalError("ViewController 'CardTransactionViewController' is not of the expected class SSS.CardTransactionViewController.")
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
    
    case enterDetailsFirstViewControllerScene = "EnterDetailsFirstViewController"
    static func instantiateEnterDetailsFirstViewController() -> SSS.EnterDetailsFirstViewController {
        guard let vc = StoryboardScene.SignUp.enterDetailsFirstViewControllerScene.viewController() as? SSS.EnterDetailsFirstViewController
            else {
                fatalError("ViewController 'EnterDetailsFirstViewController' is not of the expected class SSS.EnterDetailsFirstViewController.")
        }
        return vc
    }
    
    case enterDetailsSecondViewControllerScene = "EnterDetailsSecondViewController"
    static func instantiateEnterDetailsSecondViewController() -> SSS.EnterDetailsSecondViewController {
        guard let vc = StoryboardScene.SignUp.enterDetailsSecondViewControllerScene.viewController() as? SSS.EnterDetailsSecondViewController
            else {
                fatalError("ViewController 'EnterDetailsSecondViewController' is not of the expected class SSS.EnterDetailsSecondViewController.")
        }
        return vc
    }
    
    case tutorialViewControllerScene = "TutorialViewController"
    static func instantiateTutorialViewController() -> SSS.TutorialViewController {
        guard let vc = StoryboardScene.SignUp.tutorialViewControllerScene.viewController() as? SSS.TutorialViewController
            else {
                fatalError("ViewController 'TutorialViewController' is not of the expected class TutorialViewController.")
        }
        return vc
    }
    
    
    
  }
}

enum StoryboardSegue {
  enum SignUp: String, StoryboardSegueType {
    case loginToMain
    case loginToPackage
    case loginToPin
    case loginToSignup
    case packageToInAppPurchase
    case pinToPackage
    case signupToPin
  }
}

private final class BundleToken {}
