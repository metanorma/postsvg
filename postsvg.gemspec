# frozen_string_literal: true

require_relative "lib/postsvg/version"

Gem::Specification.new do |spec|
  spec.name = "postsvg"
  spec.version = Postsvg::VERSION
  spec.authors = ["Ribose Inc."]
  spec.email = ["open.source@ribose.com"]

  spec.summary = "Pure Ruby PostScript/EPS to SVG converter"
  spec.description = <<~HEREDOC
    Postsvg provides a pure Ruby library for converting PostScript (PS) and
    Encapsulated PostScript (EPS) files to clean,
    standards-compliant Scalable Vector Graphics (SVG) format output.
  HEREDOC

  spec.homepage = "https://github.com/metanorma/postsvg"
  spec.license = "BSD-2-Clause"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/metanorma/postsvg"
  spec.metadata["changelog_uri"] = "https://github.com/metanorma/postsvg"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet"
  spec.add_dependency "thor"
end
