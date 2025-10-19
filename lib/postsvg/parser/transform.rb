# frozen_string_literal: true

require "parslet"

module Postsvg
  class Parser
    # Transforms parsed PostScript AST into Ruby data structures
    class Transform < Parslet::Transform
      rule(integer: simple(:i)) { i.to_i }
      rule(float: simple(:f)) { f.to_f }
      rule(string: simple(:s)) { s.to_s }
      rule(name: simple(:n)) { { type: :name, value: n.to_s.sub(%r{^/}, "") } }
      rule(operator: simple(:o)) { { type: :operator, value: o.to_s } }
      rule(array: sequence(:items)) { { type: :array, value: items } }
      rule(procedure: subtree(:items)) { { type: :procedure, value: items } }
      rule(program: subtree(:statements)) do
        { type: :program, statements: statements }
      end
    end
  end
end
