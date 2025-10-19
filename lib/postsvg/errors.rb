# frozen_string_literal: true

module Postsvg
  class Error < StandardError; end

  class ParseError < Error; end

  class ConversionError < Error; end

  class UnsupportedOperatorError < Error; end
end
