# ARLeftOverGuardian - Active Record Left Over Guardian

Meant to be run after each test. Fails your test suite, if test doesn't clean up any database records after itself. Assumes all your models are descendants of ActiveRecord::Base.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ar_left_over_guardian'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar_left_over_guardian

## Usage

Just make sure that it is run in the end of each of your tests.

### Usage with rspec

```ruby
require 'ar_left_over_guardian'

RSpec.configure do |config|
  left_over_guardian = ARLeftOverGuardian.init(ActiveRecord::Base.descendants)

  # ...

  # last .after block
  config.after do
    left_over_guardian.verify
  end
end
```

## Contributing

1. Fork it ( https://github.com/waterlink/ar_left_over_guardian/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
