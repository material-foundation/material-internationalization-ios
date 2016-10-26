Pod::Spec.new do |s|
  s.name         = "MDFInternationalization"
  s.version      = "0.1.1"
  s.authors      = { 'Ian Gordon' => 'iangordon@google.com' }
  s.summary      = "Internationalization tools."
  s.homepage     = "https://TODO"
  s.license      = "Apache 2.0"
  s.source       = { :git => "https://TODO", :tag => s.version.to_s }
  s.platform     = :ios, "8.0"

  s.requires_arc = true
  s.public_header_files = "Sources/*.h"
  s.source_files = "Sources/*.{h,m}"
  s.header_mappings_dir = "Sources"
end
