# frozen_string_literal: true

require "parslet"
require_relative "parser/postscript_parser"
require_relative "parser/transform"

module Postsvg
  # Main parser interface for PostScript/EPS files
  class Parser
    def self.parse(ps_content)
      parser = PostscriptParser.new
      tree = parser.parse(ps_content)
      Transform.new.apply(tree)
    rescue Parslet::ParseFailed => e
      raise ParseError, "Failed to parse PostScript: #{e.message}"
    end
  end
end
