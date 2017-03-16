// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum Asset: String {
  case audioBlack = "audio_black"
  case audioYelow = "audio_yelow"
  case combinedShape = "Combined Shape"
  case icAttach = "ic_attach"
  case icBack = "ic_back"
  case icCalender = "ic_calender"
  case icCallDark = "ic_call dark"
  case icCallWhite = "ic_call white"
  case icCardHolder = "ic_card holder"
  case icCent = "ic_cent"
  case icCheckin = "ic_checkin"
  case icComplaintDone = "ic_complaint done"
  case icComplaintGray = "ic_complaint gray"
  case icComplaintYellow = "ic_complaint yellow"
  case icComplaint = "ic_complaint"
  case icCreditCard = "ic_credit card"
  case icDarkButton = "ic_dark button"
  case icEditProfile = "ic_edit profile"
  case icEdit = "ic_edit"
  case icFacebook = "ic_facebook"
  case icFriends = "ic_friends"
  case icHomeGray = "ic_home gray"
  case icImagePlaceholder = "ic_image placeholder"
  case icLocation = "ic_location"
  case icLogo = "ic_logo"
  case icMoney = "ic_money"
  case icNotification1 = "ic_notification 1"
  case icNotification = "ic_notification"
  case icOvalFacebook = "ic_oval facebook"
  case icOvalFill = "ic_oval fill"
  case icPayment = "ic_payment"
  case icProfilePic = "ic_profile pic"
  case icProfile = "ic_profile"
  case icRecordingPlay = "ic_recording play"
  case icRecording = "ic_recording"
  case icSafeList = "ic_safe list"
  case icSidebarBack = "ic_sidebar back"
  case icThumbsup = "ic_thumbsup"
  case icTwitter = "ic_twitter"
  case icVideoFill = "ic_video fill"
  case icVideoPlayWhiteFill = "ic_video play white fill"
  case icVideoPlayYellow = "ic_video play yellow"
  case icVideoPlay = "ic_video play"
  case icVideocamWhite = "ic_videocam_white"
  case icView = "ic_view"
  case icYellowButton = "ic_yellow button"
  case icZipCode = "ic_zip code"
  case vedioBlack = "vedio_black"
  case vedioYelow = "vedio_yelow"

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS) || os(watchOS)
    let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: rawValue)
    #endif
    guard let result = image else { fatalError("Unable to load image \(rawValue).") }
    return result
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: asset.rawValue)
    #endif
  }
}

private final class BundleToken {}
