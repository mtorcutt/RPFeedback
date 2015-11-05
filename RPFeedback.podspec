Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '7.0'
s.name = "RPFeedback"
s.summary = "RPFeedback lets ReviewPush companies submit feedback at a company level."
s.requires_arc = true

# 2
s.version = "0.1.06"

# 3
s.license = "MIT"

# 4 - Replace with your name and e-mail address
s.author = { "Michael Orcutt" => "michaeltorcutt@gmail.com" }

# For example,
# s.author = { "Joshua Greene" => "jrg.developer@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "http://reviewpush.com"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/mtorcutt/RPFeedback.git", :tag => s.version }

# 7
s.framework = "UIKit"
s.dependency 'AFNetworking'
s.dependency 'INTULocationManager'
s.dependency 'JSONModel'
s.dependency 'SZTextView'

# 8
s.source_files = "RPFeedback/**/*.{h,m}"

# 9
# s.resources = "RPFeedback/**/*.{png,jpeg,jpg,storyboard,xib}"

# 10
s.requires_arc = true

end
