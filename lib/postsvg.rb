# frozen_string_literal: true

require_relative "postsvg/version"
require_relative "postsvg/errors"
require_relative "postsvg/tokenizer"
require_relative "postsvg/interpreter"

module Postsvg
  class << self
    # Convert PostScript content to SVG
    def convert(ps_content)
      bbox = extract_bounding_box(ps_content)
      tokens = Tokenizer.tokenize(ps_content)

      interpreter = Interpreter.new
      svg_out = interpreter.interpret(tokens, bbox)

      generate_svg(svg_out, bbox)
    end

    # Convert PostScript file to SVG
    def convert_file(input_path, output_path = nil)
      ps_content = File.read(input_path)
      svg_content = convert(ps_content)

      File.write(output_path, svg_content) if output_path

      svg_content
    end

    private

    def extract_bounding_box(ps_content)
      match = ps_content.match(/%%BoundingBox:\s*([-+0-9.eE]+)\s+([-+0-9.eE]+)\s+([-+0-9.eE]+)\s+([-+0-9.eE]+)/)
      return nil unless match

      {
        llx: match[1].to_f,
        lly: match[2].to_f,
        urx: match[3].to_f,
        ury: match[4].to_f,
      }
    end

    def generate_svg(svg_out, bbox)
      if bbox
        width = bbox[:urx] - bbox[:llx]
        height = bbox[:ury] - bbox[:lly]
        view_box = "viewBox=\"#{num_fmt(bbox[:llx])} #{num_fmt(bbox[:lly])} #{num_fmt(width)} #{num_fmt(height)}\" " \
                   "width=\"#{num_fmt(width)}\" height=\"#{num_fmt(height)}\""
      else
        width = 1920
        height = 1080
        view_box = "viewBox=\"0 0 #{width} #{height}\" width=\"#{width}\" height=\"#{height}\""
      end

      defs = svg_out[:defs].empty? ? "" : "<defs>\n#{svg_out[:defs].join("\n")}\n</defs>"
      shapes = svg_out[:element_shapes].join("\n")
      texts = svg_out[:element_texts].join("\n")
      body = "<g transform=\"translate(0 #{height}) scale(1 -1)\">\n#{shapes}\n#{texts}</g>"

      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" \
        "<svg xmlns=\"http://www.w3.org/2000/svg\" #{view_box}>\n" \
        "#{defs}\n" \
        "#{body}\n" \
        "</svg>"
    end

    def num_fmt(n)
      # Format number, removing unnecessary decimals
      if n == n.to_i
        n.to_i.to_s
      else
        format("%.3f", n).sub(/\.?0+$/, "")
      end
    end
  end
end
