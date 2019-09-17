#
# Be sure to run `pod lib lint MoyaNetworkClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoyaNetworkClient'
  s.version          = '0.4.2'
  s.summary          = 'MoyaNetworkClient pod.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BarredEwe/MoyaNetworkClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BarredEwe' => 'barredEwe@gmail.com' }
  s.source           = { :git => 'https://github.com/BarredEwe/MoyaNetworkClient.git', :tag => s.version.to_s }
  s.swift_version = '5.0'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MoyaNetworkClient/Classes/**/*'
  s.dependency 'Moya'
end
