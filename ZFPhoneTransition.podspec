Pod::Spec.new do |s|
    s.name         = 'ZFPhoneTransition'
    s.version      = '0.0.1'
    s.summary      = '仿qq电话转场动画'
    s.homepage     = 'https://github.com/renzifeng/ZFPhoneTransition'
    s.license      = 'MIT'
    s.authors      = { 'renzifeng' => 'zifeng1300@gmail.com' }
    s.platform     = :ios, '8.0'
    s.source       = { :git => 'https://github.com/renzifeng/ZFPhoneTransition.git', :tag => s.version.to_s }
    s.source_files = 'ZFPhone/**/*.{h,m}'
    s.framework    = 'UIKit'
    s.requires_arc = true
end