
Pod::Spec.new do |s|

  s.name         = "JsonReciprocity"
  s.version      = "1.0.0"
  s.summary      = "A wonderful framework for converting between JsonString and JsonObject."
  s.description  = <<-DESC
                   A wonderful framework for converting between JsonString and JsonObject. Don't need to extends any class. Convenient、Flexible、Easy to Use.
                   DESC

  s.homepage     = "https://github.com/javenl/JsonReciprocity"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author       = { "Javen_liu" => "412775083@qq.com" }

  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/javenl/JsonReciprocity.git", :tag => "#{s.version}" }
  s.source_files = "JsonReciprocity/JsonReciprocity/*.{h,m}"
  s.requires_arc = true

end
