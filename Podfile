# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target '2Password' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 2Password
  pod 'SnapKit'
  pod 'KeychainItemWrapper'
  pod 'EncryptedCoreData',          # xcode 9 workaround
  :git => 'https://github.com/project-imas/encrypted-core-data.git',
  :commit => 'b97ffaf2f'

  target '2PasswordTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
