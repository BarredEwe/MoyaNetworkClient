<p align="center">
<img src="Images/Logo.png" width=700>
</p>

<H4 align="center">
Simple Swift Requests
</H4>

<p align="center">
<a href="https://github.com/BarredEwe/MoyaNetworkClient/releases/latest"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/MoyaNetworkClient.svg"/></a>
<a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a> 
<a href="https://cocoapods.org/pods/MoyaNetworkClient"><img alt="License" src="https://img.shields.io/cocoapods/l/MoyaNetworkClient.svg"/></a>
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a>
</p>

---

## Introduction

MoyaNC is an abstraction over abstraction (thanks to [Moya](https://github.com/Moya/Moya) 🖤🖤🖤) allowing you not to worry about the data mapping layer and just use your requests. The Codable protocol is used for JSON data mapping, all that is needed is to comply with this protocol and specify the type!

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. After some setup, using MoyaNC is really simple. You can access an API like this:

```swift
client = DefaultMoyaNetworkClient()
client.request(.zen) { 

// type 'Test' must be Codable
provider.request(.zen) { (result: Result<Test>) in
    switch result {
    case let .success(test):
        // do something with the finished object
    case let .failure(error):
        // do something with error
    }
}
```
That's a basic example. Many API requests need parameters.

## FutureResult

Here is an example of the kinds of complex logic possible with Futures:

```swift
client = DefaultMoyaNetworkClient()

// type 'Test' must be Codable
client.request(.zen)
	.observeSuccess { (test: Test) in /* do something with the finished object */ }
	.observeError { error in /* do something with error */) }
	.execute()
```

## Installation
### CocoaPods

For MoyaNetworkClient, use the following entry in your Podfile:

```rb
pod 'MoyaNetworkClient'
```

Then run `pod install`.

In any file you'd like to use Moya in, don't forget to
import the framework with `import MoyaNetworkClient`.

## Author

BarredEwe, barredEwe@gmail.com

## License

MoyaNC is released under an MIT license. See License for more information.
