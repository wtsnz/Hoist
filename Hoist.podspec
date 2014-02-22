#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "Hoist"
  s.version          = "0.1.0"
  s.summary          = "A Hoist iOS client library."
  s.description      = <<-DESC
                       Use Hoist as a datastore for your iOS applications.
                       
                       Easy to use, just create objects and call `save` on them.
                       DESC
  # s.homepage         = "http://EXAMPLE/NAME"
  s.license          = 'MIT'
  s.author           = { "Will Townsend" => "will@townsend.io" }
  s.source           = { :git => "https://github.com/wtsnz/Hoist.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
