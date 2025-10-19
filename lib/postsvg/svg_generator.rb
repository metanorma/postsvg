# frozen_string_literal: true

module Postsvg
  # Generates SVG output from PostScript graphics operations
  class SvgGenerator
    def initialize
      @paths = []
    end

    def add_path(path, graphics_state, operation)
      return if path.empty?

      svg_path = {
        d: build_path_data(path),
        operation: operation,
        stroke: graphics_state.stroke_color_hex,
        fill: graphics_state.fill_color_hex,
        stroke_width: graphics_state.line_width,
      }

      @paths << svg_path
    end

    def generate(width:, height:, viewbox:)
      svg_parts = []
      svg_parts << '<?xml version="1.0" encoding="UTF-8"?>'
      svg_parts << %(<svg xmlns="http://www.w3.org/2000/svg" )
      svg_parts << %(width="#{width}" height="#{height}" )
      svg_parts << %(viewBox="#{viewbox}">)

      @paths.each do |path|
        svg_parts << build_path_element(path)
      end

      svg_parts << "</svg>"
      svg_parts.join("\n")
    end

    private

    def build_path_data(path)
      path_commands = []

      path.each do |segment|
        case segment[:type]
        when :moveto
          path_commands << "M #{segment[:x]} #{segment[:y]}"
        when :lineto
          path_commands << "L #{segment[:x]} #{segment[:y]}"
        when :curveto
          path_commands << "C #{segment[:x1]} #{segment[:y1]}, " \
                           "#{segment[:x2]} #{segment[:y2]}, " \
                           "#{segment[:x3]} #{segment[:y3]}"
        when :closepath
          path_commands << "Z"
        end
      end

      path_commands.join(" ")
    end

    def build_path_element(path)
      attrs = [%(d="#{path[:d]}")]

      case path[:operation]
      when :stroke
        attrs << %(fill="none")
        attrs << %(stroke="#{path[:stroke]}")
        attrs << %(stroke-width="#{path[:stroke_width]}")
      when :fill
        attrs << %(fill="#{path[:fill]}")
        attrs << %(stroke="none")
      end

      %(<path #{attrs.join(' ')} />)
    end
  end
end
