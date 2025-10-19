# frozen_string_literal: true

require "thor"
require_relative "../postsvg"

module Postsvg
  # Command-line interface for postsvg
  class CLI < Thor
    desc "convert INPUT [OUTPUT]", "Convert PostScript/EPS file to SVG"
    long_desc <<~DESC
      Convert a PostScript (.ps) or Encapsulated PostScript (.eps) file to SVG format.

      If OUTPUT is not specified, the output will be written to stdout.

      Examples:

        $ postsvg convert input.ps output.svg
        $ postsvg convert input.eps > output.svg
    DESC
    def convert(input_path, output_path = nil)
      unless File.exist?(input_path)
        say "Error: Input file '#{input_path}' not found", :red
        exit 1
      end

      begin
        ps_content = File.read(input_path)
        svg_output = Postsvg.convert(ps_content)

        if output_path
          File.write(output_path, svg_output)
          say "Successfully converted #{input_path} to #{output_path}", :green
        else
          puts svg_output
        end
      rescue Postsvg::Error => e
        say "Conversion error: #{e.message}", :red
        exit 1
      rescue StandardError => e
        say "Unexpected error: #{e.message}", :red
        say e.backtrace.join("\n"), :red if options[:verbose]
        exit 1
      end
    end

    desc "batch INPUT_DIR [OUTPUT_DIR]",
         "Convert all PS/EPS files in a directory"
    long_desc <<~DESC
      Convert all .ps and .eps files in INPUT_DIR to SVG format.

      If OUTPUT_DIR is specified, SVG files will be written there.
      Otherwise, SVG files will be written to the same directory as the input files.

      Examples:

        $ postsvg batch ps_files/
        $ postsvg batch ps_files/ svg_files/
    DESC
    def batch(input_dir, output_dir = nil)
      unless Dir.exist?(input_dir)
        say "Error: Input directory '#{input_dir}' not found", :red
        exit 1
      end

      Dir.mkdir(output_dir) if output_dir && !Dir.exist?(output_dir)

      pattern = File.join(input_dir, "*.{ps,eps}")
      files = Dir.glob(pattern, File::FNM_CASEFOLD)

      if files.empty?
        say "No PS or EPS files found in #{input_dir}", :yellow
        return
      end

      say "Found #{files.size} file(s) to convert", :cyan

      files.each do |input_path|
        basename = File.basename(input_path, ".*")
        output_path = if output_dir
                        File.join(output_dir, "#{basename}.svg")
                      else
                        File.join(input_dir, "#{basename}.svg")
                      end

        begin
          ps_content = File.read(input_path)
          svg_output = Postsvg.convert(ps_content)
          File.write(output_path, svg_output)
          say "  ✓ #{input_path} → #{output_path}", :green
        rescue Postsvg::Error => e
          say "  ✗ #{input_path}: #{e.message}", :red
        rescue StandardError => e
          say "  ✗ #{input_path}: Unexpected error: #{e.message}", :red
        end
      end
    end

    desc "version", "Show version"
    def version
      say "postsvg version #{Postsvg::VERSION}"
    end
  end
end
