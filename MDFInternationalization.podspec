Pod::Spec.new do |spec|
  spec.name         = "MDFInternationalization"
  spec.version      = "0.2.1"
  spec.authors      = { 'Ian Gordon' => 'iangordon@google.com' }
  spec.summary      = "Internationalization tools."
  spec.homepage     = "https://github.com/material-foundation/material-internationalization-ios"
  spec.license      = "Apache License, Version 2.0"
  spec.source       = { :git => "https://github.com/material-foundation/material-internationalization-ios.git", :tag => "v#{spec.version}" }
  spec.platform     = :ios, "8.0"

  spec.requires_arc = true
  spec.public_header_files = "Sources/*.h"
  spec.source_files = "Sources/*.{h,m}"
  spec.header_mappings_dir = "Sources"
  spec.header_dir = "MDFInternationalization"
end
