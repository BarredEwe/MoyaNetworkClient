#
# Be sure to run `pod lib lint MoyaNetworkClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoyaNetworkClient'
  s.version          = '3.1.5'
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
  s.default_subspec = 'Core'
  s.ios.deployment_target = '10.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/MoyaNC/**/*'
    core.dependency 'Moya', "~> 14.0"
  end

  s.subspec 'Cache' do |cache|
    cache.source_files = 'Sources/CacheMoyaNC/**/*'
    cache.dependency 'MoyaNetworkClient/Core'
    cache.dependency 'MoyaNetworkClient/Future'
  end

  s.subspec 'Future' do |future|
    future.source_files = 'Sources/FutureMoyaNC/**/*'
    future.dependency 'MoyaNetworkClient/Core'
  end

end
