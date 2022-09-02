#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint device_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'device_plugin'
  s.version          = '0.0.4'
  s.summary          = 'A new Device Flutter plugin'
  s.description      = <<-DESC
A new Device Flutter plugin
                       DESC
  s.homepage         = 'https://github.com/coolxinxin/device_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => '2438565661@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
