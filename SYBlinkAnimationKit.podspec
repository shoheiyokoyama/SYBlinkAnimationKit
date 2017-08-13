Pod::Spec.new do |s|
  s.name             = "SYBlinkAnimationKit"
  s.version          = "0.3.2"
  s.summary          = "SYBlinkAnimationKit is a blink effect animation framework for iOS, written in Swift."

  s.homepage         = "https://github.com/shoheiyokoyama/SYBlinkAnimationKit"
  s.license          = 'MIT'
  s.author           = { "Shohei Yokoyama" => "shohei.yok0602@gmail.com" }
  s.source           = { :git => "https://github.com/shoheiyokoyama/SYBlinkAnimationKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*.swift'
end
