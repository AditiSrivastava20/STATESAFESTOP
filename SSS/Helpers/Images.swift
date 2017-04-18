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
    case combinedShape = "Combined Shape"
    case icAttach = "ic_attach"
    case icAudioBlack = "ic_audio_black"
    case icAudioWhite = "ic_audio_white"
    case icBack = "ic_back"
    case icCalender = "ic_calender"
    case icCallDark = "ic_call dark"
    case icCallWhite = "ic_call white"
    case icCamChange = "Ic_cam_change"
    case icCam = "ic_cam"
    case icCardHolder = "ic_card holder"
    case icCent = "ic_cent"
    case icClear = "ic_clear"
    case icComplaintGray = "ic_complaint gray"
    case icComplaintWhite = "ic_complaint white"
    case icComplaintYellow = "ic_complaint yellow"
    case icComplaint = "ic_complaint"
    case icCreditCard = "ic_credit card"
    case icEditProfile = "ic_edit profile"
    case icEditOff = "ic_edit_off"
    case icEdit = "ic_edit"
    case icFabChek = "ic_fab_chek"
    case icFabComplatint = "ic_fab_complatint"
    case icFacebook = "ic_facebook"
    case icFlash = "ic_flash"
    case icFriends = "ic_friends"
    case icHomeGray = "ic_home gray"
    case icHome = "ic_home"
    case icImagePlaceholder = "ic_image placeholder"
    case icLocation = "ic_location"
    case icLogo = "ic_logo"
    case icLogout = "ic_logout"
    case icMic = "ic_mic"
    case icMoney = "ic_money"
    case icMoreVert = "ic_more_vert"
    case icMsg = "ic_msg"
    case icNotification1 = "ic_notification 1"
    case icNotification = "ic_notification"
    case icOvalFacebook = "ic_oval facebook"
    case icOvalFill = "ic_oval fill"
    case icPause = "ic_pause"
    case icPayment = "ic_payment"
    case icPlay = "ic_play"
    case icProfile = "ic_profile"
    case icRecordingPlay = "ic_recording play"
    case icRecording = "ic_recording"
    case icSafeList = "ic_safe list"
    case icSave = "ic_save"
    case icSettings = "ic_settings"
    case icSidebarBack = "ic_sidebar back"
    case icStop = "ic_Stop"
    case icThumbsup = "ic_thumbsup"
    case icTwitter = "ic_twitter"
    case icUserYellow = "ic_user yellow"
    case icUser = "ic_user"
    case icVedioBlack = "ic_vedio_black"
    case icVedioWhite = "ic_vedio_white"
    case icVid = "ic_vid"
    case icVideoFill = "ic_video fill"
    case icVideoPlayWhiteFill = "ic_video play white fill"
    case icVideoPlayYellow = "ic_video play yellow"
    case icVideoPlay = "ic_video play"
    case icView = "ic_view"
    case icZipCode = "ic_zip code"
    case tut1 = "1"
    case tut2 = "2"
    case tut3 = "3"
    
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
