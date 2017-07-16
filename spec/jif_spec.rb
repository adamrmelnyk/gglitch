require "spec_helper"

RSpec.describe Jif do
  it "has a version number" do
    expect(Jif::VERSION).not_to be nil
  end

  describe "#initialize" do
    let(:gif) { Jif::Gif.new('spec/test.gif') }

    it "has a header" do
      expect(gif.header).to eq "010001110100100101000110001110000011100101100001"
    end

    it "has a logical screen descriptor" do
      expect(gif.logical_screen_descriptor).to eq "11100010000000010100110000000001111101110000000000000000"
    end

    it "has a global color table" do
      expect(gif.global_color_table[0..15]).to eq "0000111100000011"
      expect(gif.global_color_table[6128..6143]). to eq "1000000001111111"
    end

    it "has an application extension" do
      app_ext = gif.tail[1]
      expect(app_ext[:extension_introducer]).to eq "00100001"
      expect(app_ext[:label]).to eq "11111111"
      expect(app_ext[:skipped_bits]).to eq "0100111001000101010101000101001101000011010000010101000001000101001100100010111000110000"
      expect(app_ext[:sub_blocks]).to eq ["00000011000000010000000000000000", "00000000"]
      expect(app_ext[:total_block_size]).to eq 152
    end

    it "has image data" do
      image_descriptor = gif.tail[2][:image_descriptor]
      image_data = gif.tail[2][:image_data]
      expect(image_descriptor[:image_separator]).to eq "0010110000000000"
      expect(image_descriptor[:image_left]).to eq "0000000000000000"
      expect(image_descriptor[:image_top]).to eq "0000000011100010"
      expect(image_descriptor[:image_width]).to eq "0000000101001100"
      expect(image_descriptor[:image_height]).to eq "00000001"
      expect(image_descriptor[:total_block_size]).to eq 80
      expect(image_data[:lzw_minimum_code_size]).to eq "00001000"
      expect(image_data[:sub_blocks].last).to eq "00000000"
    end

    it "has a graphics control extension" do
      sample_packed_field = {
        reserved_for_future_use: "000",
        disposal_method: "001",
        user_input_flag: "0",
        transparent_color_flag: "0"
      }
      graphics_control_extension = gif.tail[0]
      expect(graphics_control_extension[:extension_introducer]).to eq "00100001"
      expect(graphics_control_extension[:label]).to eq "11111001"
      expect(graphics_control_extension[:delay_time]).to eq "0000101000000000"
      expect(graphics_control_extension[:packed_field]).to eq sample_packed_field
      expect(graphics_control_extension[:total_block_size]).to eq 64
    end
  end

  describe "#rebuild" do
    let(:gif) { Jif::Gif.new('spec/test.gif') }
    let(:original_bits) { File.binread('spec/test.gif').unpack("B*")[0]}

    it "rebuilds without changes produces the same gif" do
      gif.rebuild
      after_bits = File.binread('out.gif').unpack("B*")[0]
      expect(after_bits).to eq original_bits
    end

    it "rebuilding with changes produces a different gif" do
      image_sub_block = gif.tail[2][:image_data][:sub_blocks][2].split("")
      image_sub_block[50] = image_sub_block[50] == "1" ? "0" : "1"
      gif.tail[2][:image_data][:sub_blocks][2] = image_sub_block.join
      gif.rebuild
      after_bits = File.binread('out.gif').unpack("B*")[0]
      expect(after_bits).not_to eq original_bits
    end
  end
end
