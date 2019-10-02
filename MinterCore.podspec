#
# Be sure to run `pod lib lint MinterCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MinterCore'
  s.version          = '0.1.25'
  s.summary          = 'A short description of MinterCore.'
  s.homepage         = 'https://github.com/MinterTeam'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sidorov.panda' => 'ody344@gmail.com' }
  s.source           = { :git => 'https://github.com/MinterTeam/MinterCore-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.swift_version = '4.2'
  s.source_files = 'MinterCore/Classes/**/*'
  s.dependency 'Alamofire', '4.7.3'
  s.dependency 'ObjectMapper', '~> 3.1'
  s.dependency 'BigInt', '~> 3.0'
  s.dependency 'CryptoSwift', '~> 1.0'
  s.dependency 'secp256k1.swift', '~> 0.1'
end
