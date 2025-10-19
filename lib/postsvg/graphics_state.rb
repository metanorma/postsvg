# frozen_string_literal: true

module Postsvg
  # Manages PostScript graphics state including path, color, transforms, etc.
  class GraphicsState
    attr_accessor :line_width, :current_x, :current_y
    attr_reader :current_path, :fill_color, :stroke_color

    def initialize
      @current_path = []
      @current_x = 0
      @current_y = 0
      @line_width = 1.0
      @fill_color = { r: 0, g: 0, b: 0 }
      @stroke_color = { r: 0, g: 0, b: 0 }
      @state_stack = []
      @transform_matrix = [1, 0, 0, 1, 0, 0] # Identity matrix [a, b, c, d, e, f]
    end

    # Path construction operations
    def moveto(x, y)
      coords = transform_point(x, y)
      @current_x = coords[:x]
      @current_y = coords[:y]
      @current_path << { type: :moveto, x: @current_x, y: @current_y }
    end

    def lineto(x, y)
      coords = transform_point(x, y)
      @current_x = coords[:x]
      @current_y = coords[:y]
      @current_path << { type: :lineto, x: @current_x, y: @current_y }
    end

    def rlineto(dx, dy)
      # Relative line to
      lineto(@current_x + dx, @current_y + dy)
    end

    def curveto(x1, y1, x2, y2, x3, y3)
      coords1 = transform_point(x1, y1)
      coords2 = transform_point(x2, y2)
      coords3 = transform_point(x3, y3)

      @current_path << {
        type: :curveto,
        x1: coords1[:x], y1: coords1[:y],
        x2: coords2[:x], y2: coords2[:y],
        x3: coords3[:x], y3: coords3[:y]
      }

      @current_x = coords3[:x]
      @current_y = coords3[:y]
    end

    def closepath
      @current_path << { type: :closepath }
    end

    def newpath
      @current_path = []
    end

    # Color operations
    def set_rgb_color(r, g, b)
      color = { r: r, g: g, b: b }
      @fill_color = color
      @stroke_color = color
    end

    def set_gray(gray)
      set_rgb_color(gray, gray, gray)
    end

    # Graphics state stack
    def save
      @state_stack.push({
                          path: @current_path.dup,
                          x: @current_x,
                          y: @current_y,
                          line_width: @line_width,
                          fill_color: @fill_color.dup,
                          stroke_color: @stroke_color.dup,
                          transform_matrix: @transform_matrix.dup,
                        })
    end

    def restore
      return if @state_stack.empty?

      state = @state_stack.pop
      @current_path = state[:path]
      @current_x = state[:x]
      @current_y = state[:y]
      @line_width = state[:line_width]
      @fill_color = state[:fill_color]
      @stroke_color = state[:stroke_color]
      @transform_matrix = state[:transform_matrix]
    end

    # Transformation operations
    def translate(tx, ty)
      # Modify transformation matrix for translation
      @transform_matrix[4] += tx
      @transform_matrix[5] += ty
    end

    def scale(sx, sy)
      # Modify transformation matrix for scaling
      @transform_matrix[0] *= sx
      @transform_matrix[1] *= sx
      @transform_matrix[2] *= sy
      @transform_matrix[3] *= sy
    end

    def rotate(angle)
      # Convert angle from degrees to radians
      rad = angle * Math::PI / 180.0
      cos_a = Math.cos(rad)
      sin_a = Math.sin(rad)

      # Create rotation matrix and multiply with current matrix
      a, b, c, d, e, f = @transform_matrix
      @transform_matrix = [
        (a * cos_a) + (c * sin_a),
        (b * cos_a) + (d * sin_a),
        (-a * sin_a) + (c * cos_a),
        (-b * sin_a) + (d * cos_a),
        e,
        f,
      ]
    end

    # Helper methods
    def rgb_to_hex(r, g, b)
      format("#%02x%02x%02x", (r * 255).to_i, (g * 255).to_i, (b * 255).to_i)
    end

    def fill_color_hex
      rgb_to_hex(fill_color[:r], fill_color[:g], fill_color[:b])
    end

    def stroke_color_hex
      rgb_to_hex(stroke_color[:r], stroke_color[:g], stroke_color[:b])
    end

    private

    def transform_point(x, y)
      # Apply transformation matrix to point
      a, b, c, d, e, f = @transform_matrix
      {
        x: (a * x) + (c * y) + e,
        y: (b * x) + (d * y) + f,
      }
    end
  end
end
