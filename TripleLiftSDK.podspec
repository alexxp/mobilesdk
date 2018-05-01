#
#  Be sure to run `pod spec lint TripleLiftSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name         = "TripleLiftSDK"
  s.version      = "0.0.7"
  s.summary      = "TripleLiftSDK is an Ad SDK for publishers"

  s.license = { :type => "BSD", :file => "LICENSE" }


  s.author = { "Alexander Prokofiev" => "aprokofiev@triplelift.com" }

  s.homepage = "http://www.triplelift.com"
  s.source = { :git => "git@github.com:triplelift-internal/mobile-sdk-ios.git", :tag => "#{s.version}"}

  s.framework = 'XCTest', 'Foundation'
  s.framework = "UIKit"
  s.source_files = "SDK/**/*.{h,m,swift}"
  s.exclude_files = "SDK/**/*Tests.*"
  s.resources = "SDK/**/*.{png,jpeg,jpg,storyboard,xib}"

end
