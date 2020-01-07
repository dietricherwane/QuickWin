# -*- encoding: utf-8 -*-
# stub: write_xlsx 0.85.7 ruby lib

Gem::Specification.new do |s|
  s.name = "write_xlsx"
  s.version = "0.85.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Hideo NAKAMURA"]
  s.date = "2019-06-20"
  s.description = "write_xlsx is a gem to create a new file in the Excel 2007+ XLSX format."
  s.email = ["cxn03651@msj.biglobe.ne.jp"]
  s.executables = ["extract_vba.rb"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.md", "Changes"]
  s.files = ["Changes", "LICENSE.txt", "README.md", "bin/extract_vba.rb"]
  s.homepage = "http://github.com/cxn03651/write_xlsx#readme"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "write_xlsx is a gem to create a new file in the Excel 2007+ XLSX format."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<zip-zip>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rubyzip>, [">= 1.0.0"])
      s.add_dependency(%q<zip-zip>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rubyzip>, [">= 1.0.0"])
    s.add_dependency(%q<zip-zip>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
