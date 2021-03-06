[![Gem Version](https://badge.fury.io/rb/banhpho.svg)](https://badge.fury.io/rb/banhpho)

# Banh Pho

A wrapper of [pngquant](https://pngquant.org/) for compressing all PNG files in a directory.

## Dependency

Make sure you already download [pngquant](https://pngquant.org/releases.html) and put its location in `PATH` so `banhpho` can locate the executable.

## Installation

    $ gem install banhpho

## Usage

    $ banhpho compress [DIR]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/heartace/banhpho.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

