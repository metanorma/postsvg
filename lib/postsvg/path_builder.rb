# frozen_string_literal: true

require_relative "matrix"

module Postsvg
  # Builds SVG path strings with optional coordinate transformations
  class PathBuilder
    attr_reader :parts

    def initialize
      @parts = []
      @use_local_coords = false
      @ctm = nil
    end

    def set_transform_mode(use_local, transform = nil)
      @use_local_coords = use_local
      @ctm = transform
    end

    def move_to(x, y)
      p = transform_point(x, y)
      @parts << "M #{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def move_to_rel(dx, dy)
      p = transform_point(dx, dy)
      @parts << "m #{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def line_to(x, y)
      p = transform_point(x, y)
      @parts << "L #{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def line_to_rel(dx, dy)
      p = transform_point(dx, dy)
      @parts << "l #{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def curve_to(x1, y1, x2, y2, x, y)
      p1 = transform_point(x1, y1)
      p2 = transform_point(x2, y2)
      p = transform_point(x, y)
      @parts << "C #{num_fmt(p1[:x])} #{num_fmt(p1[:y])} " \
                "#{num_fmt(p2[:x])} #{num_fmt(p2[:y])} " \
                "#{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def curve_to_rel(dx1, dy1, dx2, dy2, dx, dy)
      p1 = transform_point(dx1, dy1)
      p2 = transform_point(dx2, dy2)
      p = transform_point(dx, dy)
      @parts << "c #{num_fmt(p1[:x])} #{num_fmt(p1[:y])} " \
                "#{num_fmt(p2[:x])} #{num_fmt(p2[:y])} " \
                "#{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def ellipse_to(rx, ry, rotation, large_arc, sweep, x, y)
      p = transform_point(x, y)
      @parts << "A #{num_fmt(rx)} #{num_fmt(ry)} #{num_fmt(rotation)} " \
                "#{large_arc} #{sweep} #{num_fmt(p[:x])} #{num_fmt(p[:y])}"
    end

    def close
      @parts << "Z"
    end

    def to_path
      @parts.join(" ")
    end

    def length
      @parts.length
    end

    def clear
      @parts = []
    end

    def reset
      new_path = PathBuilder.new
      new_path.set_transform_mode(@use_local_coords, @ctm)
      new_path
    end

    private

    def transform_point(x, y)
      if !@use_local_coords && @ctm
        @ctm.apply_point(x, y)
      else
        { x: x, y: y }
      end
    end

    def num_fmt(n)
      format("%.3f", n).sub(/\.?0+$/, "")
    end
  end
end
