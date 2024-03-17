
Pod::Spec.new do |s|

	s.name         = "PopupUI"

	s.version      = "1.0.1"

	s.summary      = "Easy to pop up any view by SwiftUI！    SwiftUI 实现的弹窗控件，简单易用！"

	s.description  = <<-DESC
		Easy to pop up any view by SwiftUI！    SwiftUI 实现的弹窗控件，简单易用！
		Code less than 3 lines！	代码超过 3 行算我输！
	DESC

	s.homepage     = "http://github.com/pikacode/PopupUI"

	s.license      = "MIT"

	s.author       = { "pikacode" => "pikacode@qq.com" }

	s.platform     = :ios, "15.0"

	s.source       = { :git => "https://github.com/pikacode/PopupUI.git", :tag => "#{s.version}" }

	s.source_files  =  "Sources/PopupUI/*.{swift}"

	s.frameworks = "SwiftUI", "Combine"

	s.requires_arc = true
	s.swift_versions = "5.5"

end
