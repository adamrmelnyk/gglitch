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
