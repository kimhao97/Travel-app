# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'HomeWork_UIKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'NeoNetworking', :git => 'https://bitbucket.org/nldanang/neonetworking.git'
  pod 'RxSwift', '5.0.0'
  pod 'RxCocoa', '5.0.0'
  pod 'SwiftEventBus', :tag => '5.0.1', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
  pod 'Swinject', '2.6.0'              # Library support dependency injection
  pod 'SwinjectStoryboard', '2.2.0'    # Library support dependency injection
  pod 'Then'
  pod 'Reusable'
  pod 'AnimatedCollectionViewLayout'
  pod 'SkeletonView'
  pod 'NVActivityIndicatorView'
  
  # Library for network service
  pod 'SwifterSwift', '5.2.0'
  pod 'Kingfisher', '5.13.4'
  pod 'SwiftLint'
  pod 'netfox'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  # Pods for HomeWork_UIKit

  target 'HomeWork_UIKitTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HomeWork_UIKitUITests' do
    # Pods for testing
  end
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
