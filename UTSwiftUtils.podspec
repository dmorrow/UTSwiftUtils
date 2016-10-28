#
# Be sure to run `pod lib lint UTSwiftUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UTSwiftUtils'
  s.version          = '0.3.0'
  s.summary          = 'A collection of useful Swift extensions'

  s.homepage         = 'https://github.com/dmorrow/UTSwiftUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Danny Morrow' => 'danny@unitytheory.com' }
  s.source           = { :git => 'https://github.com/dmorrow/UTSwiftUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'


  s.default_subspec = 'Base'

  s.subspec 'Base' do |base|
  # subspec for no CoreData
    base.source_files = 'UTSwiftUtils/Classes/{Base,UI}/**/*'
    base.frameworks = 'UIKit'
  end

  s.subspec 'CoreData' do |coredata|
    coredata.source_files = 'UTSwiftUtils/Classes/CoreData/**/*'
    coredata.frameworks = 'CoreData'
  end

end
