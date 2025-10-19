# frozen_string_literal: true

require_relative "graphics_state"
require_relative "svg_generator"

module Postsvg
  # Converts PostScript/EPS to SVG by interpreting PostScript commands
  class Converter
    attr_reader :ps_content, :graphics_state, :svg_generator

    def initialize(ps_content)
      @ps_content = ps_content
      @graphics_state = GraphicsState.new
      @svg_generator = SvgGenerator.new
      @stack = []
      @dictionary = {}
    end

    def convert
      # Parse PostScript
      ast = Parser.parse(ps_content)

      # Extract BoundingBox for SVG viewBox
      extract_bounding_box

      # Execute PostScript commands
      execute_program(ast[:statements])

      # Generate SVG
      svg_generator.generate(
        width: @bbox_width,
        height: @bbox_height,
        viewbox: @viewbox,
      )
    end

    private

    def extract_bounding_box
      # Look for %%BoundingBox comment
      if ps_content =~ /%%BoundingBox:\s*(-?\d+)\s+(-?\d+)\s+(-?\d+)\s+(-?\d+)/
        llx = ::Regexp.last_match(1).to_f
        lly = ::Regexp.last_match(2).to_f
        urx = ::Regexp.last_match(3).to_f
        ury = ::Regexp.last_match(4).to_f

        @bbox_width = urx - llx
        @bbox_height = ury - lly
        @viewbox = "#{llx} #{lly} #{@bbox_width} #{@bbox_height}"
      else
        # Default values if no BoundingBox found
        @bbox_width = 612
        @bbox_height = 792
        @viewbox = "0 0 #{@bbox_width} #{@bbox_height}"
      end
    end

    def execute_program(statements)
      return if statements.nil? || statements.empty?

      statements.each do |statement|
        execute_statement(statement)
      end
    end

    def execute_statement(statement)
      case statement
      when Hash
        execute_hash_statement(statement)
      when Numeric
        @stack.push(statement)
      when String
        @stack.push(statement)
      else
        # Unknown statement type
      end
    end

    def execute_hash_statement(statement)
      case statement[:type]
      when :operator
        execute_operator(statement[:value])
      when :name
        @stack.push(statement)
      when :array
        @stack.push(statement)
      when :procedure
        @stack.push(statement)
      end
    end

    def execute_operator(op)
      case op
      # Path construction
      when "moveto"
        y = @stack.pop
        x = @stack.pop
        graphics_state.moveto(x, y)
      when "lineto"
        y = @stack.pop
        x = @stack.pop
        graphics_state.lineto(x, y)
      when "rlineto"
        dy = @stack.pop
        dx = @stack.pop
        graphics_state.rlineto(dx, dy)
      when "curveto"
        y3 = @stack.pop
        x3 = @stack.pop
        y2 = @stack.pop
        x2 = @stack.pop
        y1 = @stack.pop
        x1 = @stack.pop
        graphics_state.curveto(x1, y1, x2, y2, x3, y3)
      when "closepath"
        graphics_state.closepath

      # Painting
      when "stroke"
        svg_generator.add_path(graphics_state.current_path, graphics_state,
                               :stroke)
        graphics_state.newpath
      when "fill"
        svg_generator.add_path(graphics_state.current_path, graphics_state,
                               :fill)
        graphics_state.newpath
      when "newpath"
        graphics_state.newpath

      # Color
      when "setrgbcolor"
        b = @stack.pop
        g = @stack.pop
        r = @stack.pop
        graphics_state.set_rgb_color(r, g, b)
      when "setgray"
        gray = @stack.pop
        graphics_state.set_gray(gray)

      # Line attributes
      when "setlinewidth"
        width = @stack.pop
        graphics_state.line_width = width

      # Graphics state
      when "gsave"
        graphics_state.save
      when "grestore"
        graphics_state.restore

      # Transformations
      when "translate"
        ty = @stack.pop
        tx = @stack.pop
        graphics_state.translate(tx, ty)
      when "scale"
        sy = @stack.pop
        sx = @stack.pop
        graphics_state.scale(sx, sy)
      when "rotate"
        angle = @stack.pop
        graphics_state.rotate(angle)

      # Dictionary and procedure operations
      when "def"
        value = @stack.pop
        key = @stack.pop
        if key.is_a?(Hash) && key[:type] == :name
          @dictionary[key[:value]] =
            value
        end
      when "dict"
        size = @stack.pop
        @stack.push({ type: :dict, size: size, entries: {} })
      when "begin"
        # Begin dictionary - for now, just pop it
        @stack.pop
      when "end"
        # End dictionary
      when "exch"
        # Exchange top two stack items
        a = @stack.pop
        b = @stack.pop
        @stack.push(a)
        @stack.push(b)
      when "dup"
        # Duplicate top stack item
        top = @stack.last
        @stack.push(top)

      # Font operations (minimal support - we'll ignore text rendering for now)
      when "findfont", "scalefont", "setfont", "show", "moveto"
        # For text operations, we'll need more sophisticated handling
        # For now, just consume the required stack items
        case op
        when "show"
          @stack.pop # string to show
        when "scalefont"
          @stack.pop # scale
          @stack.pop # font
        when "findfont"
          @stack.pop # font name
        end

      else
        # Check if it's a defined procedure
        if @dictionary.key?("/#{op}")
          proc_def = @dictionary["/#{op}"]
          execute_program(proc_def[:value]) if proc_def.is_a?(Hash) && proc_def[:type] == :procedure
        end
      end
    end
  end
end
