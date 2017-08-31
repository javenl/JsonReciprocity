
Pod::Spec.new do |s|

  s.name         = "JsonReciprocity"
  s.version      = "1.0.4"
  s.summary      = "A lightweight framework for converting between Json String and Json Object."
  s.description  = <<-DESC
                   A lightweight and fastest framework for converting between Json String and Json Object. This is a category that don't need to extends any other class. Convenient、Flexible、Easy to Use.
                   DESC

  s.homepage     = "https://github.com/javenl/JsonReciprocity"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author       = { "Javen_liu" => "412775083@qq.com" }

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/javenl/JsonReciprocity.git", :tag => "#{s.version}" }
  s.source_files = "JsonReciprocity/JsonReciprocity/*.{h,m}"
  s.requires_arc = true

end
