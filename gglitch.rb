s = File.binread("sample_1.gif")
bits = s.unpack("B*")[0]

## Read and store the headers
# header_block = bits[0..47]
logical_screen_descriptor = bits[48..103]
end_of_headers = 103

# unsigned little endian
# canvas_width = logical_screen_descriptor[0..15] # The first two bytes
# canvas_height = logical_screen_descriptor[16..31] # The second two bytes

packed_field = logical_screen_descriptor[32..39]
# background_color_index = logical_screen_descriptor[40..47]
# pixel_aspect_ratio = logical_screen_descriptor[48..74]

#  Breaking up the packed field
global_color_table_flag = packed_field[0]
# color_resolution = packed_field[1..3]
# sort_flag = packed_field[4]
size_of_global_color_table = packed_field[5..7]

# The global color table if present
global_color_table = nil
if global_color_table_flag
  binding.pry
  gc_table_size = 3 * 2**((size_of_global_color_table).to_i(2)+1)
  global_color_table_end = (gc_table_size * 8) + end_of_headers
  global_color_table = bits[end_of_headers..global_color_table_end]
  end_of_headers = global_color_table_end
end

## Optional Extensions
# 0x21
def which_extension byte
  # TODO: Create all the cases for each type of byte
end

# Graphics control extension
# 0xF9
def graphics_control_extension_parser bits
  {
    extension_introducer: bits[0..7],
    graphic_control_label: bits[8..15],
    byte_size: bits[16..23],
    packed_field: {
      reserved_for_future_use: bits[24..26],
      disposal_method: bits[27..29],
      user_input_flag: bits[30],
      transparent_color_flag: bits[31]
    },
    delay_time: bits[32..47],
    transparent_colour_index: bits[48..55],
    block_terminator: bits[56..63],
  }
end

# Plain Text Extension
# 0x01
def plain_text_extension_parser bits
  {
    extension_introducer: bits[0..7],
    plain_text_label: bits[7..15],
    block_size_until_text: bits[16..23], # blocks to skip until actual text data
    sub_blocks: {},
  }
end

# Application Extension
# 0xFF
def application_extension_parser bits
  {
    extension_introducer: bits[0..7],
    application_extension_label: bits[7..15],
    application_block_length: bits[16..23], # We can ignore these bytes 
    sub_blocks: {},
  }
end

# Comment Extension
# 0xFE
def comment_extension_parser
  {
    extension_introducer: bits[0..7],
    comment_extension_label: bits[7..15],
    sub_blocks: {},
  }
end

# Image Descriptor
# 0x2C
def image_descriptor bits
  {
    image_seperator: bits[0..15],
    image_left: bits[16..31],
    image_top: bits[32..47],
    image_width: bits[48..63],
    image_height: bits[64..71],
    packed_field: {
      local_color_table_flag: bits[72],
      interlace_flag: bits[73],
      sort_flag: bits[74],
      reserved_for_future_use: bits[75..76],
      size_of_local_color_table: bits[77..79],
    },
  }
end

# Local color table
# exactly the same as the global color table
def color_table(bits, size)
  color_table = {}
  # for size, add color
  # It would be nead if we named the entries in the hash dynamically
  # ie color0, color1, color2, color3, etc.
  return color_table
end

# Image data
def image_data bits
  image_data = {
    lzw_minimum_code_size: bits[0..7],
    sub_blocks: {},
  }
  # TODO: Loop for sub blocks
  # First gives use the size of the subblock
  # End when we get to something that has a subblock size of x/00
  # NOTE: It will probably need another method for adding the subblocks
  return image_data
end

# TODO: read the rest of the bits checking first for the extensions

# Trailer, gif ends with x3B
def b_to_h binary_string
  "0x%02x" % binary_string.to_i(2)
end
