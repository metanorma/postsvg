#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/postsvg"

FIXTURES = {
  "spec/fixtures/ps2svg/colors.ps" => "spec/fixtures/ps2svg/colors_expected.svg",
  "spec/fixtures/ps2svg/example_full.ps" => "spec/fixtures/ps2svg/example_full_expected.svg",
  "spec/fixtures/ps2svg/file.ps" => "spec/fixtures/ps2svg/file_expected.svg",
  "spec/fixtures/ps2svg/prog.ps" => "spec/fixtures/ps2svg/prog_expected.svg",
  "spec/fixtures/ps2svg/img.ps" => "spec/fixtures/ps2svg/ref.svg",
  "spec/fixtures/eps2svg/img.eps" => "spec/fixtures/eps2svg/ref.svg",
}.freeze

FIXTURES.each do |input_path, output_path|
  unless File.exist?(input_path)
    puts "Skipping #{input_path} (not found)"
    next
  end

  puts "Converting #{input_path} -> #{output_path}"
  input_content = File.read(input_path)
  svg_content = Postsvg.convert(input_content)
  File.write(output_path, svg_content)
  puts "  ✓ Generated #{output_path}"
end

puts "\nAll fixtures regenerated successfully!"
