# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RemeApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'IQKeyboardManagerSwift'
pod 'RealmSwift', '~>10'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseFirestoreSwift'
pod 'FirebaseStorage'
pod 'LicensePlist'
pod 'Firebase/Crashlytics'
pod 'Firebase/Analytics'

  # Pods for RemeApp

end

# post install
post_install do |installer|
  # ios deployment version
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
