# frozen_string_literal: true

RSpec.describe "Postsvg Integration Tests" do
  describe "EPS to SVG conversion" do
    it "converts img.eps to match reference SVG" do
      input_path = "spec/fixtures/eps2svg/img.eps"
      expected_path = "spec/fixtures/eps2svg/ref.svg"

      input_content = File.read(input_path)
      expected_svg = File.read(expected_path)

      actual_svg = Postsvg.convert(input_content)

      expect(actual_svg).to be_xml_equivalent_to(expected_svg)
    end
  end

  describe "PS to SVG conversion" do
    describe "ps2svg test suite" do
      it "converts colors.ps to match expected SVG" do
        input_path = "spec/fixtures/ps2svg/colors.ps"
        expected_path = "spec/fixtures/ps2svg/colors_expected.svg"

        input_content = File.read(input_path)
        expected_svg = File.read(expected_path)

        actual_svg = Postsvg.convert(input_content)

        expect(actual_svg).to be_xml_equivalent_to(expected_svg)
      end

      it "converts example_full.ps to match expected SVG" do
        input_path = "spec/fixtures/ps2svg/example_full.ps"
        expected_path = "spec/fixtures/ps2svg/example_full_expected.svg"

        input_content = File.read(input_path)
        expected_svg = File.read(expected_path)

        actual_svg = Postsvg.convert(input_content)

        expect(actual_svg).to be_xml_equivalent_to(expected_svg)
      end

      it "converts file.ps to match expected SVG" do
        input_path = "spec/fixtures/ps2svg/file.ps"
        expected_path = "spec/fixtures/ps2svg/file_expected.svg"

        input_content = File.read(input_path)
        expected_svg = File.read(expected_path)

        actual_svg = Postsvg.convert(input_content)

        expect(actual_svg).to be_xml_equivalent_to(expected_svg)
      end

      it "converts prog.ps to match expected SVG" do
        input_path = "spec/fixtures/ps2svg/prog.ps"
        expected_path = "spec/fixtures/ps2svg/prog_expected.svg"

        input_content = File.read(input_path)
        expected_svg = File.read(expected_path)

        actual_svg = Postsvg.convert(input_content)

        expect(actual_svg).to be_xml_equivalent_to(expected_svg)
      end

      it "converts img.ps to match reference SVG" do
        input_path = "spec/fixtures/ps2svg/img.ps"
        expected_path = "spec/fixtures/ps2svg/ref.svg"

        input_content = File.read(input_path)
        expected_svg = File.read(expected_path)

        actual_svg = Postsvg.convert(input_content)

        expect(actual_svg).to be_xml_equivalent_to(expected_svg)
      end
    end
  end
end
