Pod::Spec.new do |s|
  s.name         = "MoyaNetworkClient"
  s.version      = "0.0.7"
  s.summary      = "MoyaNetworkClient."
  s.swift_version = '4.2'
  s.description  = <<-DESC
  NetworkClient based on Moya.
                   DESC
  s.homepage     = "https://github.com/BarredEwe/MoyaNetworkClient"
  s.license      = "MIT"
  s.author       = { "BarredEwe" => "barredEwe@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/BarredEwe/MoyaNetworkClient.git", :tag => "#{s.version}" }
  s.source_files = "**/*.swift"
  s.dependency "Moya"
end
