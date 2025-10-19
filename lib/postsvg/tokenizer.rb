# frozen_string_literal: true

module Postsvg
  # Token structure
  Token = Struct.new(:type, :value, keyword_init: true)

  # Tokenizes PostScript code into tokens
  class Tokenizer
    def self.tokenize(ps_code)
      # Remove comments
      ps = ps_code.gsub(/%[^\n\r]*/, " ")

      tokens = []
      index = 0

      while index < ps.length
        # Skip whitespace
        index += 1 while index < ps.length && ps[index].match?(/\s/)
        break if index >= ps.length

        # Try to match different token types
        token, new_index = match_token(ps, index)
        if token
          tokens << token
          index = new_index
        else
          # Skip invalid character
          index += 1
        end
      end

      tokens
    end

    def self.match_token(ps, index)
      # String: (foo) or (a\)b)
      return match_string(ps, index) if ps[index] == "("

      # Number: 12 .2 3e4
      if (match = ps[index..].match(/\A-?(?:\d+\.\d+|\d+\.|\.\d+|\d+)(?:[eE][+-]?\d+)?/))
        return [Token.new(type: "number", value: match[0]),
                index + match[0].length]
      end

      # Braces: { }
      return [Token.new(type: "brace", value: ps[index]), index + 1] if ["{",
                                                                         "}"].include?(ps[index])

      # Brackets: [ ]
      return [Token.new(type: "bracket", value: ps[index]), index + 1] if ["[",
                                                                           "]"].include?(ps[index])

      # Dict markers: << >>
      return [Token.new(type: "dict", value: ps[index, 2]), index + 2] if [
        "<<", ">>"
      ].include?(ps[index, 2])

      # Hex strings: <...>
      if ps[index] == "<" && ps[index + 1] != "<"
        return match_hex_string(ps,
                                index)
      end

      # Names/Operators: /foo or foo
      if (match = ps[index..].match(%r{\A/?[A-Za-z_\-.?*][A-Za-z0-9_\-.?*]*}))
        value = match[0]
        if value.start_with?("/")
          return [Token.new(type: "name", value: value[1..]),
                  index + value.length]
        end

        return [Token.new(type: "operator", value: value), index + value.length]

      end

      nil
    end

    def self.match_string(ps, index)
      result = +""
      i = index + 1 # Skip opening (
      depth = 1

      while i < ps.length && depth.positive?
        case ps[i]
        when "\\"
          # Escape sequence
          i += 1
          break if i >= ps.length

          case ps[i]
          when "n" then result << "\n"
          when "r" then result << "\r"
          when "t" then result << "\t"
          when "b" then result << "\b"
          when "f" then result << "\f"
          when "(" then result << "("
          when ")" then result << ")"
          when "\\" then result << "\\"
          when " " then result << " "
          else
            # Octal: \ddd
            if ps[i].between?("0", "7")
              octal = ps[i]
              i += 1
              if i < ps.length && ps[i] >= "0" && ps[i] <= "7"
                octal += ps[i]
                i += 1
                if i < ps.length && ps[i] >= "0" && ps[i] <= "7"
                  octal += ps[i]
                  i += 1
                end
              end
              code = octal.to_i(8)
              code = 255 if code > 255
              result << code.chr
              i -= 1 # Will be incremented at end of loop
            else
              result << ps[i]
            end
          end
        when "("
          depth += 1
          result << ps[i]
        when ")"
          depth -= 1
          if depth.zero?
            return [Token.new(type: "string", value: result),
                    i + 1]
          end

          result << ps[i]
        else
          result << ps[i]
        end
        i += 1
      end

      [Token.new(type: "string", value: result), i]
    end

    def self.match_hex_string(ps, index)
      i = index + 1
      hex_content = +""

      while i < ps.length && ps[i] != ">"
        hex_content << ps[i] unless ps[i].match?(/\s/)
        i += 1
      end

      # Convert hex to string
      str = +""
      (0...hex_content.length).step(2) do |j|
        byte = hex_content[j, 2]
        str << byte.to_i(16).chr
      end

      [Token.new(type: "hexstring", value: str), i + 1]
    end
  end
end
