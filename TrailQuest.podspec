#
# To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  
  s.name         = "TrailQuest"
  
  s.version      = "1.0"

  s.summary      = "TrailQuest"
  
  s.swift_version = '5.5'
  
  s.description  = "TrailQuest App"
  s.homepage     = "https://github.com/DmitryYatsyuk-dv/cs50x-trailquest"

  s.license = {
    :type => "Custom",
    :text => <<-LICENSE,
    Copyright 2025
    Permission is granted to MobileApp
    LICENSE
  }
  
  s.author = "Dmitry Yatsuk"
  s.platform     = :ios, "16.0"
  
  s.source       = { :git => "https://github.com/DmitryYatsyuk-dv/cs50x-trailquest", :tag => "#{s.version}" }

  s.source_files = "Source/**/*", "Resources/Generated/LocalizedStrings.swift"
  s.resources = [
    'Resources/Generated/LocalizedStrings.swift',
    'Resources/**/*.strings',
    'Resources/**/*.json',
    'Resources/**/*.xcassets',
    'Resources/**/*.yml'
  ]
  s.pod_target_xcconfig = {
    'SWIFT_INSTALL_OBJC_HEADER' => 'NO',
    'ENABLE_TESTABILITY' => 'YES'
  }

  s.test_spec "Tests" do |test_spec|
    test_spec.requires_app_host = true
    test_spec.source_files = [
      "Tests/**/*.swift",
      "Tests/Mocks/**/*.swift"
    ]
    test_spec.resources = [
      "Tests/**/*.json"
    ]
  end
end
