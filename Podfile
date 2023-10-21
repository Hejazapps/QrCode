# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'QrCodeMaker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for QrCodeMaker

  target 'QrCodeMakerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'QrCodeMakerUITests' do
    # Pods for testing
  end
 post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

  pod 'EANBarcodeGenerator'
  pod 'EAN13BarcodeGenerator'
  pod 'CDCodabarView'
  pod 'RSBarcodes_Swift'
  pod 'EFQRCode', '~> 5.1.6'
  pod 'RSBarcodes_Swift'
  pod 'EAN13BarcodeGenerator'
  pod 'ZXingObjC'
  pod 'IHProgressHUD'
  pod 'SwiftyStoreKit'
  pod 'SVProgressHUD'
  pod 'QRCode', :git => 'https://github.com/dagronf/qrcode.git', :tag => '15.0.0'
  pod 'EANBarcodeGenerator'
  pod 'BarCodeKit'
  pod 'SwiftyStoreKit'
  pod 'SwiftLint'
  pod "KRProgressHUD"

end
