# Jif

Analyzer and editor for the GIF89a format written in Ruby without external dependencies. Information about the GIF89a spec can be found [here](https://www.w3.org/Graphics/GIF/spec-gif89a.txt). This gem was made largely as an experiment to edit files on a bit level without breaking them. Consuming this gem currently requires knowledge of the format to be able to change the file without rendering the file unreadable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jif'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jif

## Usage

Instantiate the Gif Object

```ruby
g = Jif::Gif.new('myTestGif.gif')
```

Make any changes you want and rebuild

```ruby
image_sub_block = g.tail[2][:image_data][:sub_blocks][2].split("")
image_sub_block[50] = "0"
g.tail[2][:image_data][:sub_blocks][2] = image_sub_block.join
g.rebuild('myNewGif.gif')
g.rebuild # Defaults to out.gif if no filename is given
```

Gif objects have the following structure:

```ruby
{
  header,
  logical_screen_descriptor,
  packed_field,
  background_color_index,
  pixel_aspect_ratio,
  global_color_table, # If the global_color_table_flag located in the packed field of the LSD is set
  tail # An array of hashes containing either extension or image data blocks
}
```

### Extensions:

#### Graphics Control Extension

```ruby
{
    extension_introducer,
    label, # 0xF9 or 1111 1001
    byte_size,
    packed_field,
    delay_time,
    transparent_color_index,
    block_terminator,
    total_block_size
}
```

#### Plain Text (uncommmon) and Application Extensions (common)

```ruby
{
    extension_introducer,
    label, # 0x01 || 0xFF or 0000 0001 || 1111 1111
    skipped_block_length,
    skipped_bits,
    sub_blocks, # refer to the GIF89a spec for more detailed information
    total_block_size # total number of bits
}
```

#### Comment Extension

```ruby
{
    extension_introducer,
    label, # 0xFE or 1111 1110
    sub_blocks,
    total_block_size
}
```

### Image Descriptor and Data

```ruby
{
    image_descriptor: {
        image_separator, # 0x2C or 0010 1101
        image_left,
        image_top,
        image_width,
        image_height,
        packed_field,
        total_block_size
    },
    local_color_table, # If the local_color_table_flag is present in the previous packed field
    image_data: {
        lzw_minimum_code_size,
        sub_blocks,
        total_block_size
    }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jif. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jif project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jif/blob/master/CODE_OF_CONDUCT.md).
