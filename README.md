# Ouidb

Database of Organizationally Unique Identifiers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ouidb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ouidb
    
## Usage
    
Make yourself a data file:

    { curl http://standards-oui.ieee.org/oui.txt && \
      curl http://standards-oui.ieee.org/iab/iab.txt && \
      curl http://standards-oui.ieee.org/oui36/oui36.txt; } | \
      ouidb > my_data_file.json
       
And you're good to go. Test it on your local MACs:

    ifconfig | grep -Eoe '[0-9a-f]{2}(:[0-9a-f]{2}){5}' | sort -u | ouidb my_data_file.json
    
The Ruby interface is quite simple:

```ruby
require 'ouidb'
Ouidb.load_file 'my_data_file.json'

# Cutting to the chase, for 99% of users:

Ouidb.manufacturer_name '00:cd:fe:11:22:33'
# => "Apple, Inc."

# If you want to explore a bit:

range = Ouidb.lookup('00CDFE11:22-33') # Non-hex characters are ignored
# => #<Range24 cd:fe:00:00:00:00/24 Apple, Inc.>

range.manufacturer.name
# => "Apple, Inc."

range.manufacturer.ranges.length
# => 531
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hx/ouidb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

