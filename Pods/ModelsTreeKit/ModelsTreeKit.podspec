Pod::Spec.new do |s|

  s.name     = 'ModelsTreeKit'
  s.version  = '1.0.0'
  s.ios.deployment_target = '8.0'
  s.license  = 'MIT'
  s.summary  = 'A set of tools for building Tree of models architecture'
  s.description = 'Set of tools for building Tree of models architecture'
  s.homepage = 'https://github.com/mmrmmlrr/ModelsTreeKit'
  s.author = { 'aleksey' => 'aleksey.chernish@yalantis.com' }
  s.source   = { :git => 'https://github.com/mmrmmlrr/ModelsTreeKit.git', :tag => s.version.to_s }

  s.frameworks   = ['UIKit']
  s.source_files = '**/*.*'

end