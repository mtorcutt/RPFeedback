Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "RPFeedback"
s.summary = "RPFeedback lets ReviewPush companies submit feedback at a company level."
s.requires_arc = true

s.version = "0.1.013"

s.license = "MIT"

s.author = { "Michael Orcutt" => "michaeltorcutt@gmail.com" }

s.homepage = "http://reviewpush.com"

s.source = { :git => "https://github.com/mtorcutt/RPFeedback.git", :tag => s.version.to_s }

s.framework = "UIKit"
s.dependency 'AFNetworking'
s.dependency 'INTULocationManager'
s.dependency 'JSONModel'
s.dependency 'SZTextView'

s.source_files = "RPFeedback/**/*.{h,m}"

s.requires_arc = true

end
