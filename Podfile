source 'https://github.com/CocoaPods/Specs.git'
target 'gotrack' do
  use_frameworks!
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'MMDrawerController', '~> 0.5.7'
  pod 'RESideMenu', '~> 4.0.7'
  pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'
  pod 'RealmSwift'
  post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
 end
end
