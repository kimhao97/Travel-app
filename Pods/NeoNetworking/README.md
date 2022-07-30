# NeoNetworking

![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg) 
![documents](https://img.shields.io/badge/documents-0%25-brightgreen.svg)
![version](https://img.shields.io/badge/version-v1.0.0-blue.svg)

Neo networking is a library for call api services, we support some features :


- Call api service to neo with common convension of our backend.

- Long live support.

For more information please check the pdf file: [NeoNetworking lib intergration guide.pdf] in the root folder

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Permission to access the this repo. Nothing needed.

## Installation

NeoNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NeoNetworking', :git => 'https://bitbucket.org/nldanang/neonetworking.git',
```

## Intergration flow:

- Step 1: The Lib require pre-config, by conform protocol APIConfigable, Example:
```
class APIConfigableSample: APIConfigable {
    var host: String = "https://api.dev.ultra.bla-one.net/api/"
}
```

- Step 2: Create entry service for your code, typically it should be put to your service holder using Swinject or simply make it static, Example: 
```
static let apiService = NeoNetworkProvider(with: APIConfigableSample())
```

- Step 3: to use it just need to call func load(api:), and give it input and output,Example
```
apiService.load(api: Class_Which_Conform_NeoApiInputable_Protocol()) { result in
           // do anything with result
}
```
When : *Class_Which_Conform_NeoApiInputable_Protocol* is an implementation of NeoApiInputable(Dont worry, you can't miss it :v)

## Author

Neo iOS team.

## Author

Neo iOS team.

## Request a fix or pull request

Make sure following things:

- Enable log with .full in your setting and send to us.

- Make sure you run test before any pull request(cov is 100% now, so please make sure all of new code coveraged by unit test).

## License

NeoNetworking is available under the MIT license. See the LICENSE file for more info.
