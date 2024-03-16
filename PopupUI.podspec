
Pod::Spec.new do |s|

	s.name         = "PopupUI"

	s.version      = "1.0.0"

	s.summary      = "Easy to pop up any view by SwiftUI！    SwiftUI 实现的弹窗控件，简单易用！"

	s.description  = <<-DESC
		Code less than 3 lines！
		代码超过3行算我输！
	DESC

	s.homepage     = "https://github.com/pikacode/PopupUI"

	s.license      = "MIT"

	s.author             = { "pikacode" => "pikacode@qq.com" }

	s.platform     = :ios, "13.0"

	s.source       = { :git => "https://github.com/pikacode/PopupUI", :tag => "#{s.version}" }

	s.source_files  =  "PopupUI/Sources/PopupUI/*.{swift}"

	s.frameworks = "SwiftUI", "Combine"

	s.requires_arc = true

end
