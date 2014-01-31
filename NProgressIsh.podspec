Pod::Spec.new do |s|
  s.name         = "NProgressIsh"
  s.version      = "0.1.0"
  s.summary      = "NProgress like style progress bar for iOS"
  s.description  = <<-DESC
                    Yeah buddy! NProgress like style progress bar for iOS
                   DESC
  s.homepage     = "https://github.com/joshdholtz/NProgressIsh-iOS"
  s.license      = 'MIT'
  s.author       = { "Josh Holtz" => "me@joshholtz.com" }
  s.source       = { :git => "https://github.com/joshdholtz/NProgressIsh-iOS.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true

  s.public_header_files = 'Classes/*.h'
  s.source_files = 'Classes/*'
end
