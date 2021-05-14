# Uncomment the next line to define a global platform for your project
ios_deployment_target = '12.0'
platform :ios, ios_deployment_target

target 'Microphone Recording' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Microphone Recording
# FRP
  pod 'ReactiveSwift', '6.5.0', :inhibit_warnings => true
  pod 'ReactiveCocoa', '11.1.0', :inhibit_warnings => true

end

# Set iOS deployment target to avoid any non-informative warnings
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = ios_deployment_target
    end
  end
end
