// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  typealias Font = UIFont
#elseif os(OSX)
  import AppKit.NSFont
  typealias Font = NSFont
#endif

// swiftlint:disable file_length
// swiftlint:disable line_length

protocol FontConvertible {
  func font(size: CGFloat) -> Font!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {
  func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  func register() {
    let extensions = ["otf", "ttf"]
    let bundle = Bundle(for: BundleToken.self)

    guard let url = extensions.flatMap({ bundle.url(forResource: rawValue, withExtension: $0) }).first else { return }

    var errorRef: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(url as CFURL, .none, &errorRef)
  }
}

extension Font {
  convenience init!<FontType: FontConvertible>
    (font: FontType, size: CGFloat)
    where FontType: RawRepresentable, FontType.RawValue == String {
      #if os(iOS) || os(tvOS) || os(watchOS)
      if UIFont.fontNames(forFamilyName: font.rawValue).isEmpty {
        font.register()
      }
      #elseif os(OSX)
      if NSFontManager.shared().availableMembers(ofFontFamily: font.rawValue) == nil {
        font.register()
      }
      #endif

      self.init(name: font.rawValue, size: size)
  }
}

enum FontFamily {
  enum HelveticaNeue: String, FontConvertible {
    case regular = "HelveticaNeue"
    case bold = "HelveticaNeue-Bold"
    case boldItalic = "HelveticaNeue-BoldItalic"
    case condensedBlack = "HelveticaNeue-CondensedBlack"
    case condensedBold = "HelveticaNeue-CondensedBold"
    case italic = "HelveticaNeue-Italic"
    case light = "HelveticaNeue-Light"
    case lightItalic = "HelveticaNeue-LightItalic"
    case medium = "HelveticaNeue-Medium"
    case ultraLight = "HelveticaNeue-UltraLight"
    case ultraLightItalic = "HelveticaNeue-UltraLightItalic"
  }
  enum SFUIDisplay: String, FontConvertible {
    case black = "SFUIDisplay-Black"
    case bold = "SFUIDisplay-Bold"
    case heavy = "SFUIDisplay-Heavy"
    case light = "SFUIDisplay-Light"
    case medium = "SFUIDisplay-Medium"
    case regular = "SFUIDisplay-Regular"
    case semibold = "SFUIDisplay-Semibold"
    case thin = "SFUIDisplay-Thin"
    case ultralight = "SFUIDisplay-Ultralight"
  }
  enum SFUIText: String, FontConvertible {
    case bold = "SFUIText-Bold"
    case boldItalic = "SFUIText-BoldItalic"
    case heavy = "SFUIText-Heavy"
    case heavyItalic = "SFUIText-HeavyItalic"
    case italic = "SFUIText-Italic"
    case light = "SFUIText-Light"
    case lightItalic = "SFUIText-LightItalic"
    case medium = "SFUIText-Medium"
    case mediumItalic = "SFUIText-MediumItalic"
    case regular = "SFUIText-Regular"
    case semibold = "SFUIText-Semibold"
    case semiboldItalic = "SFUIText-SemiboldItalic"
  }
}

private final class BundleToken {}
