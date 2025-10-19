# frozen_string_literal: true

module Postsvg
  # Color conversion utilities for PostScript color models
  module Colors
    # Convert RGB values (0-1) to RGB color string
    def self.color2rgb(rgb)
      r, g, b = rgb
      r = [[r * 255, 0].max, 255].min.round
      g = [[g * 255, 0].max, 255].min.round
      b = [[b * 255, 0].max, 255].min.round
      format("rgb(%d, %d, %d)", r, g, b)
    end

    # Convert grayscale value (0-1) to RGB color string
    def self.gray2rgb(gray)
      val = [[gray * 255, 0].max, 255].min.round
      format("rgb(%d, %d, %d)", val, val, val)
    end

    # Convert CMYK values (0-1) to RGB color string
    def self.cmyk2rgb(cmyk)
      c, m, y, k = cmyk
      r = 255 * (1 - c) * (1 - k)
      g = 255 * (1 - m) * (1 - k)
      b = 255 * (1 - y) * (1 - k)
      r = [[r, 0].max, 255].min.round
      g = [[g, 0].max, 255].min.round
      b = [[b, 0].max, 255].min.round
      format("rgb(%d, %d, %d)", r, g, b)
    end
  end
end
